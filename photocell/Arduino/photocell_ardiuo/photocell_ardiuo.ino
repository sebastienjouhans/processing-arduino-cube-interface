int sensorPin = 0;
int val = 0;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  val = analogRead(sensorPin) / 4;
  Serial.println(val);
  delay(100);
}
