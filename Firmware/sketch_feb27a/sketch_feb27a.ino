
#include <Keypad.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <Adafruit_Fingerprint.h>
#include <Arduino_BuiltIn.h>
#include "utils.h"
#include <PubSubClient.h>

#define ROWS  4
#define COLS  4
#define RELAY_PIN 5
#define RXD2 16 // ESP32 RX2 pin (connect to sensor TX)
#define TXD2 17 // ESP32 TX2 pin (connect to sensor RX)

char keyMap[ROWS][COLS] = {
  {'1','2','3', 'A'},
  {'4','5','6', 'B'},
  {'7','8','9', 'C'},
  {'*','0','#', 'D'}
};
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&Serial2);

uint8_t rowPins[ROWS] = {14, 27, 26, 25}; // GPIO14, GPIO27, GPIO26, GPIO25
uint8_t colPins[COLS] = {33, 32, 18, 19}; // GPIO33, GPIO32, GPIO18, GPIO19
uint8_t LCD_CursorPosition = 0;

String InputStr = "";
uint8_t idS = 1;
String user = "";
uint8_t id;

Keypad keypad = Keypad(makeKeymap(keyMap), rowPins, colPins, ROWS, COLS);
LiquidCrystal_I2C I2C_LCD(0x27, 16, 2);  // LCD I2C address 0x27, 16x2 display

void startScreen() {
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  I2C_LCD.print("Choose an option");
  I2C_LCD.setCursor(0, 1);
  I2C_LCD.print("A .Register  B .Unlock");
}
 


void setup(){
  Serial.begin(115200);
  connectAWS();
  // Initialize The I2C LCD
  I2C_LCD.init();
  // Turn ON The Backlight
  I2C_LCD.backlight();
  // Clear The Display
  I2C_LCD.clear();
  // Initialize Serial2 with the specified pins
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

  startScreen();
  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, HIGH);

}


void loop(){
  client.loop();
  
  char key = keypad.getKey();
  
  if(key == 'A'){
    I2C_LCD.clear();
    I2C_LCD.setCursor(0, 0);
    I2C_LCD.print("Enter ID: ");
    LCD_CursorPosition = 0;
    while (true) {
        char passKey = keypad.getKey();
        if (passKey) {
          if (passKey == 'D') {  // Press '#' to submit password
            break;
          }
          user += passKey;
          I2C_LCD.setCursor(LCD_CursorPosition++, 1);
          //Serial.print("*");  // Mask password input
          I2C_LCD.print(passKey);
        }
    }
    I2C_LCD.clear();
    I2C_LCD.print(PassWord);
    delay(1000);
    I2C_LCD.clear();
    I2C_LCD.print("Enter Code: ");
    LCD_CursorPosition = 0;
    while (true) {
        char passKey = keypad.getKey();
        if (passKey) {
          if (passKey == 'D') {  // Press '#' to submit password
            break;
          }
          InputStr += passKey;
          I2C_LCD.setCursor(LCD_CursorPosition++, 1);
          //Serial.print("*");  // Mask password input
          I2C_LCD.print(passKey);
        }
    }
    I2C_LCD.clear();
    LCD_CursorPosition = 0;
    String message;
    if(InputStr == PassWord) {
      I2C_LCD.print("Access Granted!");
      digitalWrite(RELAY_PIN, LOW);
      I2C_LCD.clear();
      I2C_LCD.setCursor(0, 0);
      I2C_LCD.print("Ready to register a fingerprint!");
      I2C_LCD.clear();
      I2C_LCD.setCursor(0, 0);
      /*I2C_LCD.print("Please enter the ID # (from 1 to 127)");
      while (true) {
        key = keypad.getKey();
        if (key) {
          if (key == 'D') {  // Press 'D' to submit password
            break;
          }
          idS += key;
          I2C_LCD.setCursor(LCD_CursorPosition++, 1);
          //Serial.print("*");  // Mask password input
          I2C_LCD.print(key);
        }
      }*/
      I2C_LCD.clear();
      I2C_LCD.setCursor(0, 0);
      //I2C_LCD.print("Registering ID #");
      //I2C_LCD.print(id);
      I2C_LCD.clear();
      I2C_LCD.setCursor(0, 0);
      while (!getFingerprintEnroll(idS));
      //sendFingerprint(id); 
      idS++;
    }
    else {
      I2C_LCD.print("Wrong PassWord!");
    }
    delay(5000);
    InputStr = "";

    startScreen();
    digitalWrite(RELAY_PIN, HIGH);
  }
  else if (key == 'B'){
    I2C_LCD.print("Bahukapm");
    //startScreen();
  }else{
    Serial.print("Bahukapm");
    //startScreen();
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

  return true;
}

/*
void sendFingerprint(uint8_t id) {
    uint8_t templateData[512];  // Buffer for fingerprint template
    uint16_t templateLength = 0;
    String templateBase64 = "";  // Base64-encoded fingerprint template

    // Load the fingerprint template
    if (finger.loadModel(id) == FINGERPRINT_OK) {
        Serial.println("Fingerprint template loaded successfully!");

        // Upload the fingerprint template to a buffer
        templateLength = finger.uploadModel(templateData, sizeof(templateData));
        if (templateLength > 0) {
            Serial.println("Fingerprint template uploaded successfully!");

            // Convert to Base64
            templateBase64 = base64::encode(templateData, templateLength);
        } else {
            Serial.println("Failed to upload fingerprint template.");
            return;  // Exit the function if the template cannot be uploaded
        }
    } else {
        Serial.println("Failed to load fingerprint template.");
        return;  // Exit the function if the template cannot be loaded
    }

    // Publish the fingerprint data
    publishFingerprintData(id, templateBase64);

    // Ensure MQTT client loops for incoming messages
    client.loop();
    delay(1000);  // Wait for 1 second
}
*/
