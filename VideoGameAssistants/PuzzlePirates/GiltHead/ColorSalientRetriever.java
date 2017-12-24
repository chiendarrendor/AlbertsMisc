public class ColorSalientRetriever implements BonusScoring.SalientRetriever
{
  public int GetSalient(WoodPiece i_woodpiece)
  {
    return i_woodpiece.GetColor();
  }
}
