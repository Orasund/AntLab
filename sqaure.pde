/**
 * Square
 * the Square is part of the gameboard
 */
class Square extends Being
{ 
  boolean[] _background_color;
  boolean[] _dot_color;
  boolean _is_dot_visible;
  float _size;
  
  Square(HShape shape, boolean[] b_c, boolean[] d_c, float size)
  {
    super(shape);
    _background_color = new boolean[]{b_c[0],b_c[1],b_c[2]};
    _dot_color = new boolean[]{d_c[0],d_c[1],d_c[2]};
    _is_dot_visible = true;
    _size = size;
  }

  public void update() {
    // Add update method here
  }

  private color generateColor(boolean c[])
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

    return colors[int(c[0])][int(c[1])][int(c[2])];
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_background_color));
		_shape.draw();
    fill(generateColor(_dot_color));
    rect(_size/4,_size/4,_size/2,_size/2);
  }
}