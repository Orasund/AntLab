void render(Cell[][] buffergrid)
{
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
    {
      buffergrid[i][j].display(i,j,S);
    }
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
    {
      grid[i][j].display(i,j,S/2);
    }
}