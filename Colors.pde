class Colors
{  
  int ColorScheme = 1;

  public Colors()
  {
  }

  public PImage baseImage = null;

  public void SetImage(PImage image)
  {
    baseImage = image;
    baseImage.loadPixels();
  }

  public Colors(int colorScheme)
  {
    ColorScheme = colorScheme;
  }

  public int GetColorFromImage(float x, float y)
  {
    int x1 = (int)map(x, 0, width, 0, baseImage.width);
    int y1 = (int)map(y, 0, height, 0, baseImage.height);
    
    return baseImage.pixels[x1 + y1 * baseImage.width];
  }

  public int GetColor(int colorIndex)
  {
    if (ColorScheme==0) return GetBrownColor(colorIndex);
    if (ColorScheme==1) return GetGreenColor(colorIndex);

    if (baseImage == null)
    {
      if (random(0, 10) < 5)
        return GetGreenColor(colorIndex);
      else
        return GetBrownColor(colorIndex);
    }
    
    return 0;
  }

  public int GetBrownColor(int colorIndex)
  {
    switch(colorIndex)
    {
    case 0:
      {
        return color(167, 116, 74);
      }
    case 1:
      {
        return color(200, 187, 105);
      }
    case 2:
      {
        return color(74, 64, 62);
      }
    case 3:
      {
        return color(163, 132, 64);
      }
    case 4:
      {
        return color(201, 203, 174);
      }
    default:
      return color(201, 203, 174);
    }
  }

  public int GetGreenColor(int colorIndex)
  {
    switch(colorIndex)
    {
    case 0:
      {
        return color(3, 166, 14);
      }
    case 1:
      {
        return color(5, 89, 2);
      }
    case 2:
      {
        return color(2, 38, 1);
      }
    case 3:
      {
        return color(61, 166, 31);
      }
    case 4:
      {
        return color(191, 191, 189);
      }
    default:
      return color(191, 191, 189);
    }
  }

  public int GetRandomColor()
  {
    int randomColorIndex = (int)random(0, 5);
    return GetColor(randomColorIndex);
  }
}