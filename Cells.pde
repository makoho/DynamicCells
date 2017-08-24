ArrayList<Cell> cells = new ArrayList<Cell>();
String          folder;
Colors          colorManager = new Colors();
int             margin = 0;
int             cellCount = 150;
boolean         stillGrowing = false;
int             baseColor;
ArrayList<Cell> newCells = new ArrayList<Cell>();

void setup()
{
  size(1200, 1000);
  SetFolderName();
  colorMode(HSB);
  colorManager.ColorScheme = 1;
  
  baseColor = floor(random(0, 255));
  CreateCells();
  background(255);
}

void mouseClicked()
{
  Cell c = new Cell(mouseX, mouseY, 2, null);
  c.fillColor = color(200, 50, 50);
  newCells.add(c);
}

void keyPressed()
{
  saveFrame(folder + "###.png");
}

void draw()
{
  println("Drawing frame "+ frameCount + " with " + cells.size() + " cells.");
  background(0);
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
}


void CreateCells()
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

      Cell c = new Cell(cx, cy, s, null);    
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