package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.service.mqtt.MqttPublisher;
import com.group17.SmartLocker.service.mqtt.MqttSubscriber;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class MqttController {

    private final MqttPublisher publisher;
    private final MqttSubscriber mqttSubscriber;

    @PostMapping("/publish")
    public String publish() throws Exception {
        publisher.publish("/3yp/batch2022/device1", "{\"message\":\"Springboot backend\"}");
        return "Message sent success";
    }

    @PostMapping("/subscribe")
    public String subscribeToTopic(@RequestParam String topic) {
        try {
            mqttSubscriber.subscribeToTopic(topic);
            return "Subscribed to topic: " + topic;
        } catch (Exception e) {
            return "Failed to subscribe: " + e.getMessage();
        }
    }

    @GetMapping("/latest")
    public String getLatestMessage(@RequestParam String topic) {
        return mqttSubscriber.getLatestMessage(topic);
    }

}
