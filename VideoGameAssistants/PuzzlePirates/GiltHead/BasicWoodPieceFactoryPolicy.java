

public class BasicWoodPieceFactoryPolicy implements WoodPieceFactoryPolicyInterface
{
  public WoodPiece GetNewWoodPiece()
  {
    // # of different pieces = 8 * 9 * 2 + 1 = 145 pieces
    int choice = MyRand.nextInt(145); // returns a number between 0 and 144;

    if (choice == 144) return WoodPieceFactory.GetCedarWoodPiece(false);

    boolean knotted;
    if (choice < 72)
    {
      knotted = true;
    }
    else
    {
      knotted = false;
      choice -= 72;
    }

    int color = choice % 8;
    int shape = choice / 8;

    return WoodPieceFactory.GetWoodPiece(shape,color,knotted);
  }

  public void ReturnWoodPiece(WoodPiece i_woodpiece)
  {
  }
}

