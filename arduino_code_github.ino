#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "your wifi ssid"
#define WIFI_PASSWORD "your wifi password"

/* 2. Define the API Key */
#define API_KEY "your api key"

/* 3. Define the user Email and password for Firebase */
#define USER_EMAIL "your email"
#define USER_PASSWORD "your password"

/* 4. Define the RTDB URL */
#define DATABASE_URL "database url" 

#define LED_PIN D1 // Pin connected to the LED
#define ESP_CHECK_LED_PIN D2 // Pin connected to the LED for checking ESP functioning
#define BULB_STATE_NODE "/bulbState"

// Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

void setup()
{
  pinMode(LED_PIN, OUTPUT);
  pinMode(ESP_CHECK_LED_PIN, OUTPUT);
  
  digitalWrite(LED_PIN, LOW); // Start with the LED off

  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Set up Firebase
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;

  Firebase.reconnectNetwork(true);

  fbdo.setBSSLBufferSize(4096, 1024);
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);
  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;
}

void loop()
{
  digitalWrite(ESP_CHECK_LED_PIN, HIGH);
  // Firebase.ready() handles authentication tasks
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();

    String bulbState;
    if (Firebase.RTDB.getString(&fbdo, BULB_STATE_NODE, &bulbState))
    {
      Serial.print("Bulb state: ");
      Serial.println(bulbState);

      // Check if the string is "on" or "off" and control LED
      if (bulbState == "on")
      {
        digitalWrite(LED_PIN, LOW);  // Turn LED on
      }
      else if (bulbState == "off")
      {
        digitalWrite(LED_PIN, HIGH);   // Turn LED off
      }
    }
    else
    {
      Serial.print("Error reading bulbState: ");
      Serial.println(fbdo.errorReason().c_str());
    }
  }
  delay(100);
  digitalWrite(ESP_CHECK_LED_PIN, LOW);
}
