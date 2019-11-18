// Need two loads of known weight. 
// Example: A = 5 lb
//          B = 15 lb
// Put on load A and read analog value (anaA) and do same for B

 float loadA = 0000; // lb
 int anaA = 0000; // analog reading for load A

 float loadB = 0000; // lb
 int anaB = 0000; // analog reading for load B

// Upload sketch again and confirm that kilo reading
// from serial output now is correct, using known loads

float anaAvg = 0;

// How often we do readings
long time = 0; //
int timeBetweenReadings = 2000; // want a reading every 200 ms

void setup() {
  Serial.begin(9600);

}

void loop() {
  
  int anaVal = analogRead(0);
  anaAvg = 0.99*anaAvg + 0.01*anaVal;

  if(millis()> time + timeBetweenReadings){
    float load = analogToLoad(anaAvg);

    Serial.print("Analog Value: ");
    Serial.println(anaAvg);
    Serial.print("    Load: ");
    Serial.println(load,5);
    time = millis();
  }
}

float analogToLoad(float anaVal){
  float load = mapfloat(anaVal,anaA,anaB,loadA,loadB);
  return load;
}

float mapfloat(float x, float in_min, float in_max, float out_min, float out_max){
  return (x -in_min)*(out_max - out_min) / (in_max - in_min) + out_min;
}
