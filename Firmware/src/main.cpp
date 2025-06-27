#include <Keypad_I2C.h>
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


#define ROWS  4
#define COLS  4
#define RELAY_PIN 5
#define RXD2 16 // ESP32 RX2 pin (connect to sensor TX)
#define TXD2 17 // ESP32 TX2 pin (connect to sensor RX)
#define LOCKER_DISTANCE_THRESHOLD 21.7// Distance threshold in cm for abnormal detection
#define clusterId 1
#define DISTANCE_TOLERANCE 1.00
#define I2CADDR 0x24

//define pins for MC38
const int DOORSENSOR[NUMLOCKERS] = {13,25,5};

//Define LED pins
const int LEDPINS[NUMLOCKERS] = {14,33,19}; // GPIO pins for LEDs

const int LOCKERPINS[NUMLOCKERS] = {P0,P1,P2}; // GPIO pins for lockers


char keys[ROWS][COLS] = {
  {'1','2','3', 'A'},
  {'4','5','6', 'B'},
  {'7','8','9', 'C'},
  {'*','0','#', 'D'}
};



typedef struct{
  uint8_t lockerId;
  int assignedId = -1;
  float sensorDistance;
  uint8_t status = 0;
  uint8_t lockerPin;
  unsigned long timer = 0;
  int doorStatus;
}locker;

locker lockers[NUMLOCKERS];

uint8_t abnormalLockerId [NUMLOCKERS]; // Array to store abnormal locker IDs

uint8_t rowPins[ROWS] = {0,1,2,3}; // GPIO14, GPIO27, GPIO26, GPIO25
uint8_t colPins[COLS] = {4,5,6,7}; // GPIO33, GPIO32, GPIO18, GPIO19
uint8_t LCD_CursorPosition = 0;
String InputStr = "";
uint8_t idS = 1;
String user = "";
uint8_t id;
unsigned long previousTime = 0;
const unsigned long interval = 5000;
char key;


Adafruit_Fingerprint finger = Adafruit_Fingerprint(&Serial2);
Keypad_I2C keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS, I2CADDR, 1 );
TaskHandle_t Task1;
TaskHandle_t Task2;

bool isNearThreshold(float distance) {
  return abs(distance - LOCKER_DISTANCE_THRESHOLD) < DISTANCE_TOLERANCE;
}

void read_status() {
    for (int i = 0; i < NUMLOCKERS; i++) {
        // Clear the trigPin
        digitalWrite(sensors[i].trigPin, LOW);
        delayMicroseconds(2);

        // Set the trigPin HIGH for 10 microseconds
        pcf8574.digitalWrite(sensors[i].trigPin, HIGH);
        delayMicroseconds(10);
        pcf8574.digitalWrite(sensors[i].trigPin, LOW);

        // Read the echoPin, return the sound wave travel time in microseconds
        sensors[i].duration = pulseIn(sensors[i].echoPin, HIGH);

        // Calculate the distance in cm
        lockers[i].sensorDistance = (sensors[i].duration * SOUND_SPEED) / 2;
        lockers[i].doorStatus = digitalRead(DOORSENSOR[i]);
    }
}

//locker status :
// 0 = available = not assigned and closed and empty
// 1 = unsafe - assigned and not yet closed
// 2 = safe - assigned and closed
// 3 = abnormal - not assigned and open or something inside
void updateStatus() {
  //read_status(); // Read the ultrasonic sensor data
  
  for (int i = 0; i < NUMLOCKERS; i++) {
    lockers[i].doorStatus = digitalRead(DOORSENSOR[i]); // Read the door status
    if (lockers[i].assignedId == -1 && (!isNearThreshold(lockers[i].sensorDistance) || lockers[i].doorStatus == HIGH)) {
      abnormalLockerId[i] = 1; // Return the locker ID if distance is below threshold
      lockers[i].status = 3; // Set status to abnormal
      //digitalWrite(LEDPINS[i], HIGH);
    }
    else if (lockers[i].doorStatus == LOW && lockers[i].assignedId != -1) {
      lockers[i].status = 2; // Set status to safe
      abnormalLockerId[i] = 0; // Return the locker ID if distance is above threshold
      //digitalWrite(LEDPINS[i],LOW);
    }else if (lockers[i].doorStatus == HIGH && lockers[i].assignedId != -1) {
      lockers[i].status = 1;
      abnormalLockerId[i] = 0; // Return the locker ID if distance is above threshold
      /*if(millis() - lockers[i].timer > 60000){
        publishSendNotification(lockers[i].assignedId);
        lockers[i].timer = millis(); // reset the timer
      }*/
      //digitalWrite(LEDPINS[i], HIGH);

    }else if(lockers[i].assignedId == -1 && isNearThreshold(lockers[i].sensorDistance) && lockers[i].doorStatus == LOW){
      lockers[i].status = 0; // Set status to empty
      abnormalLockerId[i] = 0; // Return the locker ID if distance is above threshold
      digitalWrite(LEDPINS[i], HIGH); // Turn on the LED
    }
    delay(1);
  }
}

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

void sendFingerprint(uint8_t id) {
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
    }
   
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
    return -1;
  case FINGERPRINT_PACKETRECIEVEERR:
    Serial.println("Communication error");
    return -1;
  case FINGERPRINT_IMAGEFAIL:
    Serial.println("Imaging error");
    return -1;
  default:
    Serial.println("Unknown error");
    return -1;
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
    return -1;
  case FINGERPRINT_PACKETRECIEVEERR:
    Serial.println("Communication error");
    return -1;
  case FINGERPRINT_FEATUREFAIL:
    Serial.println("Could not find fingerprint features");
    return -1;
  case FINGERPRINT_INVALIDIMAGE:
    Serial.println("Could not find fingerprint features");
    return -1;
  default:
    Serial.println("Unknown error");
    return -1;
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
    return -1;
  }
  else if (p == FINGERPRINT_NOTFOUND)
  {
    Serial.println("Did not find a match");
    return -1;
  }
  else
  {
    Serial.println("Unknown error");
    return -1;
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
          pcf8574.digitalWrite(lockers[i].lockerPin, LOW);  // Unlock
          delay(5000);
          pcf8574.digitalWrite(lockers[i].lockerPin, HIGH); // Lock agai
          Serial.print("Locker ");
          Serial.print(lockers[i].lockerId);
          digitalWrite(LEDPINS[i], LOW); // Turn off the LED
        }
}
}

void codeForTask1( void * parameter )
{
  for (;;) {

    if(WiFi.status() != WL_CONNECTED){
        Serial.println("WiFi not connected! Attempting to reconnect...");
        initWiFi();
    }

    if (!client.connected()) {
            Serial.println("MQTT Client not connected! Attempting to reconnect...");
            connectAWS(); // Reconnect to AWS IoT
    }
    
    bool cancelled = false;
    key = keypad.getKey();
    if (key == 'A') {
        user = "";
        I2C_LCD.clear();
        I2C_LCD.setCursor(0, 0);
        I2C_LCD.print("Enter Registration ID: ");
        I2C_LCD.setCursor(0, 3);
        I2C_LCD.print("# - Clear");
        I2C_LCD.setCursor(10,3);
        I2C_LCD.print("D - Submit");
        LCD_CursorPosition = 0;
        while (true) {
            char passKey = keypad.getKey();
            if (passKey) {
                if (passKey == 'D') {  // Press 'D' to submit ID
                    break;
                }
                if (passKey == '#') {  // Press '#' to clear ID
                    user = ""; // Clear the ID
                    LCD_CursorPosition = 0; // Reset cursor position
                    I2C_LCD.setCursor(0, 1);
                    I2C_LCD.print("                "); // Clear the second line
                    I2C_LCD.setCursor(0, 1);
                    continue;
                }
                user += passKey;
                I2C_LCD.setCursor(LCD_CursorPosition++, 1);
                I2C_LCD.print(passKey);
            }
        }
        passwordReceived = false; // Reset the flag
        publishGetPassword(user); // Publish the registration ID
        //client.loop();
        //delay(1000);

        // Wait for the password to be received
        I2C_LCD.clear();
        scrollText(0,"Waiting for the Code.....");
        I2C_LCD.setCursor(0, 3);
        I2C_LCD.print("Press 'B' to Cancel");
        
        Serial.print("before Waiting... "); Serial.println(passwordReceived);
        while (!passwordReceived) {
            client.loop(); // Keep the MQTT client running
            delay(100);    // Small delay to avoid busy-waiting
            key = keypad.getKey();
            if(key == 'B'){
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("Cancelled!");
              delay(2000);
              startScreen(); // Go back to the main menu
              cancelled = true;
              break; // Break the password waiting loop
            }
        }
        if (cancelled) {
            continue; // Continue the for(;;) loop, restarting from the top
        }
        I2C_LCD.clear();
        I2C_LCD.setCursor(0, 0);
        //I2C_LCD.print(PassWord);
        delay(1000);


        I2C_LCD.clear();
        I2C_LCD.print("Enter Code: ");
         I2C_LCD.setCursor(0, 3);
        I2C_LCD.print("# - Clear");
        I2C_LCD.setCursor(10,3);
        I2C_LCD.print("D - Submit");
        LCD_CursorPosition = 0;
        InputStr = ""; // Clear the input string
        while (true) {
            char passKey = keypad.getKey();
            if (passKey) {
                if (passKey == 'D') {  // Press 'D' to submit code
                    break;
                }
                if (passKey == '#') {  // Press '#' to clear ID
                    InputStr = ""; // Clear the ID
                    LCD_CursorPosition = 0; // Reset cursor position
                    I2C_LCD.setCursor(0, 1);
                    I2C_LCD.print("                "); // Clear the second line
                    I2C_LCD.setCursor(0, 1);
                    continue;
                }
                InputStr += passKey;
                I2C_LCD.setCursor(LCD_CursorPosition++, 1);
                I2C_LCD.print(passKey);
            }
        }

        // Check the entered code against the received password
        if (InputStr == PassWord) {
            I2C_LCD.clear();
            I2C_LCD.setCursor(0, 0);
            I2C_LCD.print("Registering fingerprint...");
            delay(2000);

            // Proceed with fingerprint registration
            I2C_LCD.clear();
            if (getFingerprintEnroll(idS)==1) {
              publishRegID_FinID(user, idS);
              delay(2000);
              sendFingerprint(idS);
              idS++;
            } else {
                Serial.println("Enrollment failed. Not publishing or sending fingerprint.");
            }
        } else {
            I2C_LCD.clear();
            I2C_LCD.setCursor(0, 0);
            I2C_LCD.print("Wrong Password!");
            delay(2000);
        }

        startScreen(); // Go back to the main menu
    }

    else if (key == 'B') {
        I2C_LCD.clear();
        scrollText(0,"Place Finger on Sensor...");
        Serial.println("Place Finger on Sensor...");

        while (finger.getImage() != FINGERPRINT_OK) {
          Serial.println("Waiting for finger...");
          delay(500);
        }
        Serial.println("Finger detected!");
        uint8_t match = getFingerprintID();  // Try reading a fingerprint

        if (match > 0) { // Check if a valid fingerprint ID is returned
          Serial.println("Fingerprint Matched!");
          publishFingerprintID(match,clusterId,"assign"); // Publish the fingerprint ID
          I2C_LCD.clear();
          scrollText(0,"Assigning a locker...");
          I2C_LCD.setCursor(0, 3);
          I2C_LCD.print("Press 'B' to Cancel");
          unlockLocker = false; // Reset the flag
          while (!unlockLocker) {
              client.loop(); // Keep the MQTT client running
              delay(100);
              key = keypad.getKey();
              if(key == 'B'){
                I2C_LCD.clear();
                I2C_LCD.setCursor(0, 0);
                I2C_LCD.print("Cancelled!");
                delay(2000);
                startScreen(); // Go back to the main menu
                cancelled = true;
                break; // Break the password waiting loop
              }    // Small delay to avoid busy-waiting
          }
          
          if (cancelled) {
              continue; // Continue the for(;;) loop, restarting from the top
          }

          delay(2000);
          if(alreadyAssign == 1){
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("Alrady Assigned!");
              I2C_LCD.setCursor(0, 1);
              I2C_LCD.print("Choose another option");
              delay(2000);
              /*I2C_LCD.setCursor(0, 2);
              I2C_LCD.print("belongings");
              unlock(unlockLockerId);
              delay(2000);
              lockers[unlockLockerId-1].assignedId = -1; // Assign the locker ID
              lockers[unlockLockerId-1].status = 3; // Set status to abnormal*/

          }else{
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("Access Granted!");
              I2C_LCD.setCursor(0, 1);
              I2C_LCD.print("Locker No: ");
              I2C_LCD.print(unlockLockerId);
              unlock(unlockLockerId);
              delay(2000);
              lockers[unlockLockerId-1].assignedId = match; // Assign the locker ID
              lockers[unlockLockerId-1].status = 1; // Set status to unsafe
              lockers[unlockLockerId-1].timer = millis(); // Set the timer
              digitalWrite(LEDPINS[unlockLockerId-1],LOW); 
          }
        } else {
            Serial.println("No Match Found.");
            I2C_LCD.clear();
            I2C_LCD.setCursor(0, 0);
            I2C_LCD.print("Access Denied!");
            delay(2000);
        }

        startScreen(); // Go back to the main menu
    } else if(key == 'C') {
        I2C_LCD.clear();
        scrollText(0,"Place Finger on Sensor...");
        Serial.println("Place Finger on Sensor...");

        uint8_t match = getFingerprintIDez();  // Try reading a fingerprint

        if (match > 0) { // Check if a valid fingerprint ID is returned
          Serial.println("Fingerprint Matched!");
          publishFingerprintID(match,clusterId,"access"); // Publish the fingerprint ID
          I2C_LCD.clear();
          scrollText(0,"Accessing the locker...");
          I2C_LCD.setCursor(0, 3);
          I2C_LCD.print("Press 'B' to Cancel");
          unlockLocker = false; // Reset the flag
          while (!unlockLocker) {
              client.loop(); // Keep the MQTT client running
              delay(100);
              key = keypad.getKey();
              if(key == 'B'){
                I2C_LCD.clear();
                I2C_LCD.setCursor(0, 0);
                I2C_LCD.print("Cancelled!");
                delay(2000);
                startScreen(); // Go back to the main menu
                cancelled = true;
                break; // Break the password waiting loop
              }    // Small delay to avoid busy-waiting
          }
          
          if (cancelled) {
              continue; // Continue the for(;;) loop, restarting from the top
          }

          delay(2000);
          if(alreadyAssign == 1){
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("Locker ");
              I2C_LCD.print(unlockLockerId);
              I2C_LCD.print(" is unlocked!");
              /*I2C_LCD.setCursor(0, 2);
              I2C_LCD.print("belongings");*/
              unlock(unlockLockerId);
              delay(2000);
              lockers[unlockLockerId-1].status = 1; // Set status to unsafe
              lockers[unlockLockerId-1].timer = millis(); // Set the timer

          }else{
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("No locker allocated!");
              I2C_LCD.setCursor(0, 1);
              I2C_LCD.print("Assign a locker first.");
              delay(2000);
          }
        } else {
            Serial.println("No Match Found.");
            I2C_LCD.clear();
            I2C_LCD.setCursor(0, 0);
            I2C_LCD.print("Access Denied!");
            delay(2000);
        }

        startScreen(); // Go back to the main men

    }else if(key == 'D'){
        I2C_LCD.clear();
        scrollText(0,"Place Finger on Sensor...");
        Serial.println("Place Finger on Sensor...");

        uint8_t match = getFingerprintIDez();  // Try reading a fingerprint

        if (match > 0) { // Check if a valid fingerprint ID is returned
          Serial.println("Fingerprint Matched!");
          publishFingerprintID(match,clusterId,"unassign"); // Publish the fingerprint ID
          I2C_LCD.clear();
          scrollText(0,"Realeasing the locker...");
          I2C_LCD.setCursor(0, 3);
          I2C_LCD.print("Press 'B' to Cancel");
          unlockLocker = false;
          while (!unlockLocker) {
              client.loop(); // Keep the MQTT client running
              delay(100);
              key = keypad.getKey();
              if(key == 'B'){
                I2C_LCD.clear();
                I2C_LCD.setCursor(0, 0);
                I2C_LCD.print("Cancelled!");
                delay(2000);
                startScreen(); // Go back to the main menu
                cancelled = true;
                break; // Break the password waiting loop
              }    // Small delay to avoid busy-waiting
          }
          if (cancelled) {
              continue; // Continue the for(;;) loop, restarting from the top
          }
          delay(2000);
          if(alreadyAssign == 0){
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("No locker allocated!");
              I2C_LCD.setCursor(0, 1);
              I2C_LCD.print("Assign a locker first.");
              delay(2000);
          }else{
              I2C_LCD.clear();
              I2C_LCD.setCursor(0, 0);
              I2C_LCD.print("Locker ");
              I2C_LCD.print(unlockLockerId);
              I2C_LCD.print(" is unlocked!");
              /*I2C_LCD.setCursor(0, 2);
              I2C_LCD.print("belongings");*/
              unlock(unlockLockerId);
              delay(2000);
              lockers[unlockLockerId-1].assignedId = -1; // Assign the locker ID
              lockers[unlockLockerId-1].status = 3; // Set status to abnormal
          }
    }  
   startScreen();}
  }
}

void codeForTask2( void * parameter )
{
  for (;;) {
    if(WiFi.status() != WL_CONNECTED){
        Serial.println("WiFi not connected! Attempting to reconnect...");
        initWiFi();
    }

    if (!client.connected()) {
            Serial.println("MQTT Client not connected! Attempting to reconnect...");
            connectAWS(); // Reconnect to AWS IoT
    }
    client.loop();
    delay(100); // Small delay to avoid busy-waiting
    
    if(mUnlockLocker == true){
        unlock(unlockLockerId); // Unlock the locker
        lockers[unlockLockerId-1].assignedId = -1; // Assign the locker ID
        lockers[unlockLockerId-1].status = 3; // Set status to abnormal
        mUnlockLocker = false; // Reset the flag
    }

    unsigned long currentTime = millis();
    if (currentTime - previousTime >= interval) {
      //Serial.println("Checking locker status...");
      previousTime = currentTime;
      
      updateStatus(); // Check for abnormal lockers
      //publishAbnormalLockers(abnormalLockerId, NUMLOCKERS);
    }

    if(statusCheck == true){
        publishLockerStatus(checkLockerId, lockers[checkLockerId-1].status); // Publish locker status
        statusCheck = false; // Reset the flag
    }
    //previousTime = millis();

    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

void setup(){
  Wire.begin();
  keypad.begin( makeKeymap(keys) );
  Serial.begin(9600);
  init_ultraSonic();
  Serial.println("Ultrasonic sensor initialized");
  pcf8574.begin();
  Serial.println("PCF8574 initialized");
  for(int i = 0; i < NUMLOCKERS; i++){
    lockers[i].lockerId = i+1;
    lockers[i].sensorDistance = 21.7;
    lockers[i].lockerPin = LOCKERPINS[i];
    pcf8574.pinMode(lockers[i].lockerPin, OUTPUT);
    pcf8574.digitalWrite(lockers[i].lockerPin, HIGH); // Activate solenoid
    pinMode(DOORSENSOR[i], INPUT_PULLUP);
    pinMode(LEDPINS[i], OUTPUT);
    digitalWrite(LEDPINS[i], HIGH); 
    lockers[i].doorStatus = digitalRead(DOORSENSOR[i]);
  }
  initWiFi();
  connectAWS();
  //initESPNOW();
  initLCD();
  init_finger();
  Serial.println("Fingerprint sensor initialized");
  startScreen();
  xTaskCreatePinnedToCore(
    codeForTask1,
    "led1Task",
    6114,
    NULL,
    1,
    &Task1,
    1);

  delay(500);  // needed to start-up task1
  xTaskCreatePinnedToCore(
    codeForTask2,
    "led2Task",
    6000,
    NULL,
    1,
    &Task2,
    0);
}

void loop() {
  // Empty loop, all tasks are handled in the task functions
  delay(1);
}
