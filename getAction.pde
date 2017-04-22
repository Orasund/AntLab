 int getAction(Organism ant)
  {
    final int idle = 0;
    final int walk = 1;
    final int turn_r = 2;
    final int turn_l = 3;

    if(isWall(ant.sight[0])==false)
      return walk;
    else
      return turn_r;
  }

  boolean isWall(boolean[] c_)
  {
    return (c_[0] == false && c_[1] == false && c_[2] == false);
  }