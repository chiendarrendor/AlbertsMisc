

class GenericWoodPieceFactoryPolicy implements WoodPieceFactoryPolicyInterface
{
  FactoryColorInterface m_fci;
  FactoryShapeInterface m_fsi;

  public GenericWoodPieceFactoryPolicy(FactoryColorInterface i_fci,
                                       FactoryShapeInterface i_fsi)
  {
    m_fci = i_fci;
    m_fsi = i_fsi;
  }

  public WoodPiece GetNewWoodPiece()
  {
    int pieceType = m_fsi.getPieceType(); 
    
    if (pieceType == FactoryShapeInterface.CEDAR_TYPE)
    {
      return WoodPieceFactory.GetCedarWoodPiece(false);
    }

    if (pieceType == FactoryShapeInterface.FISH_TYPE)
    {
      return WoodPieceFactory.GetFishWoodPiece(false);
    }


    boolean knotted = (pieceType == FactoryShapeInterface.KNOT_TYPE);
    int shape = m_fsi.getPieceShape();
    int color = m_fci.getPieceColor();

    return WoodPieceFactory.GetWoodPiece(shape,color,knotted);
  }

  public void ReturnWoodPiece(WoodPiece i_woodpiece)
  {
  }

}
