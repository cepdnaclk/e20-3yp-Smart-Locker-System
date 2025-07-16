#include <Arduino.h>
#include <unity.h>
#include "PCF8574.h"

#define NUMLOCKERS 3
PCF8574 pcf8574(0x20);

// Define pin arrays
const int DOORSENSOR[NUMLOCKERS] = {13, 25, 5};
const int LEDPINS[NUMLOCKERS] = {14, 33, 19};
const int LOCKERPINS[NUMLOCKERS] = {P0, P1, P2};  // Replace P0, P1, P2 with actual GPIOs

// --- LED Test ---
void test_all_leds() {
    for (int i = 0; i < NUMLOCKERS; i++) {
        pinMode(LEDPINS[i], OUTPUT);

        digitalWrite(LEDPINS[i], HIGH);
        delay(10);
        TEST_ASSERT_EQUAL(HIGH, digitalRead(LEDPINS[i]));

        digitalWrite(LEDPINS[i], LOW);
        delay(10);
        TEST_ASSERT_EQUAL(LOW, digitalRead(LEDPINS[i]));
    }
}

// --- Lock Control Test ---
void test_all_locks() {
    for (int i = 0; i < NUMLOCKERS; i++) {
        pcf8574.pinMode(LOCKERPINS[i], OUTPUT);

        pcf8574.digitalWrite(LOCKERPINS[i], HIGH);
        delay(10);
        TEST_ASSERT_EQUAL(HIGH, pcf8574.digitalRead(LOCKERPINS[i]));

        pcf8574.digitalWrite(LOCKERPINS[i], LOW);
        delay(10);
        TEST_ASSERT_EQUAL(LOW, pcf8574.digitalRead(LOCKERPINS[i]));
    }
}

// --- Door Sensor Test ---
void test_all_door_sensors() {
    for (int i = 0; i < NUMLOCKERS; i++) {
        pinMode(DOORSENSOR[i], INPUT);
        int value = digitalRead(DOORSENSOR[i]);
        TEST_ASSERT_TRUE(value == HIGH || value == LOW);
    }
}

// --- Setup and Run ---
void setup() {
    delay(2000); // Time for serial monitor
    UNITY_BEGIN();

    RUN_TEST(test_all_leds);
    RUN_TEST(test_all_locks);
    RUN_TEST(test_all_door_sensors);

    UNITY_END();
}

void loop() {
    // Nothing here
}
