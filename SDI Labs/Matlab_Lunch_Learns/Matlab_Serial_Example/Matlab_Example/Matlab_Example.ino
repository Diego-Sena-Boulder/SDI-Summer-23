unsigned long current = 0;
unsigned long last = 0;
unsigned long adcDelay = 10; // delay 10000us or 10ms
int deg = 0;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("HELLO WORLD");
}

void loop() {
  // put your main code here, to run repeatedly:

  if(current - last >= adcDelay) {
    last = millis();
    Serial.println(10 * sin(radians(deg)));
    deg++;
    if(deg >= 360)
     deg = 0;
  }
  current = millis();
}
