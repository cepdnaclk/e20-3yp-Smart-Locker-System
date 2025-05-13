package com.group17.SmartLocker.service.mqtt;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MqttSubscriptions {

    private final MqttSubscriber mqttSubscriber;

    @PostConstruct
    public void subscribeToTopics() throws Exception {
        try {
            mqttSubscriber.subscribeToTopic("esp32/getPassword");
            mqttSubscriber.subscribeToTopic("esp32/assignFingerprint");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


}
