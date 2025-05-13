package com.group17.SmartLocker.service.mqtt;

import com.amazonaws.services.iot.client.AWSIotException;
import com.amazonaws.services.iot.client.AWSIotMqttClient;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AwsIotConnector {

    private final AWSIotMqttClient mqttClient;

    @PostConstruct
    public void connect(){
        try {
            mqttClient.connect();
        } catch (AWSIotException e) {
            System.err.println("Failed to connect AWS IoT: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
