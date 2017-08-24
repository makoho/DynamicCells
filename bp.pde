class bp
{
  float angle;
  float size;
  boolean done;

  public bp(float a, float s)
  {
    angle = a;
    size = s;
  }
  
  float calcX()
  {
    return cos(angle) * size;
  }
  
  float calcY()
  {
    return sin(angle) * size;
  }
}