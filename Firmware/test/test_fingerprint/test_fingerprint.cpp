#include <Arduino.h>
#include <unity.h>
#include <Adafruit_Fingerprint.h>
#include <HardwareSerial.h>

HardwareSerial fingerSerial(1);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&fingerSerial);

void test_sensor_begin() {
  fingerSerial.begin(57600, SERIAL_8N1, 16, 17);
  // no return value
  // Instead, check something else to verify sensor is responding.
  // For example, get the template count and expect no error.
  uint8_t p = finger.getTemplateCount();
  TEST_ASSERT_NOT_EQUAL(FINGERPRINT_PACKETRECIEVEERR, p);  // not communication error
}

void test_get_template_count() {
  finger.getTemplateCount();
  // templateCount is updated by getTemplateCount()
  TEST_ASSERT_TRUE_MESSAGE(finger.templateCount >= 0, "Invalid template count");
}

void test_get_image() {
  uint8_t result = finger.getImage();
  TEST_ASSERT_TRUE_MESSAGE(result == FINGERPRINT_OK || result == FINGERPRINT_NOFINGER, "Unexpected getImage result");
}

void setup() {
  Serial.begin(115200);
  delay(2000);
  fingerSerial.begin(57600, SERIAL_8N1, 16, 17); // RX=16, TX=17 (change pins if needed)

  UNITY_BEGIN();

  RUN_TEST(test_sensor_begin);
  RUN_TEST(test_get_template_count);
  RUN_TEST(test_get_image);

  UNITY_END();
}

void loop() {
  // Nothing here
}
