package com.group17.SmartLocker.config;

import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.group17.SmartLocker.Util.KeyStorePasswordPair;
import com.group17.SmartLocker.Util.KeyStoreUtil;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;


@Configuration
public class AwsIotConfig {

    private static final String CLIENT_ENDPOINT = "a1u0d4dqvjvus1-ats.iot.ap-southeast-1.amazonaws.com";
    private static final String CLIENT_ID = "3YP-device";
    private static final String CERT = "SmartLocker/src/main/resources/certs/device-cert.pem.crt";
    private static final String KEY = "SmartLocker/src/main/resources/certs/private-key.pem";


    @Bean
    public AWSIotMqttClient awsIotMqttClient() throws Exception{

//        System.out.println("awsIotMqttClient");
        KeyStorePasswordPair pair = KeyStoreUtil.getKeyStorePasswordPair(CERT, KEY);
        return new AWSIotMqttClient(
                CLIENT_ENDPOINT,
                CLIENT_ID,
                pair.keyStore,
                new String(pair.keyPassword)
        );

    }
}
