#include <WiFi.h>
#include <PubSubClient.h>
#include <unity.h>
#include <utils.h>

// Test MQTT Publish
void test_mqtt_publish() {
  TEST_ASSERT_TRUE(connectAWS()); // Assert MQTT connection success

  bool published = client.publish("test/topic", "Hello from unit test");
  TEST_ASSERT_TRUE(published);     // Assert message published successfully
}

// Setup and run tests
void setup() {
  Serial.begin(115200);
  delay(2000); // Wait for Serial Monitor

  initWiFi();  // Connect to WiFi before starting tests

  UNITY_BEGIN();

  RUN_TEST(test_mqtt_publish);

  UNITY_END();
}

void loop() {
  // Nothing here
}
