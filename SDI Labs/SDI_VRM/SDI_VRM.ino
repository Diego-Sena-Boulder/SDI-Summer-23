///////scope SDI/////////////////////////
int k = 0;
const long maxBuffer = 1200;
long envVars[] = { 1, 500, 0}; // number of points to average, size of buffer, DAC_ADU
int pinADC0 = A1;
int pinADC1 = A2;
float mV_per_ADU = 3280 / 4095.0;  // for SAMD21
long ADC0_ADU[maxBuffer];
double ADC0_mV[maxBuffer];
long ADC1_ADU[maxBuffer];
double ADC1_mV[maxBuffer];
//////timing////////////////////////////////////
long iBaudRate = 2000000;

void setup() {
  Serial.begin(iBaudRate);
  delay(1000);  //lets the serial port get initialized
  analogReadResolution(12);
  analogWriteResolution(10);
  analogWrite(A0, 0);

}

void loop() {
  scopeSetUp();
}

void scopeSetUp() {
  if(k < 3) {
    if(Serial.available()) {
      String str = Serial.readString();
      envVars[k] = str.toInt();
      k++;
    }
  } else {
    k = 0;
    analogWrite(A0, envVars[2]);
    func_ScopeFast();
  }
}

void func_ScopeFast() {

  /////take the measurements quickly/////////////
  for (long j = 0; j < envVars[1]; j++) {  // take measurements quickly
    for (long i = 0; i < envVars[0]; i++) {
      ADC0_ADU[j] = ADC0_ADU[j] + analogRead(pinADC0);
      ADC1_ADU[j] = ADC1_ADU[j] + analogRead(pinADC1);
    }
  }

  ///// calc the average per point and converting to mV array////////
  for (int j = 0; j < envVars[1]; j++) {
    ADC0_mV[j] = ADC0_ADU[j] / (envVars[0] * 1.0) * mV_per_ADU;
    ADC1_mV[j] = ADC1_ADU[j] / (envVars[0] * 1.0) * mV_per_ADU;
    Serial.print(ADC0_mV[j]);
    Serial.print(",");
    Serial.println(ADC1_mV[j]);
  }
}
