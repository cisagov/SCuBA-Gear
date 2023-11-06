package utils.defender
import future.keywords

##########################################
# User/Group Exclusion support functions #
##########################################

# Gets Sensitive Account Filter specification from SCuBA config input
# and handle case where config does not exist
SensitiveAccountsConfig(PolicyID) := {
    "IncludedUsers": IncludedUsers,
    "ExcludedUsers": ExcludedUsers,
    "IncludedGroups": IncludedGroups,
    "ExcludedGroups": ExcludedGroups,
    "IncludedDomains": IncludedDomains,
    "ExcludedDomains": ExcludedDomains
} if {
    SensitiveAccounts := input.scuba_config.Defender[PolicyID].SensitiveAccounts
    IncludedUsers := {trim_space(x) | some x in SensitiveAccounts.IncludedUsers; x != null}
    ExcludedUsers := {trim_space(x) | some x in SensitiveAccounts.ExcludedUsers; x != null}
    IncludedGroups := {trim_space(x) | some x in SensitiveAccounts.IncludedGroups; x != null}
    ExcludedGroups := {trim_space(x) | some x in SensitiveAccounts.ExcludedGroups; x != null}
    IncludedDomains := {trim_space(x) | some x in SensitiveAccounts.IncludedDomains; x != null}
    ExcludedDomains := {trim_space(x) | some x in SensitiveAccounts.ExcludedDomains; x != null}
} else := {
    "IncludedUsers": set(),
    "ExcludedUsers": set(),
    "IncludedGroups": set(),
    "ExcludedGroups": set(),
    "IncludedDomains": set(),
    "ExcludedDomains": set()
}

# Gets Sensitive Account Filter specified in policy input
SensitiveAccountsSetting(Policies) := {
    "IncludedUsers": IncludedUsers,
    "ExcludedUsers": ExcludedUsers,
    "IncludedGroups": IncludedGroups,
    "ExcludedGroups": ExcludedGroups,
    "IncludedDomains": IncludedDomains,
    "ExcludedDomains": ExcludedDomains,
    "Policy": Policy
} if {
    Policy := [Policy | some Policy in Policies; Policy.Identity == "Strict Preset Security Policy"; Policy.State == "Enabled"][0]
    IncludedUsers := {x | some x in Policy.SentTo}
    ExcludedUsers := {x | some x in Policy.ExceptIfSentTo}
    IncludedGroups := {x | some x in Policy.SentToMemberOf}
    ExcludedGroups := {x | some x in Policy.ExceptIfSentToMemberOf}
    IncludedDomains := {x | some x in Policy.RecipientDomainIs}
    ExcludedDomains := {x | some x in Policy.ExceptIfRecipientDomainIs}
}

default SensitiveAccounts(_, _) := false

### Case 1 - No Strict Policy assignment ###
# Is there a Strict Policy present, if not always fail
SensitiveAccounts(SensitiveAccountsSetting, _) := false if {
    count(SensitiveAccountsSetting.Policy) == 0
}

### Case 2 ###
# Is there a Strict Policy present and no assignment conditions or exceptions, all users included. Always pass
SensitiveAccounts(SensitiveAccountsSetting, _) := true if {
    count(SensitiveAccountsSetting.Policy) > 0
    SensitiveAccountsSetting.Policy.Conditions == null
    SensitiveAccountsSetting.Policy.Exceptions == null
}

### Case 3 ###
# Is there a Strict Policy present and assignment conditions, but no include config.  Always fail
SensitiveAccounts(SensitiveAccountsSetting, SensitiveAccountsConfig) := false if {
    count(SensitiveAccountsSetting.Policy) > 0

    # Policy filter includes one or more conditions or exclusions
    ConditionsAbsent := [
        SensitiveAccountsSetting.Policy.Conditions == null,
        SensitiveAccountsSetting.Policy.Exceptions == null
    ]
    count([Condition | some Condition in ConditionsAbsent; Condition == false]) > 0

    # No config is defined (unify all sets & check if empty)
    count(
        SensitiveAccountsConfig.IncludedUsers |
        SensitiveAccountsConfig.ExcludedUsers |
        SensitiveAccountsConfig.IncludedGroups |
        SensitiveAccountsConfig.ExcludedGroups |
        SensitiveAccountsConfig.IncludedDomains |
        SensitiveAccountsConfig.ExcludedDomains) == 0
}

### Case 4 ###
# When settings and config are present, do they match?
SensitiveAccounts(SensitiveAccountsSetting, SensitiveAccountsConfig) := true if {
    count(SensitiveAccountsSetting.Policy) > 0

    # Policy filter includes one or more conditions or exclusions
    ConditionsAbsent := [
        SensitiveAccountsSetting.Policy.Conditions == null,
        SensitiveAccountsSetting.Policy.Exceptions == null
    ]
    count([Condition | some Condition in ConditionsAbsent; Condition == false]) > 0

    # Config is defined (unify all sets & check if not empty)
    count(
        SensitiveAccountsConfig.IncludedUsers |
        SensitiveAccountsConfig.ExcludedUsers |
        SensitiveAccountsConfig.IncludedGroups |
        SensitiveAccountsConfig.ExcludedGroups |
        SensitiveAccountsConfig.IncludedDomains |
        SensitiveAccountsConfig.ExcludedDomains) > 0

    # All filter and config file settings mismatches
    Mismatches := [
        SensitiveAccountsSetting.IncludedUsers == SensitiveAccountsConfig.IncludedUsers,
        SensitiveAccountsSetting.IncludedGroups == SensitiveAccountsConfig.IncludedGroups,
        SensitiveAccountsSetting.IncludedDomains == SensitiveAccountsConfig.IncludedDomains,
        SensitiveAccountsSetting.ExcludedUsers == SensitiveAccountsConfig.ExcludedUsers,
        SensitiveAccountsSetting.ExcludedGroups == SensitiveAccountsConfig.ExcludedGroups,
        SensitiveAccountsSetting.ExcludedDomains == SensitiveAccountsConfig.ExcludedDomains
    ]
    count([Mismatch | some Mismatch in Mismatches; Mismatch == false]) == 0
}

##############################################
# Impersonation protection support functions #
##############################################

# Get enabled policy that matches the string & key value
ImpersonationProtectionSetting(Policies, IdentityString, KeyValue) := Policy if {
    Policy := [
    Policy |
        some Policy in Policies
        regex.match(IdentityString, Policy.Identity) == true
        Policy.Enabled == true
        Policy[KeyValue] == true
    ][0]
} else := set()

# Get the user configuration for specified policy
ImpersonationProtectionConfig(PolicyID, AccountKey) := IncludedAccounts if {
    SensitiveAccounts := input.scuba_config.Defender[PolicyID]
    IncludedAccounts := {lower(trim_space(x)) | some x in SensitiveAccounts[AccountKey]; x != null}
} else := set()

# Check impersonation protection is set for specified policy & accounts
ImpersonationProtection(Policies, IdentityString, IncludedAccounts, FilterKey, AccountKey, ActionKey) := {
    "Result": true,
    "Policy": {
        "Name": Policy.Identity,
        "Accounts": PolicyProtectedAccounts,
        "Action": Policy[ActionKey]
    }
} if {
    Policy := ImpersonationProtectionSetting(Policies, IdentityString, FilterKey)
    count(Policy) > 0

    PolicyProtectedAccounts := {lower(x) | some x in Policy[AccountKey]}
    count(IncludedAccounts - PolicyProtectedAccounts) == 0

    Conditions := [
        (count(IncludedAccounts) > 0) == (count(PolicyProtectedAccounts) > 0),
        (count(IncludedAccounts) == 0) == (count(PolicyProtectedAccounts) == 0)
    ]
    count([Condition | some Condition in Conditions; Condition == true]) > 0
} else := {
    "Result": false,
    "Policy": {
        "Name": IdentityString,
        "Accounts": set(),
        "Action": ""
    }
}
