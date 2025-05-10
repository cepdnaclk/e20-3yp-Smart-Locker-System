package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.service.mqtt.MqttPubSubService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class MQTTController {

    @Autowired
    MqttPubSubService service;

    @PostMapping("/publish")
    public String publishMessage(){
        service.publishMessage();
        return "message published successfully";
    }

}
