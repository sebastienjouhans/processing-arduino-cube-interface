// I2C device class (I2Cdev) demonstration Processing sketch for MPU6050 DMP output
// 6/20/2012 by Jeff Rowberg <jeff@rowberg.net>
// Updates should (hopefully) always be available at https://github.com/jrowberg/i2cdevlib
//
// Changelog:
//     2012-06-20 - initial release

/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2012 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/

import java.util.Date;
import processing.serial.*;
import toxi.geom.*;
import toxi.processing.*;
import processing.video.*;

Capture cam;

ToxiclibsSupport gfx;

float[] q = new float[4];

static final float TO_DEGREE = 180 / PI;
static final String FLAT = "flat";
static final String RIGHT = "right";
static final String LEFT = "left";
static final String UP_SIDE_DOWN = "up_side_down";
static final String DESTINATION_FOLDER = "c:/Users/sebastienj/Dropbox/Public/workshop_IxDA";

float x_degree;
float y_degree;
float z_degree;

Serial port;
int interval = 0;

String currentState = "";

void setup() {
    // 300px square viewport using OpenGL rendering
  size(640, 480);
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();    
  }     
  
  gfx = new ToxiclibsSupport(this);

  // display serial port list for debugging/clarity
  println(Serial.list());

  String portName = Serial.list()[2];
  
  // open the serial port
  port = new Serial(this, portName, 38400);
  port.bufferUntil('\n');
  // send single character to trigger DMP init/start
  // (expected by MPU6050_DMP6 example Arduino sketch)
  port.write('r');
  //DA - I added two more of these because the program seems to hang otherwise
  port.write('r');
  port.write('r');
}

void draw() {
  if (millis() - interval > 1000) {
      // resend single character to trigger DMP init/start
      // in case the MPU is halted/reset while applet is running
      port.write('r');
      interval = millis();
  }
  
  // black background
  background(0);

  float y_rad = atan2(2*(q[3] * q[2] + q[0] * q[3]), q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3]);
  float x_rad = atan2(2*(q[2] * q[3] + q[0] * q[1]), q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3]);
  float z_rad = asin(2*(q[1] * q[3] - q[0] * q[2]));
  
  x_degree = radianToDegree(-x_rad);
  y_degree = radianToDegree(y_rad+0.77190705);
  z_degree = radianToDegree(z_rad);

  //println("x_degree = "+x_degree + ", y_degree=" + y_degree + ", z_degree=" + z_degree );
  
  String newState = "";
  
  if(x_degree < 15 && x_degree > -15 &&
     z_degree < 15 && z_degree > -15)
  {
    newState = FLAT;
  }
  else if(x_degree < 15 && x_degree > -15 &&
     z_degree < 70 && z_degree > 50)
  {
    newState = LEFT;
  }
  else if(x_degree < 15 && x_degree > -15 &&
     z_degree > -70 && z_degree < -50)
  {
    newState = RIGHT;
  }
  else if(x_degree >-185 && x_degree <-155 &&
     z_degree < 15 && z_degree > -15 || 
     x_degree <185 && x_degree >155 &&
     z_degree < 15 && z_degree > -15)
  {
    newState = UP_SIDE_DOWN;
  }
  
    
  // tint image in relation to the y angle of the sensor
  tint(y_degree+100);
  
  // draw output from the camera
  drawPicture();

  if(newState == LEFT && currentState!=newState)
  {
    println("snapshot");
    takeSnapshot();
  }
  
  currentState = newState;
  
}


void drawPicture()
{
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
}


void takeSnapshot()
{
  PImage img;
  Date d = new Date();
  long current = d.getTime()/1000;
  saveFrame(DESTINATION_FOLDER +"/img"+current+".jpeg");
}


float radianToDegree(float radian)
{
   return radian * TO_DEGREE;
}


void serialEvent(Serial port) {

   String inString = (port.readString());
   //print(inString); 
        
    String[] dataStrings = split(inString, '\t');
    if(dataStrings.length==5 && (dataStrings[0]).equals("quat"))
    for (int i = 0; i < dataStrings.length; i++) 
    {
        q[0] = float(dataStrings[1]); //w
        q[1] = float(dataStrings[2]); //x
        q[2] = float(dataStrings[3]); //y
        q[3] = float(dataStrings[4]); //z
        
//        print(q[0]);
//        print(", ");
//        print(q[1]);
//        print(", ");
//        print(q[2]);
//        print(", ");
//        println(q[3]);
        
      
    }
}

