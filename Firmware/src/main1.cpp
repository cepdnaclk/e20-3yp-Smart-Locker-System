#include <Keypad.h> 
#include <Wire.h> 
#include <Arduino.h>
#include "utils.h"
#include <PubSubClient.h>
#include <base64.h>
#include "lcd.h"
#include "solenoid.h"
#include <Adafruit_Fingerprint.h>
#include "ultraSonic.h"
#include "PCF8574.h"

#define ROWS  4
#define COLS  4
#define RELAY_PIN 5
#define RXD2 16 // ESP32 RX2 pin (connect to sensor TX)
#define TXD2 17 // ESP32 TX2 pin (connect to sensor RX)
#define LOCKER_DISTANCE_THRESHOLD 10 // Distance threshold in cm for abnormal detection
#define clusterId 1

Adafruit_Fingerprint finger = Adafruit_Fingerprint(&Serial2);
PCF8574 pcf8574(0x20);
Keypad keypad = Keypad(makeKeymap(keyMap), rowPins, colPins, ROWS, COLS);


const int LOCKERPINS[NUMLOCKERS] = {4,23,13}; // GPIO pins for lockers


char keyMap[ROWS][COLS] = {
  {'1','2','3', 'A'},
  {'4','5','6', 'B'},
  {'7','8','9', 'C'},
  {'*','0','#', 'D'}
};

//locker status :
// 0 = empty = not assigned and closed
// 1 = unsafe - assigned and not yet closed
// 2 = safe - assigned and closed
// 3 = abnormal - not assigned and open or something inside

typedef struct{
  uint8_t lockerId;
  int assignedId = -1;
  float sensorDistance;
  uint8_t status = 0;
  uint8_t lockerPin;
}locker;

locker lockers[NUMLOCKERS];

uint8_t abnormalLockerId [NUMLOCKERS]; // Array to store abnormal locker IDs

void updateStatus() {
  for (int i = 0; i < NUMLOCKERS; i++) {
    read_ultraSonic(); // Read the ultrasonic sensor data
    lockers[i].sensorDistance = sensors[i].distanceCm; // Update the locker distance
    if ((LOCKER_DISTANCE_THRESHOLD < lockers[i].sensorDistance < LOCKER_DISTANCE_THRESHOLD) && lockers[i].assignedId == -1) {
      abnormalLockerId[i] = 1; // Return the locker ID if distance is below threshold
      lockers[i].status = 3; // Set status to abnormal
    }
    else if (lockers[i].sensorDistance == LOCKER_DISTANCE_THRESHOLD && lockers[i].assignedId != -1) {
      lockers[i].status = 2; // Set status to safe
      abnormalLockerId[i] = 0; // Return the locker ID if distance is above threshold
    }else{
      lockers[i].status = 1; // Set status to unsafe
      abnormalLockerId[i] = 0; // Return the locker ID if distance is above threshold
    }
  }
}


uint8_t rowPins[ROWS] = {14, 27, 26, 25}; // GPIO14, GPIO27, GPIO26, GPIO25
uint8_t colPins[COLS] = {33, 32, 18, 19}; // GPIO33, GPIO32, GPIO18, GPIO19
uint8_t LCD_CursorPosition = 0;
String InputStr = "";
uint8_t idS = 1;
String user = "";
uint8_t id;
long currentTime = 0;




void init_finger() {
  Serial2.begin(57600, SERIAL_8N1, RXD2, TXD2);

  // Start the fingerprint sensor
  finger.begin(57600);

  if (finger.verifyPassword()) {
      Serial.println("Fingerprint sensor found!");
      delay(100);
  } else {
      Serial.println("Fingerprint sensor not found :(");
      while (1) { delay(1); }
  }
}

uint8_t getFingerprintEnroll(uint8_t id) {

  int p = -1;
  I2C_LCD.print("Waiting Fingerprint"); 
  //I2C_LCD.print(id);
  //I2C_LCD.clear();
  I2C_LCD.setCursor(0, 1);
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      I2C_LCD.print("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      I2C_LCD.print(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      I2C_LCD.print("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      I2C_LCD.print("Error capturing image");
      break;
    default:
      I2C_LCD.print("Unknown error");
      break;
    }
  }
  
  // Image successfully captured
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  p = finger.image2Tz(1);
  switch (p) {
    case FINGERPRINT_OK:
      I2C_LCD.print("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      I2C_LCD.print("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      I2C_LCD.print("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      I2C_LCD.print("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      I2C_LCD.print("Could not find fingerprint features");
      return p;
    default:
      I2C_LCD.print("Unknown error");
      return p;
  }
  
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  I2C_LCD.print("Remove your finger");
  delay(2000);
  
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  I2C_LCD.print("ID "); 
  I2C_LCD.print(id);
  
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  p = -1;
  I2C_LCD.print("Place the same finger again");
  //I2C_LCD.clear();
  I2C_LCD.setCursor(0, 1);
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      I2C_LCD.print("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      I2C_LCD.print(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      I2C_LCD.print("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      I2C_LCD.print("Error capturing image");
      break;
    default:
      I2C_LCD.print("Unknown error");
      break;
    }
  }
  
  // Second image successfully captured
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  p = finger.image2Tz(2);
  switch (p) {
    case FINGERPRINT_OK:
      I2C_LCD.print("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      I2C_LCD.print("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      I2C_LCD.print("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      I2C_LCD.print("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      I2C_LCD.print("Could not find fingerprint features");
      return p;
    default:
      I2C_LCD.print("Unknown error");
      return p;
  }
  
  // Create a model from the two images
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  I2C_LCD.print("Creating model for #");  
  I2C_LCD.print(id);
  
  
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    I2C_LCD.print("Fingerprints match!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    I2C_LCD.print("Communication error");
    return p;
  } else if (p == FINGERPRINT_ENROLLMISMATCH) {
    I2C_LCD.print("Fingerprints do not match");
    return p;
  } else {
    I2C_LCD.print("Unknown error");
    return p;
  }
  
  // Store the model in the specified position
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  I2C_LCD.print("ID "); 
  I2C_LCD.print(id);
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  p = finger.storeModel(id);
  if (p == FINGERPRINT_OK) {
    I2C_LCD.print("Saved successfully!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    I2C_LCD.print("Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    I2C_LCD.print("Could not save in that location");
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    I2C_LCD.print("Error writing to flash memory");
    return p;
  } else {
    I2C_LCD.print("Unknown error");
    return p;
  }
  
  return 1;
  }

/*void sendFingerprint(uint8_t id) {
    uint8_t bytesReceived[534]; // Buffer for fingerprint template (includes headers)
    uint8_t fingerTemplate[512]; // Actual fingerprint template
    String templateString = "";  // Base64-encoded fingerprint template
  
    Serial.print("Loading fingerprint template for ID #");
    Serial.println(id);
  
    // Load fingerprint model from sensor memory
    if (finger.loadModel(id) != FINGERPRINT_OK) {
        Serial.println("Failed to load fingerprint template.");
        return;
    }
    Serial.println("Fingerprint template loaded successfully!");
  
    // Request fingerprint template data
    if (finger.getModel() != FINGERPRINT_OK) {
        Serial.println("Failed to retrieve fingerprint template.");
        return;
    }
    Serial.println("Fingerprint template retrieved successfully!");
  
    // Read raw template data from the fingerprint sensor
    memset(bytesReceived, 0xFF, 534);
    uint32_t startTime = millis();
    int i = 0;
    while (i < 534 && (millis() - startTime) < 20000) {
        if (Serial2.available()) { // Read from ESP32 Serial2 (UART)
            bytesReceived[i++] = Serial2.read();
        }
    }
  
    // Check if all bytes were received
    if (i < 534) {
        Serial.println("Error: Incomplete data received from sensor.");
        return;
    }
  
    Serial.print(i);
    Serial.println(" bytes read.");
    Serial.println("Processing fingerprint template...");
  
    // Extract the fingerprint template (skip headers and checksums)
    int uindx = 9, index = 0;
    memcpy(fingerTemplate + index, bytesReceived + uindx, 256); // First 256 bytes
    uindx += 256 + 2 + 9; // Skip checksum and next header
    index += 256;
    memcpy(fingerTemplate + index, bytesReceived + uindx, 256); // Second 256 bytes
  
    // Convert fingerprint template to Base64 string
    templateString = base64::encode(fingerTemplate, 512);
  
    Serial.println("Fingerprint template (Base64):");
    Serial.println(templateString);
  
    // Publish fingerprint data via MQTT
    publishFingerprintData(id, templateString);
    }*/
   
uint8_t getFingerprintIDez() {
    uint8_t p = -1;
  
    // Wait until a finger is detected
    while (p != FINGERPRINT_OK) {
        p = finger.getImage();
        if (p == FINGERPRINT_NOFINGER) {
            Serial.println("Place your finger on the sensor...");
            delay(500); // Small delay to avoid spamming the Serial Monitor
        } else if (p != FINGERPRINT_OK) {
            Serial.print("Error: Failed to capture image. Code: ");
            Serial.println(p);
            return 0; // Return 0 to indicate an error
        }
    }
  
    Serial.println("Finger detected!");
  
    p = finger.image2Tz();
    Serial.print("image2Tz() returned: ");
    Serial.println(p);
    if (p != FINGERPRINT_OK) {
        Serial.println("Error: Failed to convert image.");
        return 0; // Return 0 to indicate an error
    }
  
    p = finger.fingerFastSearch();
    Serial.print("fingerFastSearch() returned: ");
    Serial.println(p);
    if (p != FINGERPRINT_OK) {
        Serial.println("Error: No match found or communication error.");
        return 0; // Return 0 to indicate no match or error
    }
  
    // Found a match!
    Serial.println("Match found!");
    Serial.print("Fingerprint ID: ");
    Serial.println(finger.fingerID);
    Serial.print("Confidence: ");
    Serial.println(finger.confidence);
  
    return finger.fingerID; // Return the matched fingerprint ID
  }
  
uint8_t getFingerprintID()
  {
  uint8_t p = finger.getImage();
  switch (p)
  {
  case FINGERPRINT_OK:
    Serial.println("Image taken");
    break;
  case FINGERPRINT_NOFINGER:
    Serial.println("No finger detected");
    return p;
  case FINGERPRINT_PACKETRECIEVEERR:
    Serial.println("Communication error");
    return p;
  case FINGERPRINT_IMAGEFAIL:
    Serial.println("Imaging error");
    return p;
  default:
    Serial.println("Unknown error");
    return p;
  }
  
  // OK success!
  
  p = finger.image2Tz();
  switch (p)
  {
  case FINGERPRINT_OK:
    Serial.println("Image converted");
    break;
  case FINGERPRINT_IMAGEMESS:
    Serial.println("Image too messy");
    return p;
  case FINGERPRINT_PACKETRECIEVEERR:
    Serial.println("Communication error");
    return p;
  case FINGERPRINT_FEATUREFAIL:
    Serial.println("Could not find fingerprint features");
    return p;
  case FINGERPRINT_INVALIDIMAGE:
    Serial.println("Could not find fingerprint features");
    return p;
  default:
    Serial.println("Unknown error");
    return p;
  }
  
  // OK converted!
  p = finger.fingerSearch();
  if (p == FINGERPRINT_OK)
  {
    Serial.println("Found a print match!");
  }
  else if (p == FINGERPRINT_PACKETRECIEVEERR)
  {
    Serial.println("Communication error");
    return p;
  }
  else if (p == FINGERPRINT_NOTFOUND)
  {
    Serial.println("Did not find a match");
    return p;
  }
  else
  {
    Serial.println("Unknown error");
    return p;
  }
  
  // found a match!
  Serial.print("Found ID #");
  Serial.print(finger.fingerID);
  Serial.print(" with confidence of ");
  Serial.println(finger.confidence);
  
  return finger.fingerID;
}

void unlock(uint8_t lockerid){
  for(uint8_t i = 0; i < NUMLOCKERS; i++){
        if(lockers[i].lockerId == lockerid){
          digitalWrite(lockers[i].lockerPin, LOW);  // Unlock
          delay(5000);
          digitalWrite(lockers[i].lockerPin, HIGH); // Lock agai
        }
}
}

