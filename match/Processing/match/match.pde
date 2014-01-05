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

import processing.serial.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;


ToxiclibsSupport gfx;

static final float TO_DEGREE = 180 / PI;
Serial port;
int interval = 0;

float[] q = new float[4];

void setup() {
    // 300px square viewport using OpenGL rendering
    size(300, 300, OPENGL);
    gfx = new ToxiclibsSupport(this);

    // setup lights and antialiasing
    lights();
    smooth();
    noStroke();
  
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
    
    // translate everything to the middle of the viewport
    pushMatrix();
    translate(width / 2, height / 2);


    float y_rad = atan2(2*(q[3] * q[2] + q[0] * q[3]), q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3]);
    float x_rad = atan2(2*(q[2] * q[3] + q[0] * q[1]), q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3]);
    float z_rad = asin(2*(q[1] * q[3] - q[0] * q[2]));
    
    rotateY(y_rad+0.67190705);
    rotateZ(z_rad);
    rotateX(-x_rad);
    
    float x_degree = radianToDegree(-x_rad);
    float y_degree = radianToDegree(y_rad+0.77190705);
    float z_degree = radianToDegree(z_rad);

    println("x_degree = "+x_degree + ", y_degree=" + y_degree + ", z_degree=" + z_degree );

    drawCube();
    
    popMatrix();
}


void drawCube()
{
  fill(255, 0, 0, 200);
  box(10, 10, 200);
  
  translate(0, 0, -120);
  fill(0, 255, 0, 255);
  sphere(20);
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

