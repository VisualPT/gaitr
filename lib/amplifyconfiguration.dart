const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Gaiter": {
                    "endpointType": "GraphQL",
                    "endpoint": "http://192.168.0.247:20002/graphql",
                    "region": "us-east-1",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-fakeApiId123456"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "http://192.168.0.247:20002/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-fakeApiId123456",
                        "ClientDatabasePrefix": "Gaiter_API_KEY",
                        "DangerouslyConnectToHTTPEndpointForTesting": true
                    },
                    "Gaiter_AWS_IAM": {
                        "ApiUrl": "http://192.168.0.247:20002/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "Gaiter_AWS_IAM",
                        "DangerouslyConnectToHTTPEndpointForTesting": true
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:06f94632-1866-4d1f-804d-6e5ff5e1f102",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_EPWKXjemv",
                        "AppClientId": "1ub11739jgq00fourkr5um9qom",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS",
                                "REQUIRES_UPPERCASE"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "content-staging",
                        "Region": "us-east-1",
                        "DangerouslyConnectToHTTPEndpointForTesting": true
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "content-staging",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';