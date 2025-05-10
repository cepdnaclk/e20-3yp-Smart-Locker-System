package com.group17.SmartLocker.config;

import com.amazonaws.services.iot.client.AWSIotMqttClient;

public class MqttConfig {

    String clientEndpoint = "a1u0d4dqvjvus1-ats.iot.ap-southeast-1.amazonaws.com";   // use value returned by describe-endpoint --endpoint-type "iot:Data-ATS"
    String clientId = "3YP-device";// replace with your own client ID. Use unique client IDs for concurrent connections.
    String awsAccessKeyId = "";
    String awsSecretAccessKey = "";
    // AWS IAM credentials could be retrieved from AWS Cognito, STS, or other secure sources
    AWSIotMqttClient client = new AWSIotMqttClient(clientEndpoint, clientId, awsAccessKeyId, awsSecretAccessKey, null);

    // optional parameters can be set before connect()
    client.connect();
}
