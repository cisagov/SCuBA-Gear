package powerplatform_test
import future.keywords
import data.powerplatform
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

FAIL := ReportDetailsBoolean(false)

PASS := ReportDetailsBoolean(true)

#
# Policy 1
#--
test_name_Correct if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "displayName": "Block Third-Party Connectors",
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    CorrectTestResult("MS.POWERPLATFORM.2.1v1", Output, PASS) == true
}

test_name_Incorrect if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "displayName": "Block Third-Party Connectors",
                        "environments": [
                            {
                                "name": "NotDefault-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    ReportDetailString := "No policy found that applies to default environment"
    IncorrectTestResult("MS.POWERPLATFORM.2.1v1", Output, ReportDetailString) == true
}
#--

#
# Policy 2
#--
test_environment_list_Correct if {
    Output := powerplatform.tests with input as {
        "dlp_policies": [
            {
                "value": [
                    {
                        "displayName": "Block Third-Party Connectors",
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ],
        "environment_list": [
            {
                "EnvironmentName": "Default-Test Id"
            }
        ]
    }

    CorrectTestResult("MS.POWERPLATFORM.2.2v1", Output, PASS) == true
}

test_environment_list_Incorrect if {
    Output := powerplatform.tests with input as {
        "dlp_policies": [
            {
                "value": [
                    {
                        "displayName": "Block Third-Party Connectors",
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ],
        "environment_list": [
            {
                "EnvironmentName": "Default-Test Id"
            },
            {
                "EnvironmentName": "Test1"
            }
        ]
    }

    ReportDetailString := "1 Subsequent environments without DLP policies: Test1"
    IncorrectTestResult("MS.POWERPLATFORM.2.2v1", Output, ReportDetailString) == true
}
#--

#
# Policy 3
#--
test_classification_Correct_V1 if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "connectorGroups": [
                            {
                                "classification": "Confidential",
                                "connectors": [
                                    {
                                        "id": "/providers/Microsoft.PowerApps/apis/shared_powervirtualagents"
                                    }
                                ]
                            }
                        ],
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    CorrectTestResult("MS.POWERPLATFORM.2.3v1", Output, PASS) == true
}

test_classification_Correct_V2 if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "connectorGroups": [
                            {
                                "classification": "General",
                                "connectors": [
                                    {
                                        "id": "/providers/Microsoft.PowerApps/apis/shared_powervirtualagents"
                                    }
                                ]
                            }
                        ],
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    CorrectTestResult("MS.POWERPLATFORM.2.3v1", Output, PASS) == true
}

test_connectorGroups_Correct if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "connectorGroups": [
                            {
                                "classification": "Confidential",
                                "connectors": [
                                    {
                                        "id": "/providers/Microsoft.PowerApps/apis/shared_powervirtualagents"
                                    }
                                ]
                            },
                            {
                                "classification": "General",
                                "connectors": [
                                    {
                                        "id": "/providers/Microsoft.PowerApps/apis/shared_powervirtualagents"
                                    }
                                ]
                            }
                        ],
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    CorrectTestResult("MS.POWERPLATFORM.2.3v1", Output, PASS) == true
}

test_classification_Incorrect_V1 if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "connectorGroups": [
                            {
                                "classification": "Confidential",
                                "connectors": [
                                    {
                                        "id": "HttpWebhook"
                                    }
                                ]
                            }
                        ],
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    ReportDetailString := "1 Connectors are allowed that should be blocked: HttpWebhook"
    IncorrectTestResult("MS.POWERPLATFORM.2.3v1", Output, ReportDetailString) == true
}

test_classification_Incorrect_V2 if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "connectorGroups": [
                            {
                                "classification": "General",
                                "connectors": [
                                    {
                                        "id": "HttpWebhook"
                                    }
                                ]
                            }
                        ],
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    ReportDetailString := "1 Connectors are allowed that should be blocked: HttpWebhook"
    IncorrectTestResult("MS.POWERPLATFORM.2.3v1", Output, ReportDetailString) == true
}

test_connectorGroups_Incorrect if {
    Output := powerplatform.tests with input as {
        "tenant_id": "Test Id",
        "dlp_policies": [
            {
                "value": [
                    {
                        "connectorGroups": [
                            {
                                "classification": "Confidential",
                                "connectors": [
                                    {
                                        "id": "HttpWebhook"
                                    }
                                ]
                            },
                            {
                                "classification": "General",
                                "connectors": [
                                    {
                                        "id": "HttpWebhook"
                                    }
                                ]
                            }
                        ],
                        "environments": [
                            {
                                "name": "Default-Test Id"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    ReportDetailString := "1 Connectors are allowed that should be blocked: HttpWebhook"
    IncorrectTestResult("MS.POWERPLATFORM.2.3v1", Output, ReportDetailString) == true
}
#--