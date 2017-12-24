
public class BasicMatchSpaceGenerationPolicy implements MatchSpaceGenerationPolicyInterface
{
  WeightedRandom m_wr;
  
  public BasicMatchSpaceGenerationPolicy()
  {
    m_wr = new WeightedRandom();
    m_wr.AddWeight(0,50);
    m_wr.AddWeight(1,30);
    m_wr.AddWeight(2,15);
    m_wr.AddWeight(3,5);
  }


  public void MakeMatches(BlueprintGrid i_grid,int i_height)
  {
    i_grid.ClearGrid();

    int numMatches = m_wr.getRandom();
    if (numMatches > i_height-1)
    {
      numMatches = i_height-1;
    }

    if (numMatches == 0) return;
    int missing = i_height - 1 - MyRand.nextInt(numMatches+1);

    int i;
    for (i = i_height - 1 ; i >= i_height - 1 - numMatches ; --i)
    {
      if (i == missing) continue;
      int col = MyRand.nextInt(4);
      int shape = MyRand.nextInt(10);
      i_grid.SetPiece(col,i,new WoodPiece(0,shape,0,false,null));
    }      
  }
}
