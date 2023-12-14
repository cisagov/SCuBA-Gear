package teams_test
import future.keywords
import data.teams
import data.utils.report.DefenderMirrorDetails
import data.utils.policy.TestResult


#
# Policy MS.TEAMS.8.1v1
#--
test_3rdParty_Correct_V1 if {
    PolicyId := "MS.TEAMS.8.1v1"

    Output := teams.tests with input as { }

    TestResult(PolicyId, Output, DefenderMirrorDetails(PolicyId), false) == true
}
#--

#
# Policy MS.TEAMS.8.2v1
#--
test_3rdParty_Correct_V2 if {
    PolicyId := "MS.TEAMS.8.2v1"

    Output := teams.tests with input as { }

    TestResult(PolicyId, Output, DefenderMirrorDetails(PolicyId), false) == true
}
#--