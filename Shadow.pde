/**
 * shadowSquare
 */
class Shadow extends Being
{ 
  boolean[] _dot_color;
  boolean _is_dot_visible;
  float _size;
  
  Shadow(HShape shape, boolean[] d_c, float size)
  {
    super(shape);
    _dot_color = new boolean[]{d_c[0],d_c[1],d_c[2]};
    _is_dot_visible = true;
    _size = size;
  }

  public void update()
  {
  }

  public void draw()
  {
    int max = gameLoop.getMax();
    int frame = gameLoop.getFrame()+1;
    int temp_size = floor(_size/2*sin((PI*max)/(2*frame)));
    int offset = floor(_size - temp_size)/2;
		noStroke();
    fill(generateColor(_dot_color));
    rect(offset,offset,temp_size,temp_size);
  }
}