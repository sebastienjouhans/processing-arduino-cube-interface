import processing.serial.*;

Serial port;
float val;

String data;

void setup()
{
  size(440,220);
  println(Serial.list());
  String arduinoPort = Serial.list()[2];
  port = new Serial(this, arduinoPort, 9600);
  port.bufferUntil('\n');

}

void serialEvent(Serial p) {
  data = port.readString();
}

void draw()
{
  background(102);  

  if (data != null && data!="") 
  {
    println(data);
    //val= map(Float.valueOf(data).floatValue(), 0, 255, 0, height);
  }  
  rect(40, val-10, 360, 20);
}
