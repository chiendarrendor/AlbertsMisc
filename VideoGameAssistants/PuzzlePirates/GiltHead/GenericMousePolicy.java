import java.util.Vector;
import java.awt.Point;

public abstract class GenericMousePolicy implements MousePolicyInterface
{
  protected class PieceLoc
  {
    int col;
    int row;
    public PieceLoc(int i_col,int i_row)
    {
      col = i_col;
      row = i_row;
    }
  }

  protected abstract Vector<PieceLoc> GetChoicePieces(BlueprintGrid i_blueprint);

  public Point applyMouse(BlueprintGrid i_blueprint)
  {
    Vector<PieceLoc> choices = GetChoicePieces(i_blueprint);
    if (choices == null || choices.size() == 0) return null;
    PieceLoc thePieceLoc = choices.get(MyRand.nextInt(choices.size()));
    WoodPiece oldPiece = i_blueprint.GetPiece(thePieceLoc.col,thePieceLoc.row);
    WoodPiece newPiece = WoodPieceFactory.GetWoodPiece(oldPiece.GetShape(),oldPiece.GetColor(),true);

    i_blueprint.SetPiece(thePieceLoc.col,thePieceLoc.row,newPiece);

    Point p = new Point(thePieceLoc.col,thePieceLoc.row);
    return p;

  }
}

