#include <Arduino.h>
#include "PCF8574.h"

#define SOUND_SPEED 0.034 // Speed of sound in cm/us
#define NUMLOCKERS 3
// Set i2c address
PCF8574 pcf8574(0x20);

// Define pins
const int TRIG_PINS[NUMLOCKERS] = {27,32,4};
const int ECHO_PINS[NUMLOCKERS] = {26,23,18};

typedef struct {
    long duration;
    float distanceCm;
    int trigPin;
    int echoPin;
} ultraSonicSensor;

ultraSonicSensor sensors[NUMLOCKERS];

void init_ultraSonic() {
    for (int i = 0; i < NUMLOCKERS; i++) {
        sensors[i].trigPin = TRIG_PINS[i];
        sensors[i].echoPin = ECHO_PINS[i];
        
        pinMode(sensors[i].trigPin, OUTPUT);
        pinMode(sensors[i].echoPin, INPUT);
    }
}

