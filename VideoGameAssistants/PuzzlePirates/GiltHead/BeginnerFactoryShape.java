
public class BeginnerFactoryShape implements FactoryShapeInterface
{
  WeightedRandom wr;

  public BeginnerFactoryShape()
  {
    wr = new WeightedRandom();
    wr.AddWeight(WoodPiece.THIN_INNIE,2);
    wr.AddWeight(WoodPiece.THIN_STRAIGHT,2);
    wr.AddWeight(WoodPiece.THIN_OUTIE,2);
    wr.AddWeight(WoodPiece.MEDIUM_INNIE,3);
    wr.AddWeight(WoodPiece.MEDIUM_STRAIGHT,3);
    wr.AddWeight(WoodPiece.MEDIUM_OUTIE,3);
  }

  public int getPieceType() { return NORMAL_TYPE; }  
  public int getPieceShape()
  {
    return wr.getRandom();
  }
}
