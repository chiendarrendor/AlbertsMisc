
public class BasicWeighingPolicy implements WeighingPolicyInterface
{
  public int getParWeight(int i_weightClass)
  {
    int goalWeight;
    switch(i_weightClass)
    {
    case 1: goalWeight = 72; break;
    case 2: goalWeight = 96; break;
    case 3: 
    default:
      goalWeight = 120; break;
    }
    return goalWeight;
  }

  public int getPassWeight(int i_weightClass)
  {
    return 2 * 24;
  }

  public int getActualWeight(BlueprintGrid i_blueprint)
  {
    int i,j;
    int sumWeight = 0;


    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_MAX_HEIGHT ; ++j)
      {
        WoodPiece wp = i_blueprint.GetPiece(i,j);
        if (wp == null) continue;

        sumWeight += wp.GetStrength();
      }
    }

    return sumWeight;
  }



  public int getWeight(int i_weightClass,BlueprintGrid i_blueprint)
  {

    int goalWeight = getPassWeight(i_weightClass);
    int sumWeight = getActualWeight(i_blueprint);

    int result = 50 * sumWeight / goalWeight;
    if (result > 100) result = 100;
    if (result < 0) result = 0;

    return result;
  }
}
