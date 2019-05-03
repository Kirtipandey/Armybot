// FirebaseDemo_ESP8266 is a sample that demo the different functions
// of the FirebaseArduino API. 


#include <TinyGPS++.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

// Set these to run example.
#define FIREBASE_HOST "armybot-9eb62.firebaseio.com"
#define FIREBASE_AUTH "E6IQcW1mBzEHfyEX2DEuiY1xTVUlpnSm8OyjWHaW"

#define IN_1  D0          // L298N in1 motors Right           GPIO15(D8)
#define IN_2  D1          // L298N in2 motors Right           GPIO13(D7)
#define IN_3  D2           // L298N in3 motors Left            GPIO2(D4)
#define IN_4  D3           // L298N in4 motors Left            GPIO0(D3)

TinyGPSPlus gps;  // The TinyGPS++ object

SoftwareSerial ss(D7, D8); // The serial connection to the GPS device
int trigPin = D5;    // Trigger
int echoPin = D6;    // Echo

const char* ssid = "hotpot";
const char* password = "password";

float latitude , longitude;
int year , month , date, hour , minute , second;
String date_str , time_str , lat_str , lng_str;
int pm;
long duration, cm, inches;

void setup() {
  Serial.begin(9600);
 ss.begin(9600);
  
   pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  // CONNECT TO WIFI
  Serial.println();
  
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  // Print the IP address
  Serial.println(WiFi.localIP());
 
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.set("forward",0);
  Firebase.set("back",0);
  Firebase.set("right",0);
 Firebase.set("left",0);
  Firebase.set("stop",0);
  
}

int n = 0;

void loop() {
  int f=Firebase.getString("forward").toInt();
  int b=Firebase.getString("backward").toInt();
  int r=Firebase.getString("right").toInt();
  int l=Firebase.getString("left").toInt();
  int s=Firebase.getString("stop").toInt();
  
   if(  b==1){
      digitalWrite(IN_1, LOW);
      digitalWrite(IN_2, HIGH);
      digitalWrite(IN_3, LOW);
      digitalWrite(IN_4, HIGH);
   }
   if(  f==1){
      digitalWrite(IN_1, HIGH);
      digitalWrite(IN_2, LOW);
     
      digitalWrite(IN_3, HIGH);
      digitalWrite(IN_4, LOW);
   }
   if(  r==1){
      digitalWrite(IN_1, HIGH);
      digitalWrite(IN_2, LOW};
      digitalWrite(IN_3, LOW);
      digitalWrite(IN_4, HIGH);
   }
   if(  l==1){
      digitalWrite(IN_1, LOW);
      digitalWrite(IN_2, HIGH);
      digitalWrite(IN_3, HIGH);
      digitalWrite(IN_4, LOW);
   }
    if(  s==1){
      digitalWrite(IN_1, LOW);
      digitalWrite(IN_2, LOW);
      digitalWrite(IN_3, LOW);
      digitalWrite(IN_4, LOW);
   }
   
 
  while (ss.available() > 0)
    if (gps.encode(ss.read()))
    {
      if (gps.location.isValid())
      {
        latitude = gps.location.lat();
        lat_str = String(latitude );
        Serial.println(latitude);
        longitude = gps.location.lng();
        lng_str = String(longitude);
        Serial.println(longitude);
      }

      if (gps.date.isValid())
      {
        date_str = "";
        date = gps.date.day();
        month = gps.date.month();
        year = gps.date.year();

        if (date < 10)
          date_str = '0';
        date_str += String(date);

        date_str += " / ";

        if (month < 10)
          date_str += '0';
        date_str += String(month);

        date_str += " / ";

        if (year < 10)
          date_str += '0';
        date_str += String(year);
      }

      if (gps.time.isValid())
      {
        time_str = "";
        hour = gps.time.hour();
        minute = gps.time.minute();
        second = gps.time.second();

        minute = (minute + 30);
        if (minute > 59)
        {
          minute = minute - 60;
          hour = hour + 1;
        }
        hour = (hour + 5) ;
        if (hour > 23)
          hour = hour - 24;

        if (hour >= 12)
          pm = 1;
        else
          pm = 0;

        hour = hour % 12;

        if (hour < 10)
          time_str = '0';
        time_str += String(hour);

        time_str += " : ";

        if (minute < 10)
          time_str += '0';
        time_str += String(minute);

        time_str += " : ";

        if (second < 10)
          time_str += '0';
        time_str += String(second);

        if (pm == 1)
          time_str += " PM ";
        else
          time_str += " AM ";

      }
    }
     digitalWrite(trigPin, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH);
 
  // Convert the time into a distance
  cm = (duration/2) / 29.1;     // Divide by 29.1 or multiply by 0.0343
  inches = (duration/2) / 74;   // Divide by 74 or multiply by 0.0135
  
  Serial.print(inches);
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();
  
  delay(250);
} 
 
}

 
