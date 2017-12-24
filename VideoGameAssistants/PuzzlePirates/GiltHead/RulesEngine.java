import java.util.Vector;
import java.util.Queue;
import java.util.LinkedList;
import java.awt.Point;

// this class should contain all the information about
// the underlying algorithms of the game.  the visual
// elements should query, and occasionally modify,
// the state here through the methods

public class RulesEngine implements Runnable
{
  private int m_WeightPercent;
  private int m_ActualWeight;
  private int m_PieceCount;
  private WoodPiece m_TransferPiece;
  private BlueprintGrid m_blueprint;
  private BlueprintGrid m_matchspaces;
  private Vector<Double> m_BlueprintScores;
  private Vector<Integer> m_BlueprintGrades;
  private int m_MouseLevel;
  private long m_MouseChangeTime;
  private Vector<WoodPiece> m_WorkBench;
  private PieceLocation m_LastPieceLocation;
  private int m_BlueprintGoal;
  private Queue<ScoringDescriptor> m_descriptors;
  private boolean m_isScoring;
  private boolean m_isAccelerate;

  private WoodPieceFactoryPolicyInterface m_woodpiecefactory;
  private GameStartPolicyInterface m_gspi;
  private GameStartInfo m_gsi;
  private WeighingPolicyInterface m_weighingpolicy;
  private ScoringPolicyInterface m_scoringpolicy;
  private GameEndPolicyInterface m_gameendpolicy;
  private MousePolicyInterface m_mousepolicy;
  private MouseSpeedPolicyInterface m_mousespeed;
  private MatchSpaceGenerationPolicyInterface m_matchpolicy;
  private int m_SushiBoatVelocity;

  public enum PieceLocation { NO_LOCATION,SUSHIBOAT,WORKBENCH,BLUEPRINT };

  public RulesEngine(WoodPieceFactoryPolicyInterface i_wpfpi,
                     GameStartPolicyInterface i_gspi,
                     WeighingPolicyInterface i_weighingpolicy,
                     ScoringPolicyInterface i_scoringpolicy,
                     GameEndPolicyInterface i_gameendpolicy,
                     MousePolicyInterface i_mousepolicy,
                     MouseSpeedPolicyInterface i_mousespeed,
                     MatchSpaceGenerationPolicyInterface i_matchpolicy,
                     int i_BlueprintGoal,
                     int i_SushiBoatVelocity)
  {
    m_woodpiecefactory = i_wpfpi;
    m_gspi = i_gspi;
    m_weighingpolicy = i_weighingpolicy;
    m_scoringpolicy = i_scoringpolicy;
    m_gameendpolicy = i_gameendpolicy;
    m_mousepolicy = i_mousepolicy;
    m_mousespeed = i_mousespeed;
    m_matchpolicy = i_matchpolicy;
    m_BlueprintGoal = i_BlueprintGoal;
    m_SushiBoatVelocity = i_SushiBoatVelocity;

    m_WeightPercent = 0;
    m_ActualWeight = 0;
    m_PieceCount = 0;
    m_BlueprintScores = new Vector<Double>();
    m_BlueprintGrades = new Vector<Integer>();
    m_TransferPiece = null;
    m_blueprint = new BlueprintGrid();
    m_matchspaces = new BlueprintGrid();
    m_MouseLevel = 0;
    m_MouseChangeTime = 0;
    m_WorkBench = new Vector<WoodPiece>();
    m_WorkBench.setSize(GiltHeadConstants.WORK_BENCH_COUNT);
    m_LastPieceLocation = PieceLocation.NO_LOCATION;
    m_descriptors = new LinkedList<ScoringDescriptor>();
    m_isScoring = false;
    m_isAccelerate = false;

    m_gsi = m_gspi.GetGameStart();
    m_matchpolicy.MakeMatches(m_matchspaces,GetBlueprintSize());
  }

  synchronized public WoodPiece GetWorkBench(int i_idx)
  {
    return m_WorkBench.get(i_idx);
  }

  synchronized public void SetWorkBench(WoodPiece i_woodpiece,int i_idx)
  {
    if (i_woodpiece != null && m_LastPieceLocation != PieceLocation.WORKBENCH)
    {
      ResetMouseLevel();
    }

    m_WorkBench.set(i_idx,i_woodpiece);
  }

  synchronized public int GetSushiBarVelocity()
  {
    return m_SushiBoatVelocity;
  }

  synchronized public Vector<Integer> GetBlueprintCompletions()
  {
    return m_BlueprintGrades;
  }

  // returns the number of vertical cells in this
  // set of table legs.
  synchronized public int GetBlueprintSize()
  {
    return m_gsi.legHeight;
  }
  
  synchronized public int GetBlueprintGoal()
  {
    return m_BlueprintGoal;
  }

  synchronized public int GetTableTopWeight()
  {
    return m_gsi.weightClass;
  }

  synchronized public WeightProgress GetWeightProgress()
  {
    WeightProgress wp = new WeightProgress();
    int passweight = m_weighingpolicy.getPassWeight(GetTableTopWeight());
    double meanpassweight = passweight / 24.0;
    double meanrealweight;
    if (m_PieceCount != 0)
    {
      meanrealweight = (double)(m_ActualWeight/m_PieceCount);
    }
    else
    {
      meanrealweight = meanpassweight;
    }

    double low,high;

    if (meanrealweight < meanpassweight)
    {
      low = -10; // strength of fish
      high = meanpassweight;
      wp.m_band = WeightProgress.BOOCHING;
    }
    else
    {
      low = meanpassweight;
      high = 10; //strength of fish
      wp.m_band = WeightProgress.PASSING;
    }
    
    double range = high - low;
    wp.m_rating = (meanrealweight - low) / range;

    return wp;
  }


    



  synchronized public int GetMatchSpace(int i_column,int i_row)
  {
    WoodPiece wp = m_matchspaces.GetPiece(i_column,i_row);
    if (wp==null) return WoodPiece.NO_SHAPE;
    return wp.GetShape();
  }

  // returns contents of cell
  synchronized public WoodPiece GetBlueprintCell(int i_column,int i_row)
  {
    return m_blueprint.GetPiece(i_column,i_row);
  }

  // primary mechanism for filling blueprint cells
  // as long as the column is not full (size == m_BlueprintSize)
  // put it in the smallest indexed cell of that column and return true
  // otherwise, return false

  synchronized public boolean AddPieceToColumn(WoodPiece i_woodpiece,int i_column)
  {

    if (m_blueprint.GetColumnHeight(i_column) >= GetBlueprintSize()) 
    {
      return false;
    }

    // if we get here, we now have a new piece in the grid.
    m_blueprint.SetPieceInColumn(i_column,i_woodpiece);

    ResetMouseLevel();

    m_WeightPercent = m_weighingpolicy.getWeight(GetTableTopWeight(),m_blueprint);
    m_ActualWeight = m_weighingpolicy.getActualWeight(m_blueprint);
    m_PieceCount++;

    // lets see if we're full.
    int i,j;
    for (i = 0 ; i < GetBlueprintSize() ; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; j++)
      {
        if (m_blueprint.GetPiece(j,i) == null)
        {
          return true;
        }
      }
    }

    // if we get here, we're full.

    int parweight = m_weighingpolicy.getParWeight(GetTableTopWeight());
    int passweight = m_weighingpolicy.getPassWeight(GetTableTopWeight());
    int actualweight = m_weighingpolicy.getActualWeight(m_blueprint);

    Vector<ScoringDescriptor> vd = 
      m_scoringpolicy.score(m_blueprint,m_matchspaces,GetBlueprintSize(),actualweight,passweight,parweight);
    double score = vd.get(0).m_Score;

    m_BlueprintScores.add(new Double(score));
    m_BlueprintGrades.add(new Integer(m_gameendpolicy.getGrade(score)));

    // what do we do when we're done?
    m_isScoring = true;

    for (i = 0 ; i < vd.size() ; ++i)
    {
      m_descriptors.offer(vd.get(i));
    }


    if (m_BlueprintScores.size() == m_BlueprintGoal)
    {
      // altering the expected 'final' scoring descriptor from the game end policy
      // because we want to add one more.
      ScoringDescriptor sdscore = m_gameendpolicy.scoreEndGame(m_BlueprintScores);
      sdscore.m_isFinal = false;
      sdscore.m_pauseSeconds = 60;

      m_descriptors.offer(sdscore);
      ScoringDescriptor sdrestart = new ScoringDescriptor();

      sdrestart.m_Score = 0;
      sdrestart.m_String = "(Reload Page)";
      sdrestart.m_type = 0;
      sdrestart.m_address = 0;
      sdrestart.m_isFinal = true;
      sdrestart.m_pauseSeconds = 0; // doesn't matter...this one's permanent

      m_descriptors.offer(sdrestart);
    }    

    return true;
  }

  synchronized public void ResetBoard()
  {
    int i,j;

    if (m_BlueprintScores.size() == m_BlueprintGoal)
    {
      return;
    }

    m_isScoring = false;
    
    // empty grid.
    for (i = 0 ; i < GetBlueprintSize() ; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; j++)
      {
        ReturnWoodPiece(m_blueprint.GetPiece(j,i));
        m_blueprint.SetPiece(j,i,null);
      }
    }

    m_gsi = m_gspi.GetGameStart();
    m_matchpolicy.MakeMatches(m_matchspaces,GetBlueprintSize());
    m_WeightPercent = 0;
    m_ActualWeight = 0;
    m_PieceCount = 0;
  }

  synchronized public boolean IsPassingWeight()
  {
    int passweight = m_weighingpolicy.getPassWeight(GetTableTopWeight());
    int actualweight = m_weighingpolicy.getActualWeight(m_blueprint);
    return (actualweight >= passweight);
  }

  synchronized public boolean IsParWeight()
  {
    int actualweight = m_weighingpolicy.getActualWeight(m_blueprint);
    int parweight = m_weighingpolicy.getParWeight(GetTableTopWeight());
    return (actualweight >= parweight);
  }    



  synchronized public boolean IsScoring()
  {
    return m_isScoring;
  }

  synchronized public ScoringDescriptor GetScoringDescriptor()
  {
    return m_descriptors.poll();
  }

  // called by the SushiBoat code to get a new piece.
  synchronized public WoodPiece GetNewWoodPiece()
  {
    return m_woodpiecefactory.GetNewWoodPiece();
  }

  // called by the SushiBoat code when a piece leaves the screen.
  synchronized public void ReturnWoodPiece(WoodPiece i_woodpiece)
  {
    m_woodpiecefactory.ReturnWoodPiece(i_woodpiece);
  }

  // called by SushiBoat code to see if it is allowed to select a new piece
  synchronized public boolean CanSelectNewPiece()
  {
    return m_TransferPiece == null;
  }

  synchronized public WoodPiece GetTransferPiece()
  {
    return m_TransferPiece;
  }

  // called by code when a piece is picked up.
  synchronized public void PieceToTransfer(WoodPiece i_woodpiece,PieceLocation i_Location)
  {
    if (i_woodpiece != null)
    {
      m_LastPieceLocation = i_Location;
    }

    m_TransferPiece = i_woodpiece;
  }

  synchronized public void SetAccelerate(boolean i_accelerate)
  {
    m_isAccelerate = i_accelerate;
  }

  synchronized public boolean GetAccelerate()
  {
    return m_isAccelerate;
  }

  // called by the balance beam in order to determine
  // at what angle to draw the beam.
  synchronized public int GetWeightPercent()
  {
    return m_WeightPercent;
  }

  synchronized public int GetMouseLevel()
  {
    return m_MouseLevel;
  }

  synchronized public void ResetMouseLevel()
  {
    m_MouseLevel = 0;
    m_MouseChangeTime = System.currentTimeMillis() + m_mousespeed.getFirstMouseDelay();
  }

  private Point m_mousePoint = null;

  // x = column 0-3, y = row 0 (bottom) up
  synchronized public Point GetMousePoint()
  {
    return m_mousePoint;
  }    

  synchronized public void CheckIncrementMouseLevel()
  {
    // we leave mouse level at 3 long enough for the draw processes to hear it
    // one cycle should be enough...
    if (m_MouseLevel >= 3)
    {
      ResetMouseLevel();
      return;
    }

    if (System.currentTimeMillis() < m_MouseChangeTime) return;

    if (m_MouseLevel == 0)
    {
      m_MouseLevel = 1;
      m_MouseChangeTime = System.currentTimeMillis() + m_mousespeed.getSecondMouseDelay();
    }
    else if (m_MouseLevel == 1)
    {
      m_MouseLevel = 2;
      m_MouseChangeTime = System.currentTimeMillis() + m_mousespeed.getThirdMouseDelay();;
    }
    else 
    {
      m_MouseLevel = 3;
      m_mousePoint = m_mousepolicy.applyMouse(m_blueprint);
      m_WeightPercent = m_weighingpolicy.getWeight(GetTableTopWeight(),m_blueprint);
      m_ActualWeight = m_weighingpolicy.getActualWeight(m_blueprint);
    }
  }

  boolean m_IsPaused = false;
  long m_TimeToMouse;

  synchronized public void pause()
  {
    m_IsPaused = true;
    m_TimeToMouse = m_MouseChangeTime - System.currentTimeMillis();
  }

  synchronized public void unpause()
  {
    m_IsPaused = false;
  }

  synchronized private void retime()
  {
    m_MouseChangeTime = System.currentTimeMillis() + m_TimeToMouse;
  }

  synchronized private boolean IsPaused()
  {
    return m_IsPaused;
  }



  public void run()
  {
    ResetMouseLevel();
    
    while(true)
    {
      if (IsPaused())
      {
        retime();
      }
      else
      {
        if (IsScoring())
        {
          ResetMouseLevel();
        }
        else
        {
          CheckIncrementMouseLevel();
        }
      }
      try
      {
        Thread.sleep(GiltHeadConstants.MOUSE_CYCLE_TIME);
      }
      catch(InterruptedException ex)
      {
      }
    }
  }
}
