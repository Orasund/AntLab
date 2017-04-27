color generateColor(boolean c[])
{
  color[][][] colors = 
  {
    {//RED = FALSE
      {//GREEN = FALSE
        color(0,0,0), //BLACK
        color(64, 48, 117) //BLUE
      },
      {
        color(45, 136, 45), //GREEN
        color(41, 79, 109) //GREEN-BLUE
      }
    },
    {
      {
        color(170, 57, 57), //RED
        color(111, 37, 111) //RED-BLUE
      },//GREEN = FALSE
      {
        color(170, 151, 57), //RED-GREEN
        color(255,255,255) //WHITE
      }
    }
  };

  return colors[int(c[0])][int(c[1])][int(c[2])];
}