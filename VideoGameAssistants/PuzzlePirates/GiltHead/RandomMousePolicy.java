import java.util.Vector;

public class RandomMousePolicy extends GenericMousePolicy
{
  protected Vector<PieceLoc> GetChoicePieces(BlueprintGrid i_blueprint)
  {
    Vector<PieceLoc> pieces = new Vector<PieceLoc>();
    int i,j;

    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_MAX_HEIGHT ; ++j)
      {
        WoodPiece wp = i_blueprint.GetPiece(i,j);
        if (wp == null) continue;
        if (wp.GetColor() == WoodPiece.FISH_COLOR || wp.GetColor() == WoodPiece.CEDAR_COLOR) continue;
        if (wp.GetStrength() <= 0) continue;
        pieces.add(new PieceLoc(i,j));
      }
    }
    return pieces;
  }
}
