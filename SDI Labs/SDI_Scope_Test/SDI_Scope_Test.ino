///////scope SDI/////////////////////////
int k = 0;
const long maxBuffer = 1500;
long envVars[] = { 1, 500}; // number of points to average, size of buffer
int pinADC0 = A1;
int pinADC1 = A2;
long V_DAC_ADU;
float mV_per_ADU = 3280 / 4095.0;  // for SAMD21
//long arrV_ADU1[maxBuffer];
//double arrV_mV1[maxBuffer];
//long arrV_ADU2[maxBuffer];
//double arrV_mV2[maxBuffer];
//double V_DAC_V = 1.0;
//////timing////////////////////////////////////
long iBaudRate = 2000000;

void setup() {
  Serial.begin(iBaudRate);
  delay(1000);  //lets the serial port get initialized
  //V_DAC_ADU = V_DAC_V * 1023.0 / 3.28; // to use as a reference
  //analogWrite(A0, V_DAC_ADU);

}

void loop() {
  runScope();
}

void runScope() {
  int ADC0_ADU = 0;
  int ADC1_ADU = 0;
  int ADC0_mV = 0;
  int ADC1_mV = 0;
  
  for (long i = 0; i < envVars[0]; i++) {
    ADC0_ADU = ADC0_ADU + analogRead(pinADC0);
    ADC1_ADU = ADC1_ADU + analogRead(pinADC1);
  }
  ///// calc the average per point and converting to mV ////////
  for (int j = 0; j < envVars[1]; j++) {
    ADC0_mV = ADC0_ADU / (envVars[0] * 1.0) * mV_per_ADU;
    ADC1_mV = ADC1_ADU / (envVars[0] * 1.0) * mV_per_ADU;
    Serial.print(ADC0_mV);
    Serial.print(",");
    Serial.println(ADC1_mV);
  }
}

/*
void scopeSetUp() {
  if(k < 2) {
    if(Serial.available()) {
      String str = Serial.readString();
      envVars[k] = str.toInt();
      k++;
    }
  } else {
    k = 0;
    func_ScopeFast();
  }
}

void func_ScopeFast() {
  /////take the measurements quickly/////////////
  for (long j = 0; j < envVars[1]; j++) {  // take measurements quickly
    for (long i = 0; i < envVars[0]; i++) {
      arrV_ADU1[j] = arrV_ADU1[j] + analogRead(pinADC0);
      arrV_ADU1[j] = arrV_ADU1[j] + analogRead(pinADC1);
    }
  }

  ///// calc the average per point and converting to mV array////////
  for (int j = 0; j < envVars[1]; j++) {
    arrV_mV1[j] = arrV_ADU1[j] / (envVars[0] * 1.0) * mV_per_ADU;
    arrV_mV2[j] = arrV_ADU2[j] / (envVars[0] * 1.0) * mV_per_ADU;
    Serial.print(arrV_mV1[j]);
    Serial.print(",");
    Serial.println(arrV_mV1[j]);
  }
}
*/