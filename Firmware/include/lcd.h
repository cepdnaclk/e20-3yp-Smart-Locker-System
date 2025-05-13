#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C I2C_LCD(0x27, 20, 4);  // LCD I2C address 0x27, 20x4 display

void initLCD(){
  // Initialize The I2C LCD
  I2C_LCD.init();
  // Turn ON The Backlight
  I2C_LCD.backlight();
  // Clear The Display
  I2C_LCD.clear();
}

void scrollText(int row, String message) {
  int delayTime = 300;
  int lcdColumns = 20;

  // If the message fits, print it without scrolling
  if (message.length() <= lcdColumns) {
    I2C_LCD.setCursor(0, row);
    I2C_LCD.print(message);
    return;
  }

  // Append the message to itself with a space to create loop effect
  String scrollMessage = message + "     " + message;  // 3 spaces = small pause before repeating

  // Scroll through only the first (message.length + lcdColumns) characters
  int scrollLength = message.length() + 5; // scroll till just before repeat starts

  for (int pos = 0; pos < scrollLength; pos++) {
    I2C_LCD.setCursor(0, row);
    I2C_LCD.print(scrollMessage.substring(pos, pos + lcdColumns));
    /*if (pos == 0) {
      delay(delayTime);  // Extra pause at the start
    }*/
    delay(delayTime);
  }
}

void startScreen() {
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  I2C_LCD.print("Choose an option");
  I2C_LCD.setCursor(0, 1);
  I2C_LCD.print("A .Register");
  scrollText(2,"B. Unlock");
}


