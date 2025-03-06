#include "Client.h"
#include "certs.h"
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <base64.h> 

#define AWS_IOT_PUBLISH_TOPIC   "esp32/Fingerprintdata"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/sub"
#define AWS_IOT_PASSWORD_TOPIC "esp32/password" 

WiFiClientSecure net;
PubSubClient client(net);

// Global variable to store the password
String PassWord = "";  

// Initialize WiFi
void initWiFi() {
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to WiFi ..");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print('.');
        delay(1000);
    }
    Serial.println("\nConnected! IP Address: " + WiFi.localIP().toString());
}

// MQTT Callback Function
void messageHandler(char* topic, byte* payload, unsigned int length) {
    Serial.print("Incoming message from: ");
    Serial.println(topic);

    // Convert payload to a string
    String message;
    for (int i = 0; i < length; i++) {
        message += (char)payload[i];
    }

    // Check if the message is from the password topic
    if (strcmp(topic, AWS_IOT_PASSWORD_TOPIC) == 0) {
        // Parse the JSON payload
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, message);

        if (error) {
            Serial.print("Failed to parse JSON: ");
            Serial.println(error.f_str());
            return;
        }

        // Extract the password
        if (doc.containsKey("password")) {
            PassWord = doc["password"].as<String>();
            Serial.println("Password updated: " + PassWord);
        } else {
            Serial.println("No password found in the message.");
        }
    } else {
        Serial.println("Received message: " + message);
    }
}

// Connect to AWS IoT
void connectAWS() {
    Serial.println("Initializing AWS Connection...");

    initWiFi();

    net.setCACert(AWS_CERT_CA);
    net.setCertificate(AWS_CERT_CRT);
    net.setPrivateKey(AWS_CERT_PRIVATE);

    client.setServer(AWS_IOT_ENDPOINT, 8883);
    client.setCallback(messageHandler);

    Serial.print("Connecting to AWS IoT...");

    while (!client.connected()) {
        Serial.print(".");
        if (client.connect(THINGNAME)) {
            break;
        }
        delay(1000);
    }

    if (!client.connected()) {
        Serial.println(" AWS IoT Connection Failed!");
        return;
    }

    Serial.println("\nAWS IoT Connected!");
    client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
    client.subscribe(AWS_IOT_PASSWORD_TOPIC);
    Serial.println("Subscribed to password topic");
}

// Publish MQTT Message
void publishMessage(int metricsValue) {
    if (!client.connected()) {
        Serial.println("MQTT Client not connected!");
        return;
    }

    StaticJsonDocument<200> doc;
    doc["metrics"] = metricsValue;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);

    client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}

// Publish Fingerprint Data to MQTT Topic
void publishFingerprintData(uint8_t fingerprintID, String templateBase64) {
    // Create JSON payload
    StaticJsonDocument<512> doc;
    doc["fingerprint_id"] = fingerprintID;
    doc["fingerprint_template"] = templateBase64;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer);

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer)) {
        Serial.println("Fingerprint data published to MQTT topic.");
    } else {
        Serial.println("Failed to publish fingerprint data.");
    }
}
