Processing and Arduino - Cube Interface
=======================================

This project is the code RGA cube interface developed for a workshop in Amsterdam. Thanks to the MPU6050 sensor and the data it outputs we know its orientation.

The Arduino code captures the data from the sensor and sends it to Processing over the Serial port.
All these projects use the Quaternion output from Arduino but other are also available.

- cube orientation - gives the orienation of the sensor
- hotspot - controls a hotspot on image. moving the sensor left,right,up,down controls the hotspot position on the screen
- picture - uses the webcam, rotating the sensor on itself changes the tint of the image output. Tilting the sensor to the left takes a picture and saves it a folder
- match - 3d output that maps the orientation of the sensor on all 3 coordinates

This project makes use of the work done here: 
https://github.com/jrowberg/i2cdevlib/tree/master/Arduino/MPU6050

This is the schematic for the project
[![schematic](https://raw.github.com/sebastienjouhans/processing-arduino-cube-interface/master/fritzing-schematic/Sketch_bb.jpg)](#features)