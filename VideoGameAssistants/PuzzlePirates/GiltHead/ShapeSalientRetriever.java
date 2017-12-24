public class ShapeSalientRetriever implements BonusScoring.SalientRetriever
{
  public int GetSalient(WoodPiece i_woodpiece)
  {
    return i_woodpiece.GetShape();
  }
}

