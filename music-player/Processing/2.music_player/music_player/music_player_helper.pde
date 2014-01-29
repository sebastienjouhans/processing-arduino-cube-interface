public class Rotations
{
  public Rotations(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public float x;
  public float y;
  public float z;
}


static final float TO_DEGREE = 180 / PI;


float radianToDegree(float radian)
{
   return radian * TO_DEGREE;
}


Rotations getSensorRotation(float[] q)
{
    float y_rad = atan2(2*(q[3] * q[2] + q[0] * q[3]), q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3]);
    float x_rad = atan2(2*(q[2] * q[3] + q[0] * q[1]), q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3]);
    float z_rad = asin(2*(q[1] * q[3] - q[0] * q[2]));
    
    float x_degree = radianToDegree(-x_rad);
    float y_degree = radianToDegree(y_rad+0.77190705);
    float z_degree = radianToDegree(z_rad);
    
    return new Rotations(x_degree, y_degree, z_degree);
}
