public void check(boolean argument)
{
  if(argument == false)
    throw new RuntimeException("CheckingError");
}