long iCounter1 = 0;
long iBaudRate = 2000000;

void setup() {
  Serial.begin(iBaudRate);
  delay(1000); //lets the serial port get initialized
}
void loop() {
  //func_testBaudRate();
  iCounter1++;
  Serial.print(sin(iCounter1 / 100.0 * 2.0 * PI)); 
  Serial.println();
  delay(1);
}
