package com.group17.SmartLocker.service.mqtt;

import com.amazonaws.services.iot.client.AWSIotMessage;
import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.amazonaws.services.iot.client.AWSIotQos;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MqttPublisher {

    private final AWSIotMqttClient mqttClient;

    public void publish(String topic, String message) throws Exception{
        AWSIotMessage mqttMessage = new AWSIotMessage(topic, AWSIotQos.QOS0, message);
        mqttClient.publish(mqttMessage);
    }
}
