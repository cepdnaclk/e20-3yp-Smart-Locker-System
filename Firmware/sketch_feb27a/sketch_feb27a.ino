#include <Keypad.h>
#include <Wire.h> 
#include <Arduino_BuiltIn.h>
#include "utils.h"
#include <PubSubClient.h>
#include <base64.h>
#include "lcd.h"
#include "solenoid.h"
#include "fingerPrint.h"

#define ROWS  4
#define COLS  4
#define RELAY_PIN 5


char keyMap[ROWS][COLS] = {
  {'1','2','3', 'A'},
  {'4','5','6', 'B'},
  {'7','8','9', 'C'},
  {'*','0','#', 'D'}
};


uint8_t rowPins[ROWS] = {14, 27, 26, 25}; // GPIO14, GPIO27, GPIO26, GPIO25
uint8_t colPins[COLS] = {33, 32, 18, 19}; // GPIO33, GPIO32, GPIO18, GPIO19
uint8_t LCD_CursorPosition = 0;
String InputStr = "";
uint8_t idS = 1;
String user = "";
uint8_t id;


Keypad keypad = Keypad(makeKeymap(keyMap), rowPins, colPins, ROWS, COLS);



void setup(){
  Serial.begin(115200);
  initWiFi();
  connectAWS();
  initESPNOW();
  initLCD();
  //init_finger();
  startScreen();
}


void loop(){
  if(WiFi.status() != WL_CONNECTED){
    Serial.println("WiFi not connected! Attempting to reconnect...");
    initWiFi();
  }

  if (!client.connected()) {
        Serial.println("MQTT Client not connected! Attempting to reconnect...");
        connectAWS(); // Reconnect to AWS IoT
  }

  char key = keypad.getKey();
  if (key == 'A') {
    I2C_LCD.clear();
    I2C_LCD.setCursor(0, 0);
    I2C_LCD.print("Enter ID: ");
    LCD_CursorPosition = 0;
    while (true) {
        char passKey = keypad.getKey();
        if (passKey) {
            if (passKey == 'D') {  // Press 'D' to submit ID
                break;
            }
            user += passKey;
            I2C_LCD.setCursor(LCD_CursorPosition++, 1);
            I2C_LCD.print(passKey);
        }
    }
    publishIDMessage(user); // Publish the registration ID
    client.loop();
    delay(1000);

    // Wait for the password to be received
    I2C_LCD.clear();
    I2C_LCD.setCursor(0, 0);
    I2C_LCD.print("Waiting for password...");
    passwordReceived = false; // Reset the flag
    while (!passwordReceived) {
        client.loop(); // Keep the MQTT client running
        delay(100);    // Small delay to avoid busy-waiting
    }
    I2C_LCD.clear();
    I2C_LCD.setCursor(0, 0);
    I2C_LCD.print(PassWord);
    delay(1000);

    I2C_LCD.clear();
    I2C_LCD.print("Enter Code: ");
    LCD_CursorPosition = 0;
    InputStr = ""; // Clear the input string
    while (true) {
        char passKey = keypad.getKey();
        if (passKey) {
            if (passKey == 'D') {  // Press 'D' to submit code
                break;
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
        while (!getFingerprintEnroll(idS));
        delay(2000);
        //sendFingerprint(idS);
        idS++;
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
    I2C_LCD.setCursor(0, 0);
    I2C_LCD.print("Place Finger on");
    I2C_LCD.setCursor(0, 1);
    I2C_LCD.print("Sensor...");
    Serial.println("Place Finger on Sensor...");

    uint8_t match = getFingerprintIDez();  // Try reading a fingerprint

    if (match > 0) { // Check if a valid fingerprint ID is returned
        Serial.println("Fingerprint Matched!");
        I2C_LCD.clear();
        I2C_LCD.setCursor(0, 0);
        I2C_LCD.print("Access Granted!");
        I2C_LCD.setCursor(0, 1);
        I2C_LCD.print("Locker No: ");
        I2C_LCD.print(match); // Display the matched fingerprint ID
        digitalWrite(RELAY_PIN, LOW);  // Unlock
        delay(5000);
        digitalWrite(RELAY_PIN, HIGH); // Lock again
    } else {
        Serial.println("No Match Found.");
        I2C_LCD.clear();
        I2C_LCD.setCursor(0, 0);
        I2C_LCD.print("Access Denied!");
        delay(2000);
    }

    startScreen(); // Go back to the main menu
  }else{
    //Serial.print("Bahukapm");
    //startScreen();
  }
  
}



