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

  // If message fits the screen, just print it
  if (message.length() <= lcdColumns) {
    I2C_LCD.setCursor(0, row);
    I2C_LCD.print(message);
    return;
  }

  // Scroll the message one full pass
  int scrollLength = message.length() - lcdColumns;

  for (int pos = 0; pos <= scrollLength; pos++) {
    I2C_LCD.setCursor(0, row);
    I2C_LCD.print(message.substring(pos, pos + lcdColumns));
    delay(delayTime);
  }

  // Pause slightly before returning to start
  delay(500);

  // Reset to beginning of message
  I2C_LCD.setCursor(0, row);
  I2C_LCD.print(message.substring(0, lcdColumns));
}


void startScreen() {
  I2C_LCD.clear();
  I2C_LCD.setCursor(0, 0);
  I2C_LCD.print("A .Register");
  I2C_LCD.setCursor(0, 1);
  I2C_LCD.print("B .Assign Locker");
  I2C_LCD.setCursor(0, 2);
  I2C_LCD.print("C .Access Locker");
  I2C_LCD.setCursor(0, 3);
  I2C_LCD.print("D .Release Locker");
}


