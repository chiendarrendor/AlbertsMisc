
public class NoOpMatchSpaceGenerationPolicy implements MatchSpaceGenerationPolicyInterface
{
  public void MakeMatches(BlueprintGrid i_grid,int i_height)
  {
    i_grid.ClearGrid();
  }
}
