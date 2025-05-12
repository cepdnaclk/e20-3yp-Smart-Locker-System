package com.group17.SmartLocker.service.mqtt;

import com.amazonaws.services.iot.client.AWSIotMessage;
import com.amazonaws.services.iot.client.AWSIotQos;
import com.amazonaws.services.iot.client.AWSIotTopic;

public class CustomTopicListener extends AWSIotTopic {
    public CustomTopicListener(String topic, AWSIotQos qos) {
        super(topic, qos);
    }

    @Override
    public void onMessage(AWSIotMessage message){
        System.out.println("Received: " + message.getStringPayload());
    }
}
