/**
 * Ant
 */
class Ant extends Being
{ 
  private boolean[] _c; //Color
  private float _size;
  private int _d;       //Direction
  private int _x;
  private int _y;
  
  Ant(HShape shape, boolean[] b_c, float size, int x, int y)
  {
    super(shape);
    _c = new boolean[]{b_c[0],b_c[1],b_c[2]};
    _size = size;
    _d = floor(random(4));
    _x = x;
    _y = y;
  }

  public void update() {
  }

  public int[] getCoords()
  {
    int[] out = {_x,_y};
    return out;
  }

  public int getDirection()
  {
    return _d;
  }

  public boolean[] getColor()
  {
    boolean[] out = {_c[0],_c[1],_c[2]};
    return out;
  }

  public void walk(int cols, int rows)
  {
    int[] offset = calcOffset(cols,rows);
    PVector coords = getPosition();
    int[] dir = getDir(_d);
    float temp_x = (_x+dir[0]+cols)%cols;
    float temp_y = (_y+dir[1]+rows)%rows;
    setPosition(offset[0]+_size*temp_x,offset[0]+_size*temp_y);
  }

  public void turnLeft()
  {
    _d = (_d+1)%4;
  }

  public void draw()
  {
		noStroke();
    fill(generateColor(_c));
		_shape.draw();

    int[] dir = getDir(_d);
    int temp_size = floor(_size/4);
    int offset = floor(_size-temp_size)/2;
    int temp_x = temp_size*dir[0]*1;
    int temp_y = temp_size*dir[1]*1;
    fill(255);
    rect(offset+temp_x,offset+temp_y,temp_size,temp_size);
  }
}