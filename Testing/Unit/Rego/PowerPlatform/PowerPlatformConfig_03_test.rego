package powerplatform_test
import future.keywords
import data.powerplatform
import data.report.utils.NotCheckedDetails


#
# Policy 1
#--
test_isDisabled_Correct if {
    PolicyId := "MS.POWERPLATFORM.3.1v1"

    Output := powerplatform.tests with input as {
        "tenant_isolation": [
            {
                "properties": {
                    "isDisabled": false
                }
            }
        ]
    }

    RuleOutput := [Result | some Result in Output; Result.PolicyId == PolicyId]

    count(RuleOutput) == 1
    RuleOutput[0].RequirementMet == true
    RuleOutput[0].ReportDetails == "Requirement met"
}

test_isDisabled_Incorrect if {
    PolicyId := "MS.POWERPLATFORM.3.1v1"

    Output := powerplatform.tests with input as {
        "tenant_isolation": [
            {
                "properties": {
                    "isDisabled": true
                }
            }
        ]
    }

    RuleOutput := [Result | some Result in Output; Result.PolicyId == PolicyId]

    count(RuleOutput) == 1
    RuleOutput[0].RequirementMet == false
    RuleOutput[0].ReportDetails == "Requirement not met"
}
#--

#
# Policy 2
#--
test_NotImplemented_Correct if {
    PolicyId := "MS.POWERPLATFORM.3.2v1"

    Output := powerplatform.tests with input as { }

    RuleOutput := [Result | some Result in Output; Result.PolicyId == PolicyId]

    count(RuleOutput) == 1
    RuleOutput[0].RequirementMet == false
    RuleOutput[0].ReportDetails == NotCheckedDetails(PolicyId)
}
#--