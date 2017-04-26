 int getAction(Organism ant)
  {
    final int idle = 0;
    final int walk = 1;
    final int turn_r = 2;
    final int turn_l = 3;

    if(isEmpty(ant.sight[0]))
      return walk;
    else
      return turn_r;
  }

  boolean isEmpty(boolean[] c_)
  {
    return (c_[0] == true && c_[1] == true && c_[2] == true);
  }