import java.util.Vector;
import java.util.HashMap;


public class HeaviestMousePolicy extends GenericMousePolicy
{
  protected Vector<PieceLoc> GetChoicePieces(BlueprintGrid i_blueprint)
  {
    HashMap<Integer,Vector<PieceLoc> > pieces = new HashMap<Integer,Vector<PieceLoc> >();
    int i,j;

    // organize pieces by strength
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_MAX_HEIGHT ; ++j)
      {
        WoodPiece wp = i_blueprint.GetPiece(i,j);
        if (wp == null) continue;
        if (wp.GetColor() == WoodPiece.FISH_COLOR || wp.GetColor() == WoodPiece.CEDAR_COLOR) continue;
        int st = wp.GetStrength();
        if (st <= 0) continue;
        Integer key = new Integer(st);

        if (!pieces.containsKey(key))
        {
          pieces.put(key,new Vector<PieceLoc>());
        }

        pieces.get(key).add(new PieceLoc(i,j));
      }
    }

    if (pieces.size() == 0) return null;
    for (i = 7 ; i >= 1 ; --i)
    {
      Integer key = new Integer(i);
      if (pieces.containsKey(key))
      {
        return pieces.get(key);
      }
    }

    return null;
  }
}
