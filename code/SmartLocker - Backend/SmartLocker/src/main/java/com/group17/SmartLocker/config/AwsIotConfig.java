package com.group17.SmartLocker.config;

import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.group17.SmartLocker.Util.KeyStorePasswordPair;
import com.group17.SmartLocker.Util.KeyStoreUtil;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.InputStream;
import java.util.UUID;


@Configuration
public class AwsIotConfig {

    private static final String CLIENT_ENDPOINT = "a1u0d4dqvjvus1-ats.iot.ap-southeast-1.amazonaws.com";
//    private static final String CLIENT_ID = "3YP-device";

    /*
    * When multiple clients try to connect the same IoT thing the connection will establish and
    * lost over and oer again. When one connection is lost, another connection will establish.
    * Therefore UUID.randomUUID() added to the client id
    */
    private static final String CLIENT_ID = "3YP-device" + UUID.randomUUID();

//    private static final String CERT = "SmartLocker/src/main/resources/certs/device-cert.pem.crt";
//    private static final String KEY = "SmartLocker/src/main/resources/certs/private-key.pem";


    @Bean
    public AWSIotMqttClient awsIotMqttClient() throws Exception{

        // Load cert and key from classpath
        InputStream CERT = getClass().getClassLoader().getResourceAsStream("certs/device-cert.pem.crt");
        InputStream KEY = getClass().getClassLoader().getResourceAsStream("certs/private-key.pem");

        if (CERT == null || KEY == null) {
            throw new RuntimeException("Certificate or key file not found in resources/certs/");
        }

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
