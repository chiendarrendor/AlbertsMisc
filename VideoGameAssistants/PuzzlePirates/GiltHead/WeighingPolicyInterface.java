
interface WeighingPolicyInterface
{
  // returns a number between 0 and 100 where 50 is where actual weight = pass weight
  public int getWeight(int i_weightClass,BlueprintGrid i_blueprint);
  // returns the minimum weight required to start accruing weight bonuses
  public int getParWeight(int i_weightClass);
  // returns the minimum weight required to not booch
  public int getPassWeight(int i_weightClass);
  // returns the actual weight of the pieces on the board
  public int getActualWeight(BlueprintGrid i_blueprint);
}
