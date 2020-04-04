import myUtilities.*;
import paletteManager.*;
import processing.svg.*;

ArrayList<Cell> cells = new ArrayList<Cell>();
String          folder;
int             margin = 0;
int             cellCount = 150;
boolean         stillGrowing = false;
int             baseColor;
ArrayList<Cell> newCells = new ArrayList<Cell>();
Manager         colorManager;
boolean         saveNow = false;
DateUtils       du;
String          filename;
float           drawD = 5.5;

void setup()
{
  size(1200, 1000);
  SetFolderName();
  colorMode(HSB);
  du = new DateUtils(this);
  colorManager = new Manager(this);
  colorManager.loadPalette("Earth");

  baseColor = floor(random(0, 255));
  createCells();
  background(255);
}

void keyPressed()
{
  saveNow = true;
}

void draw()
{
  if (saveNow)
  { 
    filename = du.timeStamp();   
    beginRecord(SVG, filename + ".svg");
  }

  background(255);
  for (Cell c : cells)
  {
    c.Grow();
    c.Display();
  }

  for (Cell c : newCells)
  {
    cells.add(c);
  }
  newCells.clear();

  if (saveNow)
  {
    endRecord();
    save(filename + ".png");
    println("Saved sketch to ", filename);  
    saveNow = false;
    exit();
  }
}

void createCells()
{
  createCellArea(15, 20, 100, 8, 10, .9, 1.2, 250, colorManager.getColor(2));
  createCellArea(40, 100, 200, 8, 10, .9, 1.2, 250, colorManager.getColor(2)); 
  createCellArea(120, 180, 225, 8, 10, .9, 1.2, 10, colorManager.getColor(4));   
  createCellArea(170, 220, 255, 4, 7, .9, 1.2, 5, colorManager.getColor(3));
  createCellArea(350, 260, 380, 10, 20, 1, 1.3, 200, colorManager.getColor(7));
  createCellArea(500, 400, 440, 20,  30, 1, 1.3, 200, color(255));
  
  println("done creating cells");
}

void createCellArea(int amount, float innerLine, float outerLine, float iniSizeMin, float iniSizeMax, float growMin, float growMax, float maxSize, color borderColor)
{
  int tries;

  for (int i=0; i< amount; i++)
  {
    println("creating cell", i+1);
    float a = random(0, TAU);
    float r = random(innerLine, outerLine);
    float x = width/2 + cos(a) * r;
    float y = height/2 + sin(a) * r;
    float s = random(iniSizeMin, iniSizeMax);
    tries = 0;

    while (isTaken(x, y, s) && tries < 20)
    {
      a = random(0, TAU);
      r = random(innerLine, outerLine);
      x = width/2 + cos(a) * r;
      y = height/2 + sin(a) * r;
      tries++;
    }

    if (tries <19)
    {
      Cell c = new Cell(x, y, s, null, maxSize);
      c.borderColor = borderColor;
      c.growRate = random(growMin, growMax);
      cells.add(c);
    }
  }
}

boolean isTaken(float x, float y, float s)
{
  for (Cell c : cells)
  {
    float d = dist(c.loc.x, c.loc.y, x, y);
    if (d <= (c.size + s + 3)) return true;
  }

  return false;
}

void CreateCells1()
{
  println("Initializing cells");
  float B;
  float s;
  float cx;
  float cy;
  boolean useOffset = false;


  int step = 24;
  int yOffset = floor(step/2);
  float rando = step / 5;

  for (int x=5; x<width + step; x+=step)
  {
    if (useOffset) 
    {  
      yOffset = floor(random(10, 17));
    } else { 
      yOffset = 0;
    }

    useOffset = !useOffset;

    for (int y=yOffset; y<height + step; y+=step)
    {     
      cx = x + random(-rando, rando);
      cy = y + random(-rando, rando);

      s = 2;//random(1, 3);
      B = random(-20, 20) + map(dist(cx, cy, width/2, height/2), 0, height*2/3, 255, 0);

      Cell c = new Cell(cx, cy, s, null, 150);    
      float colorS = random(20, 240);
      c.growRate = random(0.9, 1.1);

      if (B<=0)
      {
        c.borderColor = color(baseColor, colorS, 15);
      } else
      {
        c.borderColor = color(baseColor, colorS, B);
      }

      c.fillColor = color(baseColor, colorS, B);

      cells.add(c);
    }
  } 
  println("Initializing done");
}

boolean Overlap(float x, float y, float s)
{
  for (Cell c : cells)
  {
    float reqDist = s + c.size + 6;
    float actDist = dist(c.loc.x, c.loc.y, x, y);
    if (actDist <= reqDist) return true;
  }
  return false;
}

void SetFolderName()
{
  folder = nf(year(), 4) + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "  " + nf(hour(), 2) + "." + nf(minute(), 2) + "\\";
}
