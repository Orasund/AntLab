/**
 * Square
 * the Square is part of the gameboard
 */
class Square extends Being
{ 
  boolean _red;
  boolean _green;
  boolean _blue;
  
  Square(boolean[] c, HShape shape)
  {
    super(shape);
    _red = c[0];
    _green = c[1];
    _blue = c[2];
  }

  public void update() {
    // Add update method here
  }

  private color generateColor()
  {
    color[][][] colors = 
    {
      {//RED = FALSE
        {color(0,0,0),color(0,0,255)},//GREEN = FALSE
        {color(0,255,0),color(0,255,255)}
      },
      {
        {color(255,0,0),color(255,0,255)},//GREEN = FALSE
        {color(255,255,0),color(255,255,255)}
      }
    };

    return colors[int(_red)][int(_green)][int(_blue)];
  }

  public void draw()
  {
    fill(generateColor());
		noStroke();
		_shape.draw();
  }
}