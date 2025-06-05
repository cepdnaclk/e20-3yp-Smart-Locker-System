#include "certs.h"
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <base64.h>
#include <esp_now.h>
#include <WiFi.h>

#define AWS_IOT_PUBLISH_TOPIC "esp32/fingertemplate"
#define AWS_IOT_REGID_TOPIC "esp32/regid"
#define AWS_IOT_GET_REGISTRATION_ID_TOPIC "esp32/get_registrationID"
#define AWS_IOT_ASSIGN_FINGERPRINT_TOPIC "esp32/assignFingerprint"

//Topics
//Registration Topics
#define AWS_IOT_GET_PASSWORD_TOPIC "esp32/getPassword"
#define AWS_IOT_PASSWORD_TOPIC "esp32/password"

//unlock topics
#define AWS_IOT_PUB_FINGER_TOPIC   "esp32/unlockFingerprint"
#define AWS_IOT_ASSIGNED_LOCKER_TOPIC "esp32/unlock"

//Mobile unlock topics
#define AWS_IOT_MOBILE_UNLOCK_TOPIC "esp32/mobileUnlock"

//notification
#define AWS_IOT_NOTIFICATION_TOPIC "esp32/notification"
#define AWS_IOT_ABNORMAL_TOPIC "esp32/abnormal_lockers"

//locker status
#define AWS_IOT_SUBSCRIBE_CHECK_LOCKER_TOPIC "esp32/checkLockerStatus"
#define AWS_IOT_PUBLISH_LOCKER_STATUS_TOPIC "esp32/lockerStatus"

//Release locker
#define AWS_IOT_PUB_RELEASE_TOPIC "esp32/realeaseFingerprint"
#define AWS_IOT_RELEASE_LOCKER_TOPIC "esp32/releaseLocker"

WiFiClientSecure net;
PubSubClient client(net); 

// Global variable to store the password
volatile bool passwordReceived = false; // Flag to indicate password reception
String PassWord = "";

//global variable to store the user ID
bool RegIdRecv = false; // Flag to indicate registration ID reception
String RegistrationId = "";


bool statusCheck = false; // Flag to check if the locker is assigned
uint8_t checkLockerId;  // Locker ID


volatile uint8_t unlockLockerId ; // Locker ID to unlock
volatile bool unlockLocker = false; // Flag to unlock the locker
volatile int8_t alreadyAssign;


// mobile unlock
uint8_t mUnlockLockerId ; // Locker ID to unlock
bool mUnlockLocker = false; // Flag to unlock the locker
volatile int8_t mReleaseLocker = false; // Flag to release the locker

// Release Locker;
uint8_t releaseLockerId ; // Locker ID to unlock
bool releaseLocker = false; // Flag to unlock the locker


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
    Serial.print("Task addr: ");
    Serial.println((uint32_t)&passwordReceived, HEX);


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
        if (doc.containsKey("lockerId") && doc["clusterId"] == "1" ) {
            checkLockerId = doc["lockerId"];
            statusCheck = true; // Set the flag to true
            Serial.println("Locker ID received: " + String(checkLockerId));
            Serial.println("Status Check: " + checkLockerId);
        } else {
            Serial.println("No locker ID found in the message.");
        }
    }else if (strcmp(topic, AWS_IOT_REGID_TOPIC) == 0) {
        // Parse the JSON payload
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, message);

        if (error) {
            Serial.print("Failed to parse JSON: ");
            Serial.println(error.f_str());
            return;
        }

        // Extract the registration ID
        if (doc.containsKey("registrationID")) {
            RegistrationId = doc["registrationID"].as<String>();
            RegIdRecv = true; // Set the flag to true
            Serial.println("Registration ID received: " + RegistrationId);
        } else {
            Serial.println("No registration ID found in the message.");
        }
    } else if(strcmp(topic, AWS_IOT_ASSIGNED_LOCKER_TOPIC) == 0) {
        // Parse the JSON payload
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, message);

        if (error) {
            Serial.print("Failed to parse JSON: ");
            Serial.println(error.f_str());
            return;
        }

        // Extract the locker ID
        if (doc.containsKey("lockerID") && doc["clusterID"] == "1" ) {
            unlockLockerId = doc["lockerID"];
            if(doc["source"] == "0"){
                unlockLocker = true; // Set the flag to true
            } else if (doc["source"] == "1") {
                mUnlockLocker = true;
            }else if (doc["source"] == "2") {
                mReleaseLocker = true;
            }
            alreadyAssign = doc["alreadyAssign"];
            Serial.println("Locker ID received: " + String(checkLockerId));
            Serial.println("unlockLocker" + String(unlockLocker));
            Serial.println("Status Check: " + checkLockerId);
        } else {
            Serial.println("No locker ID found in the message.");
        }
    }else if (strcmp(topic, AWS_IOT_MOBILE_UNLOCK_TOPIC) == 0) {
        // Parse the JSON payload
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, message);

        if (error) {
            Serial.print("Failed to parse JSON: ");
            Serial.println(error.f_str());
            return;
        }

        // Extract the locker ID
        if (doc.containsKey("lockerID") && doc["clusterID"] == "1" ) {
            mUnlockLockerId = doc["lockerID"];
            mUnlockLocker = true; // Set the flag to true
            Serial.println("Locker ID received: " + String(checkLockerId));
        } else {
            Serial.println("No locker ID found in the message.");
        }
    }else if( strcmp(topic, AWS_IOT_RELEASE_LOCKER_TOPIC) == 0) {
        // Parse the JSON payload
        StaticJsonDocument<200> doc;
        DeserializationError error = deserializeJson(doc, message);

        if (error) {
            Serial.print("Failed to parse JSON: ");
            Serial.println(error.f_str());
            return;
        }

        // Extract the locker ID
        if (doc.containsKey("lockerID") && doc["clusterID"] == "1" ) {
            releaseLockerId = doc["lockerID"];
            releaseLocker = true; // Set the flag to true
            Serial.println("Locker ID received: " + String(checkLockerId));
        } else {
            Serial.println("No locker ID found in the message.");
        }
    }

    else {
        Serial.println("Received message: " + message);
    }
}

// Connect to AWS IoT
void connectAWS() {
    Serial.println("Initializing AWS Connection...");

    net.setCACert(AWS_CERT_CA);
    net.setCertificate(AWS_CERT_CRT);
    net.setPrivateKey(AWS_CERT_PRIVATE);
    Serial.println(client.state());

    client.setServer(AWS_IOT_ENDPOINT, 8883);
    client.setCallback(messageHandler);
    Serial.println(client.state());



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
    client.subscribe(AWS_IOT_SUBSCRIBE_CHECK_LOCKER_TOPIC);
    Serial.println("Subscribed to locker status topic");
    client.subscribe(AWS_IOT_REGID_TOPIC);
    Serial.println("Subscribed to registration ID topic");
    client.subscribe(AWS_IOT_ASSIGNED_LOCKER_TOPIC);
    Serial.println("Subscribed to unlock topic");
    client.subscribe(AWS_IOT_MOBILE_UNLOCK_TOPIC);
    Serial.println("Subscribed to mobile unlock topic");
    client.subscribe(AWS_IOT_RELEASE_LOCKER_TOPIC);
    Serial.println("Subscribed to release locker topic");
}

/*// Publish MQTT Message
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
}*/

/*void publishFingerprintData(uint8_t fingerprintID, String templateBase64) {
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
}*/

void publishFingerprintData(uint8_t fingerprintID, String templateBase64) {
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS();
    }

    const size_t chunkSize = 200;  // Choose size to keep entire JSON < AWS IoT's 128 KB limit
    size_t totalLength = templateBase64.length();
    size_t totalChunks = (totalLength + chunkSize - 1) / chunkSize;

    Serial.print("Sending fingerprint data in ");
    Serial.print(totalChunks);
    Serial.println(" chunks...");

    for (size_t i = 0; i < totalChunks; ++i) {
        size_t start = i * chunkSize;
        size_t end = start + chunkSize;
        if (end > totalLength) end = totalLength;

        String chunk = templateBase64.substring(start, end);

        StaticJsonDocument<600> doc;
        doc["fingerprint_id"] = fingerprintID;
        doc["chunk_index"] = i;
        doc["total_chunks"] = totalChunks;
        doc["fingerprint_template"] = chunk;

        char jsonBuffer[1024];
        serializeJson(doc, jsonBuffer);

        Serial.print("Publishing chunk ");
        Serial.print(i + 1);
        Serial.print(" of ");
        Serial.println(totalChunks);
        Serial.print("Payload size: ");
        Serial.println(strlen(jsonBuffer));

        if (!client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer)) {
            Serial.println("Failed to publish fingerprint chunk.");
            Serial.println("Error code: " + String(client.state()));
            return;
        }

        delay(100);  // Slight delay to avoid flooding
    }

    Serial.println("All fingerprint chunks published.");
}


void publishGetPassword(String registrationID) {
    StaticJsonDocument<200> doc;
    doc["registrationID"] = registrationID;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);

    if (client.publish(AWS_IOT_GET_PASSWORD_TOPIC, jsonBuffer)) {
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
        if (abnormalLockerId[i] == 1) {
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
    doc["clusterId"] = "1";
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

void publishRegID_FinID(String registrationID, uint8_t fingerprintID) {
    // Check if MQTT client is connected
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
    }

    // Create JSON payload
    StaticJsonDocument<512> doc;
    doc["registrationID"] = registrationID;
    doc["fingerprintID"] = fingerprintID;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer);

    // Debug: Print payload size
    Serial.print("Payload size: ");
    Serial.println(strlen(jsonBuffer));

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_ASSIGN_FINGERPRINT_TOPIC, jsonBuffer)) {
        Serial.println("Registration ID and fingerprint ID published to MQTT topic.");
    } else {
        Serial.println("Failed to publish registration ID and fingerprint ID.");
        Serial.println("Error code: " + String(client.state()));
    }
}

void publishFingerprintID(uint8_t fingerprintID,uint8_t clusterId, String action) {
    // Check if MQTT client is connected
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
    }

    // Create JSON payload
    StaticJsonDocument<200> doc;
    doc["fingerprintId"] = fingerprintID;
    doc["clusterId"] = clusterId;
    doc["action"] = action; // Add action field
    // This field can be "assign", "unlock", or "release" based on the action you want to perform

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer);

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_PUB_FINGER_TOPIC, jsonBuffer)) {
        Serial.println("Fingerprint ID published to MQTT topic.");
    } else {
        Serial.println("Failed to publish fingerprint ID.");
        Serial.println("Error code: " + String(client.state()));
    }
}

void publishRegID_LockerID(String registrationID, uint8_t lockerID) {
    // Check if MQTT client is connected
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
    }

    // Create JSON payload
    StaticJsonDocument<200> doc;
    doc["registrationID"] = registrationID;
    doc["lockerID"] = lockerID;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_GET_REGISTRATION_ID_TOPIC, jsonBuffer)) {
        Serial.println("Registration ID and locker ID published to MQTT topic.");
    } else {
        Serial.println("Failed to publish registration ID and locker ID.");
        Serial.println("Error code: " + String(client.state()));
    }
}

void publishSendNotification(uint8_t message) {
    // Check if MQTT client is connected
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
    }

    // Create JSON payload
    StaticJsonDocument<200> doc;
    doc["Fingerprint ID"] = message;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_NOTIFICATION_TOPIC, jsonBuffer)) {
        Serial.println("Notification published to MQTT topic.");
    } else {
        Serial.println("Failed to publish notification.");
        Serial.println("Error code: " + String(client.state()));
    }
}

void publishReleaseFingerprintID(uint8_t fingerprintID,uint8_t clusterId) {
    // Check if MQTT client is connected
    if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
    }

    // Create JSON payload
    StaticJsonDocument<200> doc;
    doc["fingerprintID"] = fingerprintID;
    doc["clusterID"] = clusterId;

    char jsonBuffer[1024];
    serializeJson(doc, jsonBuffer);

    // Publish to MQTT topic
    if (client.publish(AWS_IOT_PUB_FINGER_TOPIC, jsonBuffer)) {
        Serial.println("Fingerprint ID published to MQTT topic.");
    } else {
        Serial.println("Failed to publish fingerprint ID.");
        Serial.println("Error code: " + String(client.state()));
    }
}