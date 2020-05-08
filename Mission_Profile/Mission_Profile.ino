/*  Going to simulate orange portion of mission profile (ammonia ice)
 *  0:35 - 1:35 in increments of 5 minutes --> 1 hour (set 0:35 to 0)
 *  This will be a condensed mission profile of 12 minutes 
 *  (i.e. divide everything by 5)
 *  
 *  original time (min)   Arduino time (min)    Instruments on
 *  -------------          ------------         --------------
 *     0 - 10                 0 - 2             Computer, ASI
 *    10 - 15                 2 - 3             Computer, MS
 *    15 - 20                 3 - 4             Computer, Antenna
 *    20 - 35                 4 - 7             Computer
 *    35 - 45                 7 - 9             Computer, MS
 *    45 - 60                 9 - 12            Computer, ASI
 *    
 */

// SD card setup
#include <SPI.h>
#include <SD.h>
const int chipSelect = 10;

// loads setup
const int instrument[] = {3, 5, 6, 9}; // COMP = 3, ASI = 5, MS = 6, Ant = 9
unsigned long minutes = 60000;

// display setup
String str1, str2, str3;

// voltage read setup
#define NUM_SAMPLES 10          // number of analog samples to take per reading
int sum = 0;                    // sum of samples taken
unsigned char sample_count = 0; // current sample number
float voltage = 0.0;            // calculated voltage

// supercapacitors setup
const int capacitance = 20; // farads, total equivalent capacitance of supercapacitor array
float enstored = 0.0; // calculated energy stored

void setup() {
  Serial.begin(9600); // open a serial port

  str1 = String(":");
  str2 = String(",");
  str3 = String();
  
  for (byte i = 0; i < 4; i = i+1) {
  pinMode(instrument[i], OUTPUT);
  digitalWrite(instrument[i], LOW); }

  Serial.print("Initializing SD card...");

  // see if card is present and can be initialized:
  if (!SD.begin(chipSelect)){
  Serial.println("Card failed, or not present");
  while (1);}
  Serial.println("Card initialized.");
  
  Serial.println("Beginning Mission");
  delay(3000);

}

void loop() {

  // make a string for assembling the data to log:
  String dataString = "";

  unsigned long runMillis = millis();
  unsigned long allSeconds = millis()/1000;
  int runHours = allSeconds/3600;
  int secsRemaining = allSeconds%3600;
  int runMinutes = secsRemaining/60;
  int runSeconds = secsRemaining%60;

  str3 = runHours + str1 + runMinutes + str1 + runSeconds + str2;
  dataString += str3;

  Serial.print(runHours);
  Serial.print(":");
  Serial.print(runMinutes);
  Serial.print(":");
  Serial.print(runSeconds);
  Serial.print("   ");
 
   if ((millis() > minutes*0) && (millis() <= minutes*2)) {
    
    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],HIGH); // turn on ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.print("Instruments in Use: Computer, ASI   ");
    char myStr[] = "1100,";
    dataString += String(myStr); }
   
   else if ((millis() > minutes*2) && (millis() <= minutes*3)){
    
    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn off ASI
    digitalWrite(instrument[2],HIGH); // turn on MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.print("Instruments in Use: Computer, MS   ");
    char myStr[] = "1010,";
    dataString += String(myStr); }

   else if ((millis() > minutes*3) && (millis() <= minutes*4)){
    
    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn off ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],HIGH); // turn on Ant
    Serial.print("Instruments in Use: Computer, Antenna   ");
    char myStr[] = "1001,";
    dataString += String(myStr); }

   else if ((millis() > minutes*4) && (millis() <= minutes*7)){
    
    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn off ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.print("Instruments in Use: Computer   ");
    char myStr[] = "1000,";
    dataString += String(myStr); }

   else if ((millis() > minutes*7) && (millis() <= minutes*9)){

    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn off ASI
    digitalWrite(instrument[2],HIGH); // turn on MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.print("Instruments in Use: Computer, MS   ");
    char myStr[] = "1010,";
    dataString += String(myStr); }

   else if ((millis() > minutes*9) && (millis() <= minutes*12)){
    
    digitalWrite(instrument[0],HIGH); // turn on Computer
    digitalWrite(instrument[1],HIGH); // turn on ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.print("Instruments in Use: Computer, ASI   ");
    char myStr[] = "1100,";
    dataString += String(myStr); }

   else if (millis() > minutes*12){

    digitalWrite(instrument[0],LOW); // turn on Computer
    digitalWrite(instrument[1],LOW); // turn on ASI
    digitalWrite(instrument[2],LOW); // turn off MS
    digitalWrite(instrument[3],LOW); // turn off Ant
    Serial.print("Mission Complete    ");
    char myStr[] = "0000";
    dataString += String(myStr); }

    // take a number of analog samples and add them up

    
    while (sample_count < NUM_SAMPLES) {
      sum += analogRead(A5);
      sample_count++;
      delay(10); } 

    voltage = (((float)sum / (float)NUM_SAMPLES * 5.002) / 1024.0) * 9.35; // calculate voltage with voltage divider
    dataString += String(voltage) + str2;
    Serial.print(voltage);
    Serial.print("V   Energy Stored: ");
    sample_count = 0;
    sum = 0; 

    enstored = 0.5 * capacitance * pow(voltage,2) * 0.28; // joules to milli-Wh, E = 0.5 * C * V^2
    dataString += String(enstored) + str2;
    Serial.print(enstored);
    Serial.println(" mWh");

// open SD file. Note that only one file can be open at a time,
// so you have to close this one before opening another.

File dataFile = SD.open("datalog.txt", FILE_WRITE);

// if file is available, write to it:
if (dataFile) {
  dataFile.println(dataString);
  dataFile.close();
  }

else {
  Serial.println("Error opening datalog.txt");
}
  
}

/* Previous code...
 *  
 *  before setup:
 *    unsigned long tstart;
 *    unsigned long tend;
 *    
 *  in void:
 *    tstart = millis();
 *    tend = tstart;
 *    while((tend-tstart) <= 1000) {
 *    Serial.println("1 second");
 *    tend = millis(); }
 */

 /* testing functionality of SD card:
  * open file to write to
  myFile = SD.open("test.txt",FILE_WRITE);

  // if file opened okay, write to it:
  if (myFile) {
  Serial.print("Writing to test.txt...");
  myFile.println("testing 1,2,3.");
  myFile.close();
  Serial.println("done."); }

  // if the file didn't open, print an error:
  else {
  Serial.println("error opening test.txt"); } */
