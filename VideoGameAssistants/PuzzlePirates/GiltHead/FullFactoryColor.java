
public class FullFactoryColor implements FactoryColorInterface
{
  WeightedRandom wr;

  public FullFactoryColor()
  {
    wr = new WeightedRandom();
    wr.AddWeight(WoodPiece.RED,8);
    wr.AddWeight(WoodPiece.ORANGE,8);
    wr.AddWeight(WoodPiece.YELLOW,7);
    wr.AddWeight(WoodPiece.GREEN,7);
    wr.AddWeight(WoodPiece.CYAN,6);
    wr.AddWeight(WoodPiece.BLUE,6);
    wr.AddWeight(WoodPiece.PURPLE,5);
    wr.AddWeight(WoodPiece.MAGENTA,5);
  }



  public int getPieceColor()
  {
    return wr.getRandom();
  }
}
