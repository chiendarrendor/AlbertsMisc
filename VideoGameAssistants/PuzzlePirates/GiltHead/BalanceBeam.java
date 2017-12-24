import java.awt.Color;
import java.awt.Graphics;
import java.awt.Polygon;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.Graphics2D;

// this is an output-only animated panel that does the following things:
// 
// 1. draws a background that is one of two ranges of colors depending
//    on whether the rate of pieces added to the board will ultimately
//    lead to a high-enough-strength board.
// 2. chooses a color for the balance beam based on whether the 
//    the current strength of the board is sufficient to 
//    a. not booch
//    b. pass
//    c. get a strength bonus
// 3. draw the balance beam in that color, at an angle that
//    comes from the RulesEngine GetWeightPercent()
//    where 0 is the left side resting on the ground, and 100
//    is the right side resting on the ground.
//    in addition, the animation smoothly changes the drawn angle
//    even if the percentage changes suddenly, and
//    adds a small bobbing motion when the beam is 'still'.
//
//    there are the following visual components:
//    1. the beam itself
//    2. the fulcrum
//    3. a set of 'Standard' weights, of constant form
//    4. a set of 'Test' weights, that increases in number as GetWeightPercent() increases.



class BalanceBeam extends MyAnimationPanel
{
  private RulesEngine m_rulesengine;

  private Color boochScaleColor = new Color(0x66,0x33,0x00);
  private Color passScaleColor = new Color(0xff,0xcc,0x66);
  private Color bonusScaleColor = new Color(0xff,0xff,0xcc);

  private Color weightColor = new Color(0x99,0x66,0x00);

  private Color backColor = new Color(0x00,0x66,0x66);

  private Color back_LowBooch = new Color(0x33,0x00,0x33);
  private Color back_HighBooch = new Color(0x00,0x00,0x66);
  private Color back_LowPass = new Color(0x00,0x99,0x99);
  private Color back_HighPass = new Color(0x00,0xCC,0x00);



  private Color curcolor;

  private int m_percentage;
  private int m_realpercentage;
  private int m_bobdir;
  private int m_boboffset;
  private long m_nextbobaction;




  public BalanceBeam(RulesEngine i_rulesengine)
  {
    super(GiltHeadConstants.BALANCE_BEAM_WIDTH,
          GiltHeadConstants.BALANCE_BEAM_HEIGHT,
          GiltHeadConstants.BALANCE_BEAM_CYCLE_TIME);
    m_rulesengine = i_rulesengine;
    m_percentage = m_rulesengine.GetWeightPercent();
    m_realpercentage = m_rulesengine.GetWeightPercent();
  }

  // returns a panel-origin point given a fulcrum-origin point
  public Point shiftToFulcrum(Point p)
  {
    Point np = new Point(p.x + GiltHeadConstants.BALANCE_BEAM_WIDTH/2,
                         p.y + GiltHeadConstants.BALANCE_BEAM_HEIGHT-GiltHeadConstants.BALANCE_BEAM_FULCRUM_HEIGHT);
    return np;
  }

  // given the balance beam described by the constants, a point (relative to the fulcrum under 50% rotation)
  // and a rotation percent, calculate the Point having been rotated that much. (again, relative to the fulcrum)
  // 

  public Point getRotatedPoint(int i_dx,int i_dy,int i_percent)
  {
    Point result = new Point();
    double fheight = GiltHeadConstants.BALANCE_BEAM_FULCRUM_HEIGHT;
    double radius = GiltHeadConstants.BALANCE_BEAM_BEAM_LENGTH/2;
    double pct = i_percent;

    // calculate lower left corner of the beam (for sin/cos theta)
    double lly = -fheight + (pct/100.0)*2.0*fheight;
    double llx = Math.sqrt(radius * radius - lly * lly);

    // calculate projection onto beam of desired point
    double px = i_dx * llx / radius;
    double py = i_dx * lly / radius;

    // calculate delta x and delta y to lift it off the beam.
    double dx = i_dy * lly / radius;
    double dy = i_dy * llx / radius;


    result.x = (int)(px-dx);
    result.y = (int)(py+dy);

    return result;
  }

  public void drawBeam(Graphics g,int i_percent)
  {
    int radius = GiltHeadConstants.BALANCE_BEAM_BEAM_LENGTH/2;
    int  thick = GiltHeadConstants.BALANCE_BEAM_BEAM_THICKNESS;
    Polygon poly = new Polygon();
    Point p;

    p = shiftToFulcrum(getRotatedPoint(-radius,0,i_percent));
    poly.addPoint(p.x,p.y);
    p = shiftToFulcrum(getRotatedPoint(+radius,0,i_percent));
    poly.addPoint(p.x,p.y);
    p = shiftToFulcrum(getRotatedPoint(+radius,-thick,i_percent));
    poly.addPoint(p.x,p.y);
    p = shiftToFulcrum(getRotatedPoint(-radius,-thick,i_percent));
    poly.addPoint(p.x,p.y);

    g.fillPolygon(poly);
    g.drawPolygon(poly);
  }

  public void drawCircle(int i_x,int i_y,int i_radius,Graphics g,
                         Color i_fillcolor,Color i_linecolor)
  {
    g.setColor(i_fillcolor);
    g.fillOval(i_x-i_radius,i_y-i_radius,2*i_radius,2*i_radius);
    g.setColor(i_linecolor);
    g.drawOval(i_x-i_radius,i_y-i_radius,2*i_radius,2*i_radius);
  }


  public void drawFulcrum(Graphics g)
  {
    int fwidth =  GiltHeadConstants.BALANCE_BEAM_FULCRUM_WIDTH;
    int fheight = GiltHeadConstants.BALANCE_BEAM_FULCRUM_HEIGHT;
    Polygon fulcrum = new Polygon();
    
    // tip
    Point p1 = shiftToFulcrum(new Point(0,0));
    fulcrum.addPoint(p1.x,p1.y);

    // lower right corner
    Point p2 = shiftToFulcrum(new Point(fwidth/2,fheight));
    fulcrum.addPoint(p2.x,p2.y);

    // lower left corner
    Point p3 = shiftToFulcrum(new Point(-fwidth/2,fheight));
    fulcrum.addPoint(p3.x,p3.y);

    g.fillPolygon(fulcrum);
    g.drawPolygon(fulcrum);
  }

  public void drawStandardWeights(Graphics g,int i_percentage)
  {
    int bradius = GiltHeadConstants.BALANCE_BEAM_BEAM_LENGTH/2;
    int bthick = GiltHeadConstants.BALANCE_BEAM_BEAM_THICKNESS;

    int wradius = GiltHeadConstants.BALANCE_BEAM_STANDARD_WEIGHT_SIZE;
    int firstinset = GiltHeadConstants.BALANCE_BEAM_WEIGHT_INSET;

    Point p;
    p = shiftToFulcrum(getRotatedPoint(-bradius + firstinset+  2 * wradius,-bthick - wradius,i_percentage));
    drawCircle(p.x,p.y,wradius,g,weightColor,weightColor);

    p = shiftToFulcrum(getRotatedPoint(-bradius + firstinset + 4 * wradius,-bthick - wradius,i_percentage));
    drawCircle(p.x,p.y,wradius,g,weightColor,weightColor);

    p = shiftToFulcrum(getRotatedPoint(-bradius + firstinset + 6 * wradius,-bthick - wradius,i_percentage));
    drawCircle(p.x,p.y,wradius,g,weightColor,weightColor);

    double hoff = Math.sqrt(3.0) * wradius;

    p = shiftToFulcrum(getRotatedPoint(-bradius + firstinset+  3 * wradius,-bthick - wradius-(int)hoff,i_percentage));
    drawCircle(p.x,p.y,wradius,g,weightColor,weightColor);
      
    p = shiftToFulcrum(getRotatedPoint(-bradius + firstinset+  5 * wradius,-bthick - wradius-(int)hoff,i_percentage));
    drawCircle(p.x,p.y,wradius,g,weightColor,weightColor);

  }

  public void drawTestWeights(Graphics g,int i_percentage)
  {
    Point p;
    int bradius = GiltHeadConstants.BALANCE_BEAM_BEAM_LENGTH/2;
    int bthick = GiltHeadConstants.BALANCE_BEAM_BEAM_THICKNESS;
    int wradius = GiltHeadConstants.BALANCE_BEAM_TEST_WEIGHT_SIZE;
    int firstinset = GiltHeadConstants.BALANCE_BEAM_WEIGHT_INSET;

    int firstx = bradius - firstinset - 2 * wradius;
    int firsty = -bthick - wradius;
    int hoff = (int)(Math.sqrt(3.0) * wradius);

    if (m_realpercentage == 0) return;

    p = shiftToFulcrum(getRotatedPoint(firstx,firsty,i_percentage));
    drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);

    if (m_realpercentage >= 10)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 2*wradius,firsty,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 20)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 4*wradius,firsty,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 30)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 6*wradius,firsty,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 40)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 4*wradius,firsty,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 50)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - wradius,firsty-hoff,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 60)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 3 * wradius,firsty-hoff,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 70)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 5 * wradius,firsty-hoff,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 80)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 2 * wradius,firsty-2*hoff,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage >= 90)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 4 * wradius,firsty-2*hoff,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
    if (m_realpercentage == 100)
    {
      p = shiftToFulcrum(getRotatedPoint(firstx - 3 * wradius,firsty-3*hoff,i_percentage));
      drawCircle(p.x,p.y,wradius,g,curcolor,curcolor);
    }
  }


  public void paint(Graphics g)
  {
    int curPercentage;

    // render with Antialiasing.
    Graphics2D g2 = (Graphics2D)g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);



    // determine how to animate the beam this cycle.

    m_realpercentage = m_rulesengine.GetWeightPercent();
    if (m_realpercentage < m_percentage)
    {
      // if the real percentage is lower than the last animated percentage
      // shift it by the angular velocity
      m_percentage -= GiltHeadConstants.BALANCE_BEAM_ANGULAR_VELOCITY;
      // reset the bob
      m_bobdir = -1;
      m_boboffset = 1;
      m_nextbobaction = System.currentTimeMillis() + GiltHeadConstants.BALANCE_BEAM_BOB_RATE;
      curPercentage = m_percentage;
    }
    else if (m_realpercentage > m_percentage)
    {
      // if the real percentage is larger than the last animated percentage
      // shift it by the angular velocity
      m_percentage += GiltHeadConstants.BALANCE_BEAM_ANGULAR_VELOCITY;
      // reset the bob.
      m_bobdir = +1;
      m_boboffset = +1;
      m_nextbobaction = System.currentTimeMillis() + GiltHeadConstants.BALANCE_BEAM_BOB_RATE;
      curPercentage = m_percentage;
    }
    else 
    {
      // else we're where we're supposed to be...bob
      // 
      if (System.currentTimeMillis() > m_nextbobaction)
      {
        // if enough time has passed...
        // see if we've reached the limit of our bob, and switch direction
        if (m_boboffset == GiltHeadConstants.BALANCE_BEAM_BOB_MAX_OFFSET)
        {
          m_bobdir = -1;
        }
        if (m_boboffset == -GiltHeadConstants.BALANCE_BEAM_BOB_MAX_OFFSET)
        {
          m_bobdir = +1;
        }

        // alter the bob offset appropriately
        m_boboffset += m_bobdir;
        // go inactive for a while
        m_nextbobaction = System.currentTimeMillis() + GiltHeadConstants.BALANCE_BEAM_BOB_RATE;
      }
      
      // regardless of whether or not we change the bob offset, add it to m_percentage to
      // get the current percentage
      curPercentage = m_percentage + m_boboffset;
    }  

    // based on the WeightProgress object, draw the background color
    WeightProgress wp = m_rulesengine.GetWeightProgress();
    
    switch(wp.m_band)
    {
    case WeightProgress.BOOCHING:
      g.setColor(Utilities.interpolateColor(back_LowBooch,back_HighBooch,(int)(wp.m_rating * 100.0)));
      break;
    case WeightProgress.PASSING:
    default:
      g.setColor(Utilities.interpolateColor(back_LowPass,back_HighPass,(int)(wp.m_rating * 100.0)));
      break;
    }

    g.fillRect(0,0,GiltHeadConstants.SCREEN_WIDTH,GiltHeadConstants.BALANCE_BEAM_HEIGHT);

    // calculate the foreground color
    curcolor = boochScaleColor;
    if (m_rulesengine.IsPassingWeight())
    {
      curcolor = passScaleColor;
    }
    if (m_rulesengine.IsParWeight())
    {
      curcolor = bonusScaleColor;
    }

    g.setColor(curcolor);
    // fulcrum and beam draw assuming color is correct
    drawFulcrum(g);
    drawBeam(g,curPercentage);

    // weights draws use either curcolor or weightcolor
    drawTestWeights(g,curPercentage);
    drawStandardWeights(g,curPercentage);



  }
}
