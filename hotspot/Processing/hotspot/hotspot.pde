// inspired from this code
// http://processing.org/examples/brightness.html

import java.util.Date;
import processing.serial.*;
import toxi.geom.*;
import toxi.processing.*;
import processing.video.*;

Capture cam;

ToxiclibsSupport gfx;

float[] q = new float[4];

static final float TO_DEGREE = 180 / PI;

float newx = 0;
float newy = 0;
float newz = 0;

int speed = 5;

Serial port;
int interval = 0;

PImage img;

String currentState = "";

void setup() {
  size(500, 526);
  frameRate(30);
  img = loadImage("Le-Petit-Prince.jpg");
  img.loadPixels();
  // Only need to load the pixels[] array once, because we're only
  // manipulating pixels[] inside draw(), not drawing shapes.
  loadPixels();
  
  
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
  
  float x_degree = radianToDegree(-x_rad);
  float y_degree = radianToDegree(y_rad);
  float z_degree = radianToDegree(z_rad);


  
  newx -= x_degree/speed;
  newy -= y_degree;
  newy /= 2;
  newz -= z_degree/speed;
  
  //println("x_degree = "+x_degree + ", y_degree=" + y_degree + ", z_degree=" + z_degree );
  //println("x_degree = "+newx + ", y_degree=" + newy + ", z_degree=" + newz );
  //println("----");
  
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*img.width;
      // Get the R,G,B values from image
      float r,g,b;
      r = red (img.pixels[loc]);
      g = green (img.pixels[loc]);
      b = blue (img.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = newy;//dist(0,0,width,height);
      float d = dist(x, y, newz, newx);
      float adjustbrightness = 255*(maxdist-d)/maxdist;
      r += adjustbrightness;
      g += adjustbrightness;
      b += adjustbrightness;
      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      // Make a new color and set pixel in the window
      color c = color(r, g, b);
      //color c = color(r);
      pixels[y*width + x] = c;
    }
  }
  updatePixels();
  
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

