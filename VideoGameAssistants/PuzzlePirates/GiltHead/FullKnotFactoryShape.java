
public class FullKnotFactoryShape implements FactoryShapeInterface
{
  WeightedRandom wr;
  WeightedRandom twr;

  public FullKnotFactoryShape()
  {
    wr = new WeightedRandom();
    wr.AddWeight(WoodPiece.THIN_INNIE,2);
    wr.AddWeight(WoodPiece.THIN_STRAIGHT,2);
    wr.AddWeight(WoodPiece.THIN_OUTIE,2);
    wr.AddWeight(WoodPiece.MEDIUM_INNIE,3);
    wr.AddWeight(WoodPiece.MEDIUM_STRAIGHT,3);
    wr.AddWeight(WoodPiece.MEDIUM_OUTIE,3);
    wr.AddWeight(WoodPiece.THICK_INNIE,1);
    wr.AddWeight(WoodPiece.THICK_STRAIGHT,1);
    wr.AddWeight(WoodPiece.THICK_OUTIE,1);

    twr = new WeightedRandom();
    twr.AddWeight(KNOT_TYPE,14); // 7
    twr.AddWeight(NORMAL_TYPE,186); // 87
  }

  public int getPieceType()
  { 
    return twr.getRandom(); 
  }  

  public int getPieceShape()
  {
    return wr.getRandom();
  }
}
