class Cell
{
  float         whiteSpace = 4;
  float         darkSpace = whiteSpace*2;

  PVector       loc;
  ArrayList<bp> points = new ArrayList<bp>();
  float         size;
  float         growRate;
  int           pointCount = 100;
  color         borderColor;
  float         maxSize = 100;
  boolean       done = false;
  boolean       stillCircular = true;
  color         originalFill;
  color         fillColor;  
  boolean       interior = false;  

  ArrayList<Cell> neighbors = new ArrayList<Cell>();
  Cell parent;

  public Cell(float x, float y, float s, Cell parentCell)
  {
    loc = new PVector(x, y);
    growRate = random(0.7, 1.1);
    size = s;
    parent = parentCell;

    for (int i=0; i<pointCount; i++)
    {
      float a = map(i, 0, pointCount -1, 0, TWO_PI);
      points.add(new bp(a, size));
    }

    borderColor = color(102);//64,140,218);
    if (parentCell!=null)
    {
      originalFill = color(parentCell.originalFill, 200);//random(0, 255), random(0, 255), random(0, 255));
    } else
    {
      originalFill = colorManager.GetRandomColor();//color(random(0, 150), random(0, 150), random(0, 150));
    }

    fillColor = originalFill;
  }

  public void Grow()
  {
    if (done)
      return;

    if (size > (maxSize*2))
      done = true;

    boolean stillGrowing = false;

    size += growRate;
    for (bp p : points)
    { 
      if (!p.done)
      {
        stillGrowing = true;
        float newX = loc.x + cos(p.angle) * size;
        float newY = loc.y + sin(p.angle) * size;

        if (validPoint(p, newX, newY))
        {
          p.size = size;
          stillGrowing = true;
        } else
        {
          p.done = true;
        }
      }
    }

    if (!stillGrowing) 
    {
      size -= growRate;
      done = true;
    }
  }

  float proximityRestriction = 3.5;

  public PVector CalcMiddle()
  {
    float sX = 0;
    float sY = 0;

    for (bp p : points)
    {
      sX += p.calcX();
      sY += p.calcY();
    }

    return new PVector(loc.x + sX / points.size(), loc.y + sY / points.size());
  }

  public boolean validPoint(bp p, float x, float y)
  {   
    if (x < 0) return false;
    if (y < 0) return false;
    if (x > width + 8) return false;
    if (y > height + 8) return false;

    if (parent == null)
    {
      for (Cell c : cells)
      {        
        if (c.parent!=null)        
          return true;

        if (c.loc.x == loc.x && c.loc.y == loc.y)
        {
          boolean TooFar = true;
          int bpIndex = points.indexOf(p);
          bp pointAbove;
          bp pointBelow;

          if (bpIndex > 0) 
            pointAbove = points.get(bpIndex-1);
          else
            pointAbove = points.get(points.size()-1);

          if (bpIndex <(points.size()-1))
            pointBelow = points.get(bpIndex + 1);
          else
            pointBelow = points.get(0);

          if (dist(x, y, loc.x + pointBelow.calcX(), loc.y + pointBelow.calcY()) > proximityRestriction) return false;
          if (dist(x, y, loc.x + pointAbove.calcX(), loc.y + pointAbove.calcY()) > proximityRestriction) return false;
        } else
        {
          if (c.parent==null)
          {
            float minDist = whiteSpace;
            if (interior) minDist = darkSpace;

            if (c.TooClose(x, y, minDist))
            {
              if (!neighbors.contains(c)) neighbors.add(c);
              return false;
            }
          } else
            return true;
        }
      }
    } else
    {
      boolean TooFar = true;
      int bpIndex = points.indexOf(p);
      bp pointAbove;
      bp pointBelow;

      if (bpIndex > 0) 
        pointAbove = points.get(bpIndex-1);
      else
        pointAbove = points.get(points.size()-1);

      if (bpIndex <(points.size()-1))
        pointBelow = points.get(bpIndex + 1);
      else
        pointBelow = points.get(0);

      if (dist(x, y, loc.x + pointBelow.calcX(), loc.y + pointBelow.calcY()) > proximityRestriction) return false;
      if (dist(x, y, loc.x + pointAbove.calcX(), loc.y + pointAbove.calcY()) > proximityRestriction) return false;

      float minDist = whiteSpace;
      if (interior) minDist = darkSpace;

      if (parent.TooClose(x, y, minDist))
      {
        return false;
      }

      return true;
    }
    return true;
  }

  public boolean TooClose(float x, float y, float minDist)
  {
    if (dist(x, y, loc.x, loc.y) > (size + 12)) return false;

    for (bp p : points)
    {
      if (dist(x, y, loc.x+p.calcX(), loc.y + p.calcY()) < minDist)
        return true;
    }

    return false;
  }


  public void Display()
  {
    stroke(borderColor);
    fill(fillColor);    
    strokeWeight(2);

    float lastX = 0;
    float lastY = 0;

    beginShape();    
    for (bp p : points)
    {
      float x = loc.x + cos(p.angle) * p.size;
      float y = loc.y + sin(p.angle) * p.size;

      if ((int)x != (int)lastX || (int)y != (int)lastY) vertex(x, y);
      lastX = x;
      lastY = y;
    }
    endShape(CLOSE);
  }
}