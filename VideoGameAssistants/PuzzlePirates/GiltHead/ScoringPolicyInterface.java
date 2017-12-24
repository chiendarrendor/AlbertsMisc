import java.util.Vector;


public interface ScoringPolicyInterface
{
  public Vector<ScoringDescriptor> score(BlueprintGrid i_blueprint,
                                         BlueprintGrid i_matchspaces,
                                         int i_ActualHeight,
                                         int i_ActualWeight,
                                         int i_PassWeight,
                                         int i_ParWeight);
}
