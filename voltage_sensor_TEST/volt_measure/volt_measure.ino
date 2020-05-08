
// voltage measurements

#define NUM_SAMPLES 10          // number of analog samples to take per reading
int sum = 0;                    // sum of samples taken
unsigned char sample_count = 0; // current sample number
float voltage = 0.0;            // calculated voltage

void setup()
{
    Serial.begin(9600);  
}

void loop()
{
  
    // take a number of analog samples and add them up
  while (sample_count < NUM_SAMPLES) {
        sum += analogRead(A5);
        sample_count++;
        delay(10); }
    
    voltage = ((float)sum / (float)NUM_SAMPLES * 5.002) / 1024.0; // calculate voltage
    Serial.print(voltage * 9.35); // voltage divider, calibrated to multiply by 9.35
    Serial.println (" V");
    sample_count = 0;
    sum = 0; 
  
    }
    
