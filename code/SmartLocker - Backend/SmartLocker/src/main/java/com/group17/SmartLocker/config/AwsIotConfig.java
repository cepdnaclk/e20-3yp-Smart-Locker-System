package com.group17.SmartLocker.config;

import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.group17.SmartLocker.util.KeyStorePasswordPair;
import com.group17.SmartLocker.util.KeyStoreUtil;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AwsIotConfig {

    private static final String CLIENT_ENDPOINT = "YOUR_ENDPOINT.iot.REGION.amazonaws.com"; // No "https://"
    private static final String CLIENT_ID = "SmartLockerBackend";
    private static final String CERT = "SmartLocker/src/main/resources/certs/device-cert.pem.crt";
    private static final String KEY = "SmartLocker/src/main/resources/certs/private-key.pem";

    @Bean
    public AWSIotMqttClient awsIotMqttClient() throws Exception {
        KeyStorePasswordPair pair = KeyStoreUtil.getKeyStorePasswordPair(CERT, KEY);
        AWSIotMqttClient client = new AWSIotMqttClient(
                CLIENT_ENDPOINT,
                CLIENT_ID,
                pair.keyStore,
                new String(pair.keyPassword)
        );
        client.connect(); // Optionally move this to a @PostConstruct method in another service
        return client;
    }
}
