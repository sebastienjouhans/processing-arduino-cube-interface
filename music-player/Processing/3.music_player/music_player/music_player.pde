import processing.serial.*;
import processing.opengl.*;


int interval = 0;

// store instance of the Serial class
Serial port;

// stores data representing the rotation coming from the arduino
float[] q = new float[4];


// degree rotation of the sensor
float x_degree = 0;
float y_degree = 0;
float z_degree = 0;


// properties to keep track of what state the cube is on
boolean togglePlaySelected;
boolean prevSelected;
boolean nextSelected;

int volume = 0;


void setup() {
  // draw window
  size(100, 100);
  
  loadMusic();
   
  // listt all available serial port
  println(Serial.list());
  
  // get port name of where the arduino is plugged in 
  // this will change depending on the USB port where the Arduino board is plugged in
  String portName = Serial.list()[2];
  
  // open the serial port
  port = new Serial(this, portName, 38400);
  
  // only raise the serialEvent() function when the incoming data contains \n (return to line)
  port.bufferUntil('\n');
  // send single character to trigger DMP init/start
  // (expected by MPU6050_DMP6 example Arduino sketch)
  port.write('r');
  //DA - I added two more of these because the program seems to hang otherwise
  port.write('r');
  port.write('r');
}






// this function is called everytime data is being recived on the USB port
void serialEvent(Serial port) 
{
  //read the whole string in the buffer
  String inString = (port.readString());
  //print(inString); 
        
  //split the string everytime a tab is met and store the values in an array string
  String[] dataStrings = split(inString, '\t');
  
  // make sure all the data is present before processing it
  if(dataStrings.length==5 && (dataStrings[0]).equals("quat"))
  {
    for (int i = 0; i < dataStrings.length; i++) 
    {
      q[0] = float(dataStrings[1]); //w
      q[1] = float(dataStrings[2]); //x
      q[2] = float(dataStrings[3]); //y
      q[3] = float(dataStrings[4]); //z
          
//      print(q[0]);
//      print(", ");
//      print(q[1]);
//      print(", ");
//      print(q[2]);
//      print(", ");
//      println(q[3]);
    } 
      
  }
}




void draw() {
  // this code is only there to reset the sensor if it appear unresponsive
  if (millis() - interval > 1000) {
      // resend single character to trigger DMP init/start
      // in case the MPU is halted/reset while applet is running
      port.write('r');
      interval = millis();
  }
  
  // get sensor rotations in degrees from the sensor
  getSensorRotation(q);

  //println("x_degree = "+x_degree + ", y_degree=" + y_degree + ", z_degree=" + z_degree );
  
  
  // make sure to reset all states if the cube is in neutral position
  //resetAllStates();
  
  cubeManipulation();
  
}



void resetAllStates()
{
  println("reset");
  if (x_degree >- 40) {
    togglePlaySelected = false;
  }
  if (y_degree > -40) {
    prevSelected = false;
  }
  if (y_degree < 40) {
    nextSelected = false;
  }
}



void cubeManipulation()
{

  // toggle play / pause
 if (x_degree <- 40 && prevSelected == false && nextSelected == false && togglePlaySelected==false) 
 {    
    println("toggle play / pause");
    togglePlay();
    togglePlaySelected = true;
  }
  else if(x_degree >=- 40)
  {
    togglePlaySelected = false;
  }
  
  
  
  
   // previous track
  if (y_degree > 40 && prevSelected == false && nextSelected == false && togglePlaySelected==false) 
  {
    println("prev");    
    prev();
    prevSelected = true;
  }
  else if(y_degree <=40)
  {
    prevSelected = false;
  }
  
  
  
   // next track
  if (y_degree < -40  && prevSelected == false && nextSelected == false && togglePlaySelected==false) 
  {
    println("next");    
    next();
    nextSelected = true;
    
  }
  else if(y_degree >= -40)
  {
    nextSelected = false;
  }
  
  
  
  
  // 
  if (prevSelected == false && nextSelected == false && togglePlaySelected==false) 
  {
    
    // map degree scale rotation from 90 to -130 to gains scale from -45 to 5db
    // because the AudioPlayer works with gain
    float volMapped = map(-z_degree-110, 90, -130, -45, 5);
    int volRounded = floor(volMapped);
    if (volRounded < -45) volRounded = -45;
    if (volRounded > 5) volRounded = 5;
println(z_degree);
    //println(volRounded);
    if (volRounded != volume) 
    {     
      changeVolume(volRounded);
      volume = volRounded;
    }
  } 
}


boolean IsCubeInNeutralPosition()
{
  return (togglePlaySelected == false && prevSelected == false && nextSelected == false);
}




