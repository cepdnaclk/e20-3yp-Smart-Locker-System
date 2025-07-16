package com.group17.SmartLocker.service.mqtt;

import com.amazonaws.services.iot.client.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class MqttSubscriber {

    private final AWSIotMqttClient awsIotMqttClient;
    private final MessageHandler messageHandler;

    // Store latest message per topic
    private final Map<String, String> latestMessages = new ConcurrentHashMap<>();

    public void subscribeToTopic(String topicName) throws Exception {
        if (awsIotMqttClient.getConnectionStatus().name().equalsIgnoreCase("DISCONNECTED")) {
            awsIotMqttClient.connect();
        }

        AWSIotTopic topic = new AWSIotTopic(topicName, AWSIotQos.QOS0) {
            @Override
            public void onMessage(AWSIotMessage message) {
                String payload = message.getStringPayload();
                latestMessages.put(topicName, payload);

                // trigger a service method to handle the messages
                messageHandler.handleIncomingMessage(topicName, payload);

                System.out.println("Received message on topic [" + getTopic() + "]: " + payload);
            }
        };

        awsIotMqttClient.subscribe(topic, true);
        System.out.println("Subscribed to topic: " + topicName);
    }

    public String getLatestMessage(String topicName) {
        return latestMessages.getOrDefault(topicName, "No message received yet.");
    }
}
