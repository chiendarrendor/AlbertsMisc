import java.util.Vector;
import java.util.HashSet;
import java.awt.Point;

public class BasicScoringPolicy implements ScoringPolicyInterface
{
  static private final String[] legWords = {"Chic!","Jaunty!","Posh!","Swanky!"};
  static private final String[] rowWords = {"Fancy!","Ornate!","Chippendale!",
                                            "Victorian!","Baroque!","Rococo!" };

  static private final double FULLLEG = 6.0;
  static private final double HALFLEG = 3.0;
  static private final double FULLROW = 4.0;
  static private final double HALFROW = 2.0;
  static private final double DOUBLEROW = 8.0;
  static private final double DADA = 48.0 * 48.0;
  static private final double SURREAL = 48.0 * 48.0;
  static private final double ONECOLOR = 24.0;
  static private final double ONESHAPE = 24.0;

  static private final double PERFECTTAPER = 24.0;
  static private final double SIMPLETAPER = 12.0;
  static private final double SIMPLEBICURVE = 12.0;
  static private final double PERFECTBICURVE = 24.0;
  static private final double THREECOLOR = 6.0;
  static private final double THREESHAPE = 6.0;
  static private final double SIMPLERAINBOW = 6.0;
  static private final double RAINBOWFLAG = 48.0;
  static private final double ROYALRAINBOW = 64.0;

  public BasicScoringPolicy()
  {
  }

  static public ScoringDescriptor makeScore(String i_String,int i_type,int i_address)
  {
    ScoringDescriptor sd = new ScoringDescriptor();
    sd.m_Score = 0;
    sd.m_String = i_String;
    sd.m_type = i_type;
    sd.m_address = i_address;
    sd.m_isFinal = false;
    sd.m_pauseSeconds = 1;
    return sd;
  }

  private double GetLegBonus(BlueprintGrid i_blueprint,int i_column,int i_ActualHeight)
  {
    //   all one color = full bonus for the leg
    //   all two colors with the same pattern (RED/ORANGE,YELLOW/GREEN,
    //   CYAN/BLUE,MAGENTA/PURPLE) = half bonus for leg
    //   cedar matches any color (6 cedar is a full match)
    // returns percentage
    // half match is 3 %, full match is 6 %
    HashSet<Integer> colors = new HashSet<Integer>();
    
    int i;
    for (i = 0 ; i < i_ActualHeight ; ++i)
    {
      int color = i_blueprint.GetPiece(i_column,i).GetColor();
      if (color == WoodPiece.CEDAR_COLOR) continue;
      // fish causes instant match fail
      if (color == WoodPiece.FISH_COLOR) return 0.0;

      colors.add(new Integer(color));
    }

    if (colors.size() <= 1) return FULLLEG;
    if (colors.size() > 2) return 0.0;

    // only way to get here is we have exactly two colors.
    // we might have a half-match leg if the colors match.
    if ((colors.contains(new Integer(WoodPiece.RED)) && colors.contains(new Integer(WoodPiece.ORANGE))) ||
        (colors.contains(new Integer(WoodPiece.YELLOW)) && colors.contains(new Integer(WoodPiece.GREEN))) ||
        (colors.contains(new Integer(WoodPiece.CYAN)) && colors.contains(new Integer(WoodPiece.BLUE))) ||
        (colors.contains(new Integer(WoodPiece.PURPLE)) && colors.contains(new Integer(WoodPiece.MAGENTA))))
    {
      return HALFLEG;
    }

    return 0.0;
  }

  private double GetRowBonus(BlueprintGrid i_blueprint,BlueprintGrid i_matchspaces,int i_row)
  {
    //   all the same shape = bonus per row
    //   cedar matches any shape (4 cedar is a full match)
    // returns percentage 4%
    HashSet<Integer> shapes = new HashSet<Integer>();
    HashSet<Integer> curves = new HashSet<Integer>(); // 0 = innie, 1 = straight, 2 = outie
    
    int i;
    boolean fishfail = false;
    boolean matched = false;

    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      int shape = i_blueprint.GetPiece(i,i_row).GetShape();
      if (shape == WoodPiece.CEDAR_SHAPE) continue;
      if (shape == WoodPiece.FISH_SHAPE) 
      {
        fishfail = true;
        continue;
      }

      WoodPiece matchpiece = i_matchspaces.GetPiece(i,i_row);
      if (matchpiece != null && matchpiece.GetShape() == shape) matched = true;

      shapes.add(new Integer(shape));
      if (shape == WoodPiece.THIN_INNIE || 
          shape == WoodPiece.MEDIUM_INNIE || 
          shape == WoodPiece.THICK_INNIE) curves.add(new Integer(0));
      if (shape == WoodPiece.THIN_STRAIGHT || 
          shape == WoodPiece.MEDIUM_STRAIGHT || 
          shape == WoodPiece.THICK_STRAIGHT) curves.add(new Integer(1));
      if (shape == WoodPiece.THIN_OUTIE || 
          shape == WoodPiece.MEDIUM_OUTIE || 
          shape == WoodPiece.THICK_OUTIE) curves.add(new Integer(2));
    }

    if (fishfail) return 0.0;
    if (shapes.size() <= 1) return matched ? DOUBLEROW : FULLROW;
    if (shapes.size() > 3) return 0.0;
    if (curves.size() == 1) return matched ? FULLROW : HALFROW;
    return 0.0;
  }

  private double GetDadaBonus(BlueprintGrid i_blueprint,int i_ActualHeight,
                              Vector<ScoringDescriptor> i_sdescriptor)
  {
    // no matching shapes in any row (and no cedar)
    // no matching colors in any column (and no cedar)

    int i,j;
    HashSet<Integer> scounter;
    HashSet<Integer> ccounter;
    boolean fail = false;

    // for each column
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      // make sure that there are as many non-cedar colored pieces as spaces
      scounter = new HashSet<Integer>();
      ccounter = new HashSet<Integer>();
      for (j = 0 ; j < i_ActualHeight ; ++j)
      {
        int color = i_blueprint.GetPiece(i,j).GetColor();
        int shape = i_blueprint.GetPiece(i,j).GetShape();

        if (color == WoodPiece.CEDAR_COLOR || color == WoodPiece.FISH_COLOR) 
        {
          fail = true;
          continue;
        }
        ccounter.add(new Integer(color));
        scounter.add(new Integer(shape));
      }
      
      if (scounter.size() != i_ActualHeight) fail = true;
      if (ccounter.size() != i_ActualHeight) fail = true;
    }

    // for each row
    for (i = 0 ; i < i_ActualHeight ; ++i)
    {
      // make sure that there are as many non-cedar shaped pieces as columns
      scounter = new HashSet<Integer>();
      ccounter = new HashSet<Integer>();
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++j)
      {
        int shape = i_blueprint.GetPiece(j,i).GetShape();
        int color = i_blueprint.GetPiece(j,i).GetColor();
        if (shape == WoodPiece.CEDAR_SHAPE || shape == WoodPiece.FISH_SHAPE) 
        {
          fail = true;
          continue;
        }
        ccounter.add(new Integer(color));
        scounter.add(new Integer(shape));
      }

      if (scounter.size() != GiltHeadConstants.BLUEPRINT_NUM_COLUMNS) fail = true;
      if (ccounter.size() != GiltHeadConstants.BLUEPRINT_NUM_COLUMNS) fail = true;
    }

    if (fail == true) return 0.0;

    i_sdescriptor.add(makeScore("DaDa!!!!",0,0));
    return DADA;
  }

  private double GetSurrealBonus(BlueprintGrid i_blueprint,int i_ActualHeight,
                                  Vector<ScoringDescriptor> i_sdescriptor)
  {
    int i,j;
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < i_ActualHeight ; ++j)
      {
        if (i_blueprint.GetPiece(i,j).GetColor() != WoodPiece.FISH_COLOR) return 0.0;
      }
    }

    i_sdescriptor.add(makeScore("Surreal!!!!",0,0));
    return SURREAL;
  }
        
  private double GetOneColorBonus(BlueprintGrid i_blueprint,int i_ActualHeight,
                                  Vector<ScoringDescriptor> i_sdescriptor)
  {
    int i,j;
    HashSet<Integer> colors = new HashSet<Integer>();
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < i_ActualHeight ; ++j)
      {
        int color = i_blueprint.GetPiece(i,j).GetColor();
        if (color == WoodPiece.CEDAR_COLOR) continue;
        // fish causes instant match fail
        if (color == WoodPiece.FISH_COLOR) return 0.0;
        colors.add(new Integer(color));
        if (colors.size() == 2) return 0.0;
      }
    }

    i_sdescriptor.add(makeScore("Brilliant Color!!!",0,0));

    return ONECOLOR;
  }
        
  private double GetOneShapeBonus(BlueprintGrid i_blueprint,int i_ActualHeight,
                                  Vector<ScoringDescriptor> i_sdescriptor)
  {
    int i,j;
    HashSet<Integer> shapes = new HashSet<Integer>();
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < i_ActualHeight ; ++j)
      {
        int shape = i_blueprint.GetPiece(i,j).GetShape();
        if (shape == WoodPiece.CEDAR_SHAPE) continue;
        // fish causes instant match fail
        if (shape == WoodPiece.FISH_SHAPE) return 0.0;
        shapes.add(new Integer(shape));
        if (shapes.size() == 2) return 0.0;
      }
    }

    i_sdescriptor.add(makeScore("Pure Form!!!",0,0));

    return ONESHAPE;
  }

  private double GetBaseScore(BlueprintGrid i_blueprint,int i_ActualHeight,
                              Vector<ScoringDescriptor> i_sdescriptor)
  {
    // base score is sum over pieces of colorid+1 (cedar = 10)
    double basescore = 0;
    int i,j;

    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < i_ActualHeight ; ++j)
      {
        WoodPiece wp = i_blueprint.GetPiece(i,j);
        if (wp == null) continue;
        int c = wp.GetColor();
        if (c == WoodPiece.CEDAR_COLOR)
        {
          basescore += 10;
        }
        else if (c == WoodPiece.FISH_COLOR)
        {
          basescore += 1;
        }
        else
        {
          basescore += wp.GetColor() + 1;
        }
      }
    }
    return basescore;
  }

  private double GetStrengthBonus(int i_ActualWeight,int i_ParWeight,
                                  Vector<ScoringDescriptor> i_sdescriptor)
  {
    if (i_ActualWeight < i_ParWeight) return 0.0;

    // mult strength bonus = (strength - par strength) / par strength
    double strengthbonus = 100.0 * (i_ActualWeight - i_ParWeight) / i_ParWeight;
    return strengthbonus;
  }

  private double GetLegBonuses(BlueprintGrid i_blueprint,int i_ActualHeight,
                               Vector<ScoringDescriptor> i_sdescriptor)
  {
    // base per leg 
    int bonusLegCount = 0;
    double bonusLegMultiplier = 0;
    int i;
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      double lb = GetLegBonus(i_blueprint,i,i_ActualHeight);
      if (lb == 0) continue;
      bonusLegMultiplier += lb;
      i_sdescriptor.add(makeScore(legWords[bonusLegCount++],1,i)); // 1 = column
    }

    // base all legs
    //   same multiplier as sum of base per leg bonus
    if (bonusLegCount == 4) 
    {
      i_sdescriptor.add(makeScore("Nice Legs!!",0,0));
      bonusLegMultiplier *= 2.0;
    }

    return bonusLegMultiplier;
  }

  private double GetRowBonuses(BlueprintGrid i_blueprint,
                               BlueprintGrid i_matchspaces,
                               int i_ActualHeight,
                               Vector<ScoringDescriptor> i_sdescriptor)
  {
        // base per row
    int bonusRowCount = 0;
    int bonusRowMultiplier = 0;
    int i;
    for (i = 0 ; i < i_ActualHeight; ++i)
    {
      double rb = GetRowBonus(i_blueprint,i_matchspaces,i);
      if (rb == 0) continue;
      bonusRowMultiplier += rb;
      i_sdescriptor.add(makeScore(rowWords[bonusRowCount++],2,i)); // 2 = row
    }

    // base all rows
    //   same multiplier as sum of base per row bonus
    if (bonusRowCount == i_ActualHeight)
    {
      i_sdescriptor.add(makeScore("Nice Curves!!",0,0));
      bonusRowMultiplier *= 2.0;
    }

    return bonusRowMultiplier;
  }

  private double GetIncreasingTaper(BlueprintGrid i_blueprint,
                                   int i_ActualHeight,
                                   Vector<ScoringDescriptor> i_sdescriptor)
  {
    System.out.println("-----Increasing Taper-----");
    BonusScoring bs = new BonusScoring(new RowPointBlock(),
                                       new ShapeSalientRetriever(),
                                       new TaperSalientProcessor("Simple Taper!!",SIMPLETAPER,
                                                                 "Egyptian!!!",PERFECTTAPER,
                                                                 true),
                                       false);

    return bs.Score(i_blueprint,i_ActualHeight,i_sdescriptor);
  }

  private double GetDecreasingTaper(BlueprintGrid i_blueprint,
                                   int i_ActualHeight,
                                   Vector<ScoringDescriptor> i_sdescriptor)
  {
    System.out.println("-----Decreasing Taper-----");
    BonusScoring bs = new BonusScoring(new RowPointBlock(),
                                       new ShapeSalientRetriever(),
                                       new TaperSalientProcessor("Simple Taper!!",SIMPLETAPER,
                                                                 "Corinthian!!!",PERFECTTAPER,
                                                                 false),
                                       false);

    return bs.Score(i_blueprint,i_ActualHeight,i_sdescriptor);
  }

  private double GetBicurveBonus(BlueprintGrid i_blueprint,
                                 int i_ActualHeight,
                                 Vector<ScoringDescriptor> i_sdescriptor)
  {
    // make sure table is six high
    if (i_ActualHeight != 6) return 0.0;

    BonusScoring bsh = new BonusScoring(new RowPointBlock(),
                                        new ShapeSalientRetriever(),
                                        new BicurveSalientProcessor(
                                                                    "Simple Hourglass!!",SIMPLEBICURVE,
                                                                    "Gibsonesque!!!",PERFECTBICURVE,
                                                                    true),
                                        false);


    BonusScoring bsb = new BonusScoring(new RowPointBlock(),
                                        new ShapeSalientRetriever(),
                                        new BicurveSalientProcessor(
                                                                    "Simple Billow!!",SIMPLEBICURVE,
                                                                    "Rubenesque!!!",PERFECTBICURVE,
                                                                    false),
                                       false);

                                                                   
    System.out.println("----Hourglass----");
    double dh = bsh.Score(i_blueprint,i_ActualHeight,i_sdescriptor);

    System.out.println("----Billow----");
    double db = bsb.Score(i_blueprint,i_ActualHeight,i_sdescriptor);
    
    return dh+db;
  }




  // all of each column is the same color, and the colors
  // increment or decrement (wrapping from MAGENTA to RED)
  // consistently as we go left to right.
  private double GetSimpleRainbowBonus(BlueprintGrid i_blueprint,
                                       int i_ActualHeight,
                                       Vector<ScoringDescriptor> i_sdescriptor)
  {
    System.out.println("-----Simple Rainbow-----");
    BonusScoring bs = new BonusScoring(new ColumnPointBlock(),
                                       new ColorSalientRetriever(),
                                       new RainbowSalientProcessor("Simple Rainbow!!",SIMPLERAINBOW),
                                       false);

    return bs.Score(i_blueprint,i_ActualHeight,i_sdescriptor);
  }


  // all of each row is the same color, and the colors
  // increment or decrement (wrapping from MAGENTA to RED)
  // consistently as we go top to bottom
  private double GetRainbowFlagBonus(BlueprintGrid i_blueprint,
                                     int i_ActualHeight,
                                     Vector<ScoringDescriptor> i_sdescriptor)
  {
    System.out.println("-----Rainbow Flag-----");
    BonusScoring bs = new BonusScoring(new RowPointBlock(),
                                       new ColorSalientRetriever(),
                                       new RainbowSalientProcessor("Rainbow Flag!!!",RAINBOWFLAG),
                                       false);
    return bs.Score(i_blueprint,i_ActualHeight,i_sdescriptor);
  }


  // colors increment or decrement (wrapping from MAGENTA to RED)
  // consistently as we go from one diagonal corner to the other
  //
  private double GetRoyalRainbowBonus(BlueprintGrid i_blueprint,
                                      int i_ActualHeight,
                                      Vector<ScoringDescriptor> i_sdescriptor
                                      )
  {
    // only works if height is six
    if (i_ActualHeight != 6) return 0.0;

    BonusScoring bsdl = new BonusScoring(new DownLeftPointBlock(),
                                         new ColorSalientRetriever(),
                                         new RainbowSalientProcessor("Royal Rainbow!!!!",ROYALRAINBOW),
                                         true);

    BonusScoring bsdr = new BonusScoring(new DownRightPointBlock(),
                                         new ColorSalientRetriever(),
                                         new RainbowSalientProcessor("Royal Rainbow!!!!",ROYALRAINBOW),
                                         true);


    System.out.println("-----Down Left Royal Rainbow-----");
    double d1 = bsdl.Score(i_blueprint,i_ActualHeight,i_sdescriptor);
    System.out.println("-----Down Right Royal Rainbow-----");
    double d2 = bsdr.Score(i_blueprint,i_ActualHeight,i_sdescriptor);

    return d1 + d2;
  }


  private double GetThreeShapesBonus (BlueprintGrid i_blueprint, 
                                      int i_Actualheight,
                                      Vector<ScoringDescriptor> i_sdescriptor)
  {
    boolean tc = true;
    boolean iap = true;
    boolean ds = true;
    HashSet<Integer> scount = new HashSet<Integer>();
    
    int i,j;
    for (i = 0; i < i_Actualheight; ++i)
    {
      for (j = 0; j < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS; ++j)
      {
        WoodPiece wpc = i_blueprint.GetPiece(j,i);
        if (wpc != null)
        {
          switch(wpc.GetShape())
          {
          case WoodPiece.THIN_INNIE:
          case WoodPiece.MEDIUM_INNIE:
          case WoodPiece.THICK_INNIE:
            scount.add(new Integer(wpc.GetShape()));
            tc = false;
            ds = false;
            break;
          case WoodPiece.THIN_OUTIE:
          case WoodPiece.MEDIUM_OUTIE:
          case WoodPiece.THICK_OUTIE:
            scount.add(new Integer(wpc.GetShape()));
            iap = false;
            ds = false;
            break;
          case WoodPiece.THIN_STRAIGHT:
          case WoodPiece.MEDIUM_STRAIGHT:
          case WoodPiece.THICK_STRAIGHT:
            scount.add(new Integer(wpc.GetShape()));
            tc = false;
            iap = false;
            break;
          case WoodPiece.CEDAR_SHAPE:
            break;
          case WoodPiece.FISH_SHAPE:
          case WoodPiece.NO_SHAPE:
          default:
            tc = false;
            iap = false;
            ds = false;
            break;
          }
        }
      }
    }

    boolean bonus = false;
    if (tc == true && scount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Kandinskian!!",0,0));
      bonus = true;
    }

    if	(iap == true && scount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Gothic!!",0,0));
      bonus = true;
    }	

    if (ds == true && scount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Mondrian!!",0,0));
      bonus = true;
    }

    if (bonus == true)
    {
      return THREESHAPE;
    }
    else 
    {
      return 0.0;
    }
  }

                                       




  private double GetThreeColorBonus (BlueprintGrid i_blueprint, 
                                     int i_Actualheight,
                                     Vector<ScoringDescriptor> i_sdescriptor)
  {
    boolean fire = true;
    boolean water = true;
    boolean elementary = true;
    boolean mardigras = true;
    HashSet<Integer> ccount = new HashSet<Integer>();


    int i,j;


    for (i = 0; i < i_Actualheight; ++i)
    {
      for (j = 0; j < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS; ++j)
      {
        WoodPiece wpc = i_blueprint.GetPiece(j,i);
        if (wpc != null)
        {
          switch(wpc.GetColor())
          {
          case WoodPiece.RED:
            ccount.add(new Integer(wpc.GetColor()));
            water = false;
            mardigras = false;
            break;
          case WoodPiece.ORANGE:
            ccount.add(new Integer(wpc.GetColor()));
            water = false;
            elementary = false;
            break;
          case WoodPiece.YELLOW:
            ccount.add(new Integer(wpc.GetColor()));
            water = false;
            mardigras = false;
            break;
          case WoodPiece.CYAN:
            ccount.add(new Integer(wpc.GetColor()));
            fire = false;
            elementary = false;
            mardigras = false;
            break;
          case WoodPiece.BLUE:
            ccount.add(new Integer(wpc.GetColor()));
            fire = false;
            mardigras = false;
            break;
          case WoodPiece.PURPLE:
            ccount.add(new Integer(wpc.GetColor()));
            fire = false;
            elementary = false;
            break;
          case WoodPiece.GREEN:
            ccount.add(new Integer(wpc.GetColor()));
            fire = false;
            water = false;
            elementary = false;
            break;
          case WoodPiece.MAGENTA:
            ccount.add(new Integer(wpc.GetColor()));
            fire = false;
            water = false;
            elementary = false;
            mardigras = false;
            break;
          case WoodPiece.CEDAR_COLOR:
            break;
          case WoodPiece.FISH_COLOR:
            fire = false;
            water = false;
            elementary = false;
            mardigras = false;
            break;
          default:
            fire = false;
            water = false;
            elementary = false;
            mardigras = false;
            break;
          }
        }
      }
    }

    boolean bonus = false;

    if (fire == true && ccount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Fire!!",0,0));
      bonus = true;
    }

    if	(water == true && ccount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Water!!",0,0));
      bonus = true;
    }	

    if (elementary == true && ccount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Elementary!!",0,0));
      bonus = true;
    }

    if (mardigras == true && ccount.size() > 1)
    {
      i_sdescriptor.add(makeScore("Mardi Gras!!",0,0));
      bonus = true;
    }

    if (bonus == true)
    {
      return THREECOLOR;
    }
    else 
    {
      return 0.0;
    }
  }

  public Vector<ScoringDescriptor> score(BlueprintGrid i_blueprint,
                                         BlueprintGrid i_matchspaces,
                                         int i_ActualHeight,
                                         int i_ActualWeight,
                                         int i_PassWeight,
                                         int i_ParWeight)
  {
    Vector<ScoringDescriptor> result = new Vector<ScoringDescriptor>();

    // below par strength = 0
    if (i_ActualWeight < i_PassWeight)
    {
      result.add(makeScore("Booch :-(",0,0));
      return result;
    }

    double basescore = GetBaseScore(i_blueprint,i_ActualHeight,result);
    // percentages
    double strengthbonus = GetStrengthBonus(i_ActualWeight,i_ParWeight,result);
    double legbonus = GetLegBonuses(i_blueprint,i_ActualHeight,result);
    double onecolorbonus = GetOneColorBonus(i_blueprint,i_ActualHeight,result);
    double rowbonus = GetRowBonuses(i_blueprint,i_matchspaces,i_ActualHeight,result);
    double oneshapebonus = GetOneShapeBonus(i_blueprint,i_ActualHeight,result);
    double surrealbonus = GetSurrealBonus(i_blueprint,i_ActualHeight,result);
    double threecolorbonus = GetThreeColorBonus(i_blueprint,i_ActualHeight,result);
    double threeshapesbonus = GetThreeShapesBonus(i_blueprint,i_ActualHeight,result);
    double simplerainbowbonus = GetSimpleRainbowBonus(i_blueprint,i_ActualHeight,result);
    double rainbowflagbonus = GetRainbowFlagBonus(i_blueprint,i_ActualHeight,result);
    double royalrainbowbonus = GetRoyalRainbowBonus(i_blueprint,i_ActualHeight,result);

    double taperbonus = 0.0;
    double inctaper = GetIncreasingTaper(i_blueprint,i_ActualHeight,result);
    double dectaper = GetDecreasingTaper(i_blueprint,i_ActualHeight,result);
    System.out.println("  Inc Taper: " + inctaper);
    System.out.println("  Dec Taper: " + dectaper);
    double bicurve = GetBicurveBonus(i_blueprint,i_ActualHeight,result);

    System.out.println("  Bicurve: " + bicurve);
    
    taperbonus = inctaper + dectaper + bicurve;

    System.out.println("Base Score: " + basescore);
    System.out.println("Strength Bonus: " + strengthbonus);
    System.out.println("Leg Bonus: " + legbonus);
    System.out.println("Row Bonus: " + rowbonus);
    System.out.println("One Color Bonus: " + onecolorbonus);
    System.out.println("One Shape Bonus: " + oneshapebonus);
    System.out.println("Surreal Bonus: " + surrealbonus);
    System.out.println("Taper Bonus: " + taperbonus);
    System.out.println("Three-Color Bonus: " + threecolorbonus);
    System.out.println("Three-Shape Bonus: " + threeshapesbonus);
    System.out.println("Simple Rainbow Bonus: " + simplerainbowbonus);
    System.out.println("Rainbow Flag Bonus: " + rainbowflagbonus);
    System.out.println("Royal Rainbow Bonus: " + royalrainbowbonus);

    if (onecolorbonus != 0.0 && oneshapebonus != 0.0)
    {
      result.add(makeScore("Well Stacked!!!!",0,0));
    }

    double productscore = 0.0;
    double leg = legbonus + onecolorbonus + threecolorbonus + 
      simplerainbowbonus + rainbowflagbonus + royalrainbowbonus;
    double row = rowbonus + oneshapebonus + taperbonus + threeshapesbonus;
    if (leg != 0.0 && row != 0.0) productscore = leg * row;
    else if (leg != 0.0) productscore = leg;
    else if (row != 0.0) productscore = row;



    double dadabonus = 0.0;
    if (productscore == 0.0)
    {
      dadabonus = GetDadaBonus(i_blueprint,i_ActualHeight,result);
    }

    System.out.println("DaDa Bonus: " + dadabonus);

    double realscore = basescore + 
      basescore *  (
                    strengthbonus + 
                    productscore +
                    dadabonus +
                    surrealbonus
                    ) / 100.0;

    System.out.println("Final Score: " + realscore);

    if (result.size() == 0)
    {
      result.add(makeScore("A Fair Job",0,0));
    }

      
    result.get(0).m_Score = realscore;

    return result;
  }
}

