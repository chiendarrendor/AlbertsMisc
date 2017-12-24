
public class BeginnerFactoryColor implements FactoryColorInterface
{
  WeightedRandom wr;

  public BeginnerFactoryColor()
  {
    wr = new WeightedRandom();
    wr.AddWeight(WoodPiece.RED,8);
    wr.AddWeight(WoodPiece.YELLOW,7);
    wr.AddWeight(WoodPiece.BLUE,6);
    wr.AddWeight(WoodPiece.MAGENTA,5);
  }



  public int getPieceColor()
  {
    return wr.getRandom();
  }
}
