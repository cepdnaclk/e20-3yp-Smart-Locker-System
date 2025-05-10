package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.service.mqtt.MqttPublisher;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class MqttController {

    private final MqttPublisher publisher;

    @PostMapping("/publish")
    public String publish() throws Exception {
        publisher.publish("/3yp/batch2022/device1", "{\"message\":\"Springboot backend\"}");
        return "Message sent success";
    }

}
