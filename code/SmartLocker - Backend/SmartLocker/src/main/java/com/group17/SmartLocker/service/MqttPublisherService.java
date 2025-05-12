//package com.group17.SmartLocker.service;
//
//import com.group17.SmartLocker.Util.SslUtil;
//import jakarta.annotation.PostConstruct;
//import org.eclipse.paho.client.mqttv3.*;
//import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//import javax.net.ssl.SSLSocketFactory;
//import java.nio.file.Files;
//import java.nio.file.Paths;
//
//import static jdk.dynalink.linker.support.Guards.isNotNull;
//
//@Service
//public class MqttPublisherService {
//
//    @Value("${aws.iot.endpoint}")
//    private String awsIotEndpoint;
//
//    @Value("${aws.iot.clientId}")
//    private String clientId;
//
//    @Value("${aws.iot.certPath}")
//    private String certPath;
//
//    @Value("${aws.iot.keyPath}")
//    private String keyPath;
//
//    @Value("${aws.iot.caPath}")
//    private String caPath;
//
//    @Value("${aws.iot.topic}")
//    private String topic;
//
//    private MqttClient client;
//
//    public MqttPublisherService() {
////        try {
////            connect();
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
//    }
//
//    @PostConstruct
//    public void init() {
//        try {
//            System.out.println("Client ID: " + clientId); // Debugging: Check if clientId is null
//            if (clientId == null || clientId.trim().isEmpty()) {
//                throw new IllegalArgumentException("clientId cannot be null or empty");
//            }
//            connect();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    private void connect() throws Exception {
//
//        String brokerUrl = "ssl://" + awsIotEndpoint + ":8883";
//        client = new MqttClient(brokerUrl, clientId, new MemoryPersistence());
//        MqttConnectOptions options = new MqttConnectOptions();
//        options.setSocketFactory(SslUtil.getSocketFactory(caPath, certPath, keyPath, ""));
//
//        System.out.println("Checking certificate files...");
//        System.out.println("CA Path: " + caPath + " Exists? " + Files.exists(Paths.get(caPath)));
//        System.out.println("Cert Path: " + certPath + " Exists? " + Files.exists(Paths.get(certPath)));
//        System.out.println("Key Path: " + keyPath + " Exists? " + Files.exists(Paths.get(keyPath)));
//
//        client.connect(options);
////        options.setKeepAliveInterval(60);
//        System.out.println("Connected to AWS IoT Core");
//
//    }
//
//    public void publishMessage(String lockerId) throws Exception {
//        if (!client.isConnected()) {
//            connect();
//        }
//        String payload = "{ \"lockerId\": \"" + lockerId + "\", \"command\": \"unlock\" }";
//        MqttMessage message = new MqttMessage(payload.getBytes());
//        message.setQos(1);
//        client.publish(topic, message);
//        System.out.println("Message Published: " + payload);
//    }
//}
//
