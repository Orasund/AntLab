int randomFromPool(float[] chances)
{
  //---------------------------
  //- INPUT CONDITION
  //---------------------------
  float sum = 0;
  for(int i = 0; i < chances.length; i++)
  {
    check(chances[i]>=0 && chances[i]<1);
    sum += chances[i];
  }
  check(sum<1);

  //---------------------------
  //- FUNCTION
  //---------------------------
  float r = random(1);
  int out = 0;
  float chance = 0;
  for(int i = 0; i < chances.length; i++)
  {
    chance += chances[i];

    if(r<chance)
    {
      out = i+1;
      break;
    }
  }

  //---------------------------
  //- OUTPUT CONDITION
  //---------------------------
  check(out>=0 && out <= chances.length);

  return out;
}