import java.util.Vector;

class NoOpMousePolicy extends GenericMousePolicy
{
  protected Vector<PieceLoc> GetChoicePieces(BlueprintGrid i_blueprint)
  {
    return null;
  }
}
