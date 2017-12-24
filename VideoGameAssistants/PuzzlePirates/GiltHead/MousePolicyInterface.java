import java.awt.Point;


public interface MousePolicyInterface
{
  // x = column 0-3, y = row 0 (bottom) up
  public Point applyMouse(BlueprintGrid i_blueprint);
}
