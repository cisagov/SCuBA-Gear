package exo_test
import future.keywords
import data.exo
import data.utils.report.ReportDetailsBoolean


CorrectTestResult(PolicyId, Output, ReportDetailString) := true if {
    RuleOutput := [Result | some Result in Output; Result.PolicyId == PolicyId]

    count(RuleOutput) == 1
    RuleOutput[0].RequirementMet == true
    RuleOutput[0].ReportDetails == ReportDetailString
} else := false

IncorrectTestResult(PolicyId, Output, ReportDetailString) := true if {
    RuleOutput := [Result | some Result in Output; Result.PolicyId == PolicyId]

    count(RuleOutput) == 1
    RuleOutput[0].RequirementMet == false
    RuleOutput[0].ReportDetails == ReportDetailString
} else := false

PASS := ReportDetailsBoolean(true)


#
# Policy 1
#--
test_FromScope_Correct if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "NotInOrganization",
                "State": "Enabled",
                "Mode": "Enforce",
                "PrependSubject": "External"
            }
        ]
    }

    CorrectTestResult("MS.EXO.7.1v1", Output, PASS) == true
}

test_FromScope_Incorrect_V1 if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "",
                "State": "Enabled",
                "Mode": "Audit",
                "PrependSubject": "External"
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}

test_FromScope_Incorrect_V2 if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "NotInOrganization",
                "State": "Disabled",
                "Mode": "Audit",
                "PrependSubject": "External"
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}

test_FromScope_Incorrect_V3 if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "",
                "State": "Enabled",
                "Mode": "AuditAndNotify",
                "PrependSubject": "External"
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}

test_FromScope_Incorrect_V4 if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "NotInOrganization",
                "State": "Disabled",
                "Mode": "AuditAndNotify",
                "PrependSubject": "External"
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}

test_FromScope_Multiple_Correct if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "",
                "State": "Disabled",
                "Mode": "Enforce",
                "PrependSubject": "External"
            },
            {
                "FromScope": "",
                "State": "Enabled",
                "Mode": "Audit",
                "PrependSubject": "External"
            },
            {
                "FromScope": "",
                "State": "Enabled",
                "Mode": "AuditAndNotify",
                "PrependSubject": "External"
            },
            {
                "FromScope": "NotInOrganization",
                "State": "Enabled",
                "Mode": "Enforce",
                "PrependSubject": "External"
            }
        ]
    }

    CorrectTestResult("MS.EXO.7.1v1", Output, PASS) == true
}

test_FromScope_Multiple_Incorrect if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "",
                "State": "Enabled",
                "Mode": "Enforce",
                "PrependSubject": "External"
            },
            {
                "FromScope": "Hello there",
                "State": "Enabled",
                "Mode": "Audit",
                "PrependSubject": "External"
            },
            {
                "FromScope": "Hello there",
                "State": "Enabled",
                "Mode": "AuditAndNotify",
                "PrependSubject": "External"
            },
            {
                "FromScope": "NotInOrganization",
                "State": "Enabled",
                "Mode": "Audit",
                "PrependSubject": "External"
            },
            {
                "FromScope": "NotInOrganization",
                "State": "Enabled",
                "Mode": "AuditAndNotify",
                "PrependSubject": "External"
            },
            {
                "FromScope": "NotInOrganization",
                "State": "Disabled",
                "Mode": "Enforce",
                "PrependSubject": "External"
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}

test_PrependSubject_IncorrectV1 if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "NotInOrganization",
                "State": "Enabled",
                "Mode": "Enforce",
                "PrependSubject": null
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}

test_PrependSubject_IncorrectV2 if {
    Output := exo.tests with input as {
        "transport_rule": [
            {
                "FromScope": "NotInOrganization",
                "State": "Enabled",
                "Mode": "Enforce",
                "PrependSubject": ""
            }
        ]
    }

    ReportDetailString := "No transport rule found that applies warnings to emails received from outside the organization"
    IncorrectTestResult("MS.EXO.7.1v1", Output, ReportDetailString) == true
}
#--