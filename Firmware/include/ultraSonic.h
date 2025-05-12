#include <Arduino.h>

#define SOUND_SPEED 0.034 // Speed of sound in cm/us
#define NUMLOCKERS 3

// Define pins
const int TRIG_PINS[NUMLOCKERS] = {5, 19, 25};
const int ECHO_PINS[NUMLOCKERS] = {18, 23, 26};

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

void read_ultraSonic() {
    for (int i = 0; i < NUMLOCKERS; i++) {
        // Clear the trigPin
        digitalWrite(sensors[i].trigPin, LOW);
        delayMicroseconds(2);

        // Set the trigPin HIGH for 10 microseconds
        digitalWrite(sensors[i].trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(sensors[i].trigPin, LOW);

        // Read the echoPin, return the sound wave travel time in microseconds
        sensors[i].duration = pulseIn(sensors[i].echoPin, HIGH);

        // Calculate the distance in cm
        sensors[i].distanceCm = (sensors[i].duration * SOUND_SPEED) / 2;
    }
}