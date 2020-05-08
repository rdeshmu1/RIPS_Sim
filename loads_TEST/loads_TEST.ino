const int instrument[] = {3, 5, 6, 9}; // COMP = 3, ASI = 5, MS = 6, Ant = 9

void setup() {

  Serial.begin(9600); // open a serial port

  for (byte i = 0; i < 4; i = i+1) {
  pinMode(instrument[i], OUTPUT);
  digitalWrite(instrument[i], LOW); }


}

void loop() {

    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn on ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.println("Instruments in Use: Computer (RED)");

    delay(2000);

    digitalWrite(instrument[0],LOW); // turn on Computer
    digitalWrite(instrument[1],HIGH); // turn off ASI
    digitalWrite(instrument[2],LOW); // turn on MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.println("Instruments in Use: ASI (BLUE)");

    delay(2000);

    digitalWrite(instrument[0],LOW); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn off ASI
    digitalWrite(instrument[2],HIGH); // turn off MS
    digitalWrite(instrument[3],LOW); // turn on Ant
    Serial.println("Instruments in Use: MS (YELLOW)");

    delay(2000);

    digitalWrite(instrument[0],LOW); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn off ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],HIGH); // turn on Ant
    Serial.println("Instruments in Use: Antenna (GREEN)");

    delay(2000);

}
