#include <Arduino.h>
#include <unity.h>

void test_led_builtin_on() {
    digitalWrite(2, HIGH);
    TEST_ASSERT_EQUAL(HIGH, digitalRead(2));
}

void setup() {
    pinMode(2, OUTPUT);
    digitalWrite(2, LOW);
    delay(2000); // Allow serial monitor to connect

    UNITY_BEGIN();
    RUN_TEST(test_led_builtin_on);
    UNITY_END();
}

void loop() {}
