///////scope SDI/////////////////////////
int k = 0;
const long maxBuffer = 1500;
long envVars[] = { 1, 500}; // number of points to average, size of buffer
int pinADC0 = A1;
long V_DAC_ADU;
float mV_per_ADU = 3280 / 4095.0;  // for SAMD21
long arrV_ADU[maxBuffer];
double arrV_mV[maxBuffer];
double arrTime_msec[maxBuffer];
long arrCounter[maxBuffer];
long V_ADU;
double V_mV;
float Time_point_sec;
float Time_point_msec;
float Time_X_usec;
//////timing////////////////////////////////////
long iTime_stop_usec;
int iCounter1;
long iTime_start_usec;
long iTime0_msec;
long iBaudRate = 2000000;

void setup() {
  Serial.begin(iBaudRate);
  delay(1000);  //lets the serial port get initialized
  analogReadResolution(12);
  analogWriteResolution(10);
  V_DAC_ADU = 1.0 * 1023.0 / 3.28; // to use as a reference
  analogWrite(A0, V_DAC_ADU);

}

void loop() {
  scopeSetUp();
}

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
  //////initialize the averaging loop/////////////////
  for (long j = 0; j < envVars[1]; j++) {
    arrV_ADU[j] = 0;
  }

  iTime_start_usec = micros();
  /////take the measurements quickly/////////////
  for (long j = 0; j < envVars[1]; j++) {  // take measurements quickly
    for (long i = 0; i < envVars[0]; i++) {
      arrV_ADU[j] = arrV_ADU[j] + analogRead(pinADC0);
    }
  }

  ////collected the buffer of data//////////////////////////
  Time_X_usec = (micros() - iTime_start_usec * 1.0) / (envVars[1] - 1);
  ///// calc the average per point and converting to mV array////////
  for (int j = 0; j < envVars[1]; j++) {
    arrV_mV[j] = arrV_ADU[j] / (envVars[0] * 1.0) * mV_per_ADU;
    arrTime_msec[j] = (j - 1) * Time_X_usec;
    //Serial.println(arrV_ADU[j]);
    Serial.println(arrV_mV[j]);
    //Serial.println(Time_X_usec,3);
  }
}
