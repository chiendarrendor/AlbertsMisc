import java.util.Vector;

public interface GameEndPolicyInterface
{
  public static final int BOOCHED = 0;
  public static final int POOR = 1;
  public static final int FINE = 2;
  public static final int GOOD = 3;
  public static final int EXCELLENT = 4;
  public static final int INCREDIBLE = 5;

  public ScoringDescriptor scoreEndGame(Vector<Double> i_boardscores);
  public int getGrade(double i_score);
}
