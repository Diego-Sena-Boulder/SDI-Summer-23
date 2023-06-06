///////scope SDI/////////////////////////
const long npts_arr = 500;  //array size for fast, averaging scope
long npts_ave = 1;          // number of consecutive points to average
int pinADC0 = A1;
long V_DAC_ADU;
float mV_per_ADU = 3280 / 4095.0;  // for SAMD21
long arrV_ADU[npts_arr];
double arrV_mV[npts_arr];
double arrTime_msec[npts_arr];
long arrCounter[npts_arr];
long V_ADU;
double V_mV;
float Time_point_sec;
float Time_point_msec;
float Time_X_usec;
//////stats/////////////////////////////////
double mean_ADU = 0.0;
double mean_mV = 0.0;
double sigma_ADU = 0.0;
double sigma_mV = 0.0;
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
  if(Serial.available()) {
    String str = Serial.readString();
    npts_ave = str.toInt();
    func_ScopeFast();
  }
}

void func_ScopeFast() {
  //////initialize the averaging loop/////////////////
  for (long j = 0; j < npts_arr; j++) {
    arrV_ADU[j] = 0;
  }

  iTime_start_usec = micros();
  /////take the measurements quickly/////////////
  for (long j = 0; j < npts_arr; j++) {  // take measurements quickly
    for (long i = 0; i < npts_ave; i++) {
      arrV_ADU[j] = arrV_ADU[j] + analogRead(pinADC0);
    }
  }

  ////collected the buffer of data//////////////////////////
  Time_X_usec = (micros() - iTime_start_usec * 1.0) / (npts_arr - 1);
  ///// calc the average per point and converting to mV array////////
  for (int j = 0; j < npts_arr; j++) {
    arrV_mV[j] = arrV_ADU[j] / (npts_ave * 1.0) * mV_per_ADU;
    arrTime_msec[j] = (j - 1) * Time_X_usec;
    //Serial.println(arrV_ADU[j]);
    Serial.println(arrV_mV[j]);
    //Serial.println(Time_X_usec,3);
  }
}
