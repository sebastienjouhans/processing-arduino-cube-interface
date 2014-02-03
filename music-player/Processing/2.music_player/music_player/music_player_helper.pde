
static final float TO_DEGREE = 180 / PI;


float radianToDegree(float radian)
{
   return radian * TO_DEGREE;
}


void getSensorRotation(float[] q)
{
    float y_rad = atan2(2*(q[3] * q[2] + q[0] * q[3]), q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3]);
    float x_rad = atan2(2*(q[2] * q[3] + q[0] * q[1]), q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3]);
    float z_rad = asin(2*(q[1] * q[3] - q[0] * q[2]));
    
    x_degree = radianToDegree(-x_rad);
    z_degree = radianToDegree(y_rad+0.77190705);
    y_degree = radianToDegree(z_rad);
}
