#include "certs.h"
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <base64.h>
#include <esp_now.h>
#include <WiFi.h>


#define AWS_IOT_PUBLISH_TOPIC   "esp32/fingerprintdata"
#define AWS_IOT_REGISTRAIONID_TOPIC "esp32/registrationID"
#define AWS_IOT_PASSWORD_TOPIC "esp32/password"
#define AWS_IOT_ABNORMAL_TOPIC "esp32/abnormal_lockers"
#define AWS_IOT_SUBSCRIBE_CHECK_LOCKER_TOPIC "esp32/check_locker_status"
#define AWS_IOT_PUBLISH_LOCKER_STATUS_TOPIC "esp32/locker_status"

WiFiClientSecure net;
PubSubClient client(net); 

// Global variable to store the password
bool passwordReceived = false; // Flag to indicate password reception
String PassWord = "";

bool statusCheck = false; // Flag to check if the locker is assigned
uint8_t checkLockerId;  // Locker ID

// Slave MAC Address
uint8_t broadcastAddress[] = {0x34, 0x94, 0x54, 0xAA, 0x79, 0xE0};

// Structure example to send data
// Must match the receiver structure
// The type of data we want to send
typedef struct master_message {
  int unlockPin;
} master_message;

typedef struct slavercv_message {
  bool lockerStatus[3];
} slave_message;

master_message master;
slavercv_message rcv;

//Create a variable of type esp_now_peer_info_t to store information about the peer
esp_now_peer_info_t peerInfo;

// callback when data is sent
// Simply prints if the message was successfully delivered or not
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  Serial.print("\r\nLast Packet Send Status:\t");
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

// callback function that will be executed when data is received
void OnDataRecv(const uint8_t * mac, const uint8_t *incomingData, int len) {
  memcpy(&rcv, incomingData, sizeof(rcv));
}

//initalize espnow
void initESPNOW() {
    // Set device as a Wi-Fi Station
    WiFi.mode(WIFI_STA);
    // Init ESP-NOW
    if (esp_now_init() != ESP_OK) {
        Serial.println("Error initializing ESP-NOW");
        return;
    }

    // Once ESPNow is successfully Init, we will register for Send CB to
    // get the status of Trasnmitted packet
    // Register the callback function that will be called when a message is sent. In this case, we register for the OnDataSent() function created previously
    esp_now_register_send_cb(OnDataSent);
    
    // Register peer
    memcpy(peerInfo.peer_addr, broadcastAddress, 6);
    peerInfo.channel = 0;  
    peerInfo.encrypt = false;
    
    // Add peer        
    if (esp_now_add_peer(&peerInfo) != ESP_OK){
        Serial.println("Failed to add peer");
        return;
    }

    // Register for a callback function that will be called when data is received
    esp_now_register_recv_cb(esp_now_recv_cb_t(OnDataRecv));

}

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
            PassWord= doc["password"].as<String>();
            passwordReceived = true; // Set the flag to true
            Serial.println("Password updated: " + PassWord);
        } else {
            Serial.println("No password found in the message.");
        }
    }else if (strcmp(topic, AWS_IOT_SUBSCRIBE_CHECK_LOCKER_TOPIC) == 0) {
        // Parse the JSON payload
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, message);

        if (error) {
            Serial.print("Failed to parse JSON: ");
            Serial.println(error.f_str());
            return;
        }

        // Extract the locker ID
        if (doc.containsKey("lockerId")) {
            checkLockerId = doc["lockerId"];
            statusCheck = true; // Set the flag to true
            Serial.println("Locker ID received: " + String(checkLockerId));
        } else {
            Serial.println("No locker ID found in the message.");
        }
    } else {
        Serial.println("Received message: " + message);
    }
}

// Connect to AWS IoT
void connectAWS() {
    Serial.println("Initializing AWS Connection...");

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
    //client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
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

void publishFingerprintData(uint8_t fingerprintID, String templateBase64) {
    // Check if MQTT client is connected
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
    }

    // Create JSON payload
    StaticJsonDocument<512> doc;
    doc["fingerprint_id"] = fingerprintID;
    doc["fingerprint_template"] = templateBase64;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer);

    // Debug: Print payload size
    Serial.print("Payload size: ");
    Serial.println(strlen(jsonBuffer));

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer)) {
        Serial.println("Fingerprint data published to MQTT topic.");
    } else {
        Serial.println("Failed to publish fingerprint data.");
        Serial.println("Error code: " + String(client.state()));
    }
}

void publishIDMessage(String registrationID) {
    StaticJsonDocument<200> doc;
    doc["registrationID"] = registrationID;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);

    if (client.publish(AWS_IOT_REGISTRAIONID_TOPIC, jsonBuffer)) {
        Serial.println("Registration ID is published to MQTT topic.");
    } else {
        Serial.println("Failed to publish test message.");
    }
}

void publishAbnormalLockers(uint8_t* abnormalLockerId, int numLockers) {
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Your own function to reconnect
    }

    StaticJsonDocument<256> doc;

    // Add abnormal lockers to a JSON array
    JsonArray abnormal = doc.createNestedArray("abnormal");

    for (int i = 0; i < numLockers; i++) {
        if (abnormalLockerId[i] != -1) {
            abnormal.add(i+1);
        }
    }

    // Serialize JSON
    char jsonBuffer[256];
    serializeJson(doc, jsonBuffer);

    // Publish to AWS IoT
    if (client.publish(AWS_IOT_ABNORMAL_TOPIC, jsonBuffer)) {
        Serial.println("Abnormal locker IDs published to AWS IoT:");
        Serial.println(jsonBuffer);
    } else {
        Serial.println("Failed to publish abnormal locker IDs.");
        Serial.println("Error code: " + String(client.state()));
    }
}

void publishLockerStatus(int lockerId, int status) {
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Your own function to reconnect
    }

    StaticJsonDocument<200> doc;
    doc["lockerId"] = lockerId;
    doc["status"] = status;

    char jsonBuffer[256];
    serializeJson(doc, jsonBuffer);

    if (client.publish(AWS_IOT_PUBLISH_LOCKER_STATUS_TOPIC, jsonBuffer)) {
        Serial.println("Locker status published to AWS IoT:");
        Serial.println(jsonBuffer);
    } else {
        Serial.println("Failed to publish locker status.");
        Serial.println("Error code: " + String(client.state()));
    }
}