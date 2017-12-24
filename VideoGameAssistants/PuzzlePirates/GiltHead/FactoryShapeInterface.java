
interface FactoryShapeInterface
{
  public static final int CEDAR_TYPE = 0;
  public static final int KNOT_TYPE = 1;
  public static final int NORMAL_TYPE = 2;
  public static final int FISH_TYPE = 3;

  public int getPieceType();  // returns one of the three above types
  public int getPieceShape(); // returns one of the non-cedar WoodPiece shapes
}
