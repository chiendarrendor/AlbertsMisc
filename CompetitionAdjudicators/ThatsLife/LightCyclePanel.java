

import java.awt.*;

class LightCyclePanel extends MyAnimationPanel {
  private static final int WIDTH = 800;
  private static final int HEIGHT = 800;
  private static final int INSET = 25;
  private static final int CYCLEMILLIS = 15;
  private static final Color ACOLOR = Color.yellow;
  private static final Color BCOLOR = Color.blue;

  GameInfo gameInfo;
  int boardsize;

  // this assumes that the board is square, both in terms of # of cells and in terms
  // of screen real estate
  private int GetCellCenter(int idx)
  {
    float cellwidth = (float)(WIDTH-2*INSET) / (float)boardsize;
    float dcoord = (float)INSET + cellwidth/2.0F + cellwidth * idx;
    return Math.round(dcoord);
  }

  private int GetCellRadius()
  {
    return Math.round((float)(WIDTH-2*INSET) / (float)boardsize / 2.0F);
  }

  private class NamesElement implements AnimationElement
  {
    String aName;
    String bName;
    public NamesElement(String i_aName,String i_bName)
    {
      aName = i_aName;
      bName = i_bName;
    }

    public void paint(Graphics g)
    {
      g.setFont(new Font("Serif",Font.PLAIN,20));
      g.setColor(ACOLOR);
      g.drawString(aName,INSET,20);
      
      g.setColor(BCOLOR);
      int swidth = g.getFontMetrics().stringWidth(bName);
      g.drawString(bName,WIDTH-INSET-swidth,20);
    }

    public String toString()
    {
      return "NamesElement " + aName + "," + bName;
    }
  }

  private class LinesElement implements AnimationElement
  {
    public void paint(Graphics g)
    {
      g.setColor(Color.white);
      g.drawRect(INSET,INSET,WIDTH-INSET*2,HEIGHT-INSET*2);
      g.drawRect(INSET-1,INSET-1,WIDTH-INSET*2+2,HEIGHT-INSET*2+2);
      g.drawRect(INSET-2,INSET-2,WIDTH-INSET*2+4,HEIGHT-INSET*2+4);
      
      for (int i = 0 ; i < boardsize ; ++i)
      {
        g.drawLine(GetCellCenter(i),INSET,GetCellCenter(i),HEIGHT-INSET);
        g.drawLine(INSET,GetCellCenter(i),WIDTH-INSET,GetCellCenter(i));
      }
    }

    public String toString()
    {
      return "LinesElement";
    }
  }

  // this will animate a growing line, chaining to subsequents
  // when it reaches full length.  It should draw the full length
  // line each time after it reaches full length.
  private class SegmentChainingAnimationElement extends ChainingAnimationElement
  {
    private Point startPoint;
    private char growDir;
    private int curLength;
    private int maxLength;
    private static final int SEGWIDTH = 5;
    private Color drawColor;

    public SegmentChainingAnimationElement(boolean i_started,
                                           Color i_drawColor,
                                           Point i_startPoint,
                                           char i_growDir,
                                           int i_maxLength)
    {
      super(i_started);
      startPoint = new Point(i_startPoint.x,i_startPoint.y);
      drawColor = i_drawColor;
      curLength = 0;
      maxLength = i_maxLength;
      growDir = i_growDir;
    }

    public void chainPaint(Graphics g)
    {
      g.setColor(drawColor);

      switch(growDir)
      {
      case 'U': g.fillRect(startPoint.x-2,startPoint.y-curLength,SEGWIDTH,curLength); break;
      case 'D': g.fillRect(startPoint.x-2,startPoint.y,SEGWIDTH,curLength); break;
      case 'L': g.fillRect(startPoint.x-curLength,startPoint.y-2,curLength,SEGWIDTH); break;
      case 'R': g.fillRect(startPoint.x,startPoint.y-2,curLength,SEGWIDTH); break;
      }
      
      if (curLength+1 == maxLength) chain();
      if (curLength < maxLength) curLength++;
    }

    public String toString()
    {
      return "Segment " + growDir + " (" + startPoint.x + "," + startPoint.y + ")";
    }

  }    

  private class CrashAnimation extends ChainingAnimationElement
  {
    Point center;
    Color color;
    int curradius;
    public CrashAnimation(boolean i_started,Point i_center,Color i_color)
    {
      super(i_started);
      center = new Point(i_center.x,i_center.y);
      color = i_color;
      curradius = 1;
      if (color == ACOLOR) curradius = 15;
    }

    public void chainPaint(Graphics g)
    {
      g.setColor(color);
      g.drawOval(center.x-curradius,center.y-curradius,curradius*2,curradius*2);
      g.drawOval(center.x-curradius-1,center.y-curradius-1,curradius*2+2,curradius*2+2);
      curradius += 1;
      if (curradius > 30) curradius = 1;
    }

    public String toString()
    {
      return "CrashAnimation (" + center.x + "," + center.y + ")";
    }

  }

  // starting from the current cell, process the current move at movestep for the given player
  private void BuildAnimationStep(PlayerInfo info,int movestep,
                                  ChainingAnimationElement priorchain,
                                  Color plcolor, Point curcell)
  {
    // screen coords
    Point centerpoint = new Point(GetCellCenter(curcell.x),GetCellCenter(curcell.y));

    // assume, quite reasonably, that a 'no move' is a crash...gets crash animation
    if (info.GetMove(movestep) == '-') 
    {
      ChainingAnimationElement cae = new CrashAnimation(priorchain==null,centerpoint,plcolor);
      AddAnimationElement(cae);
      if (priorchain != null) priorchain.AddChain(cae);
      return;
    }
    
    // ok...we can leave the cell...regardless of whether or not we crash now.

    ChainingAnimationElement outgoingelement = new SegmentChainingAnimationElement(priorchain==null,
                                                                                   plcolor,
                                                                                   centerpoint,
                                                                                   info.GetMove(movestep),
                                                                                   GetCellRadius());
    AddAnimationElement(outgoingelement);
    if (priorchain != null) priorchain.AddChain(outgoingelement);

    
    // calculate the next cell, as well as the 'edge' point
    Point newcell = new Point();
    Point edgepoint = new Point();
    switch(info.GetMove(movestep))
    {
    case 'U':
      newcell.x = curcell.x;
      newcell.y = curcell.y-1;
      edgepoint.x = centerpoint.x;
      edgepoint.y = centerpoint.y - GetCellRadius();
      break;
    case 'D':
      newcell.x = curcell.x;
      newcell.y = curcell.y+1;
      edgepoint.x = centerpoint.x;
      edgepoint.y = centerpoint.y + GetCellRadius();
      break;
    case 'L':
      newcell.x = curcell.x-1;
      newcell.y = curcell.y;
      edgepoint.x = centerpoint.x-GetCellRadius();
      edgepoint.y = centerpoint.y;
      break;
    case 'R':
      newcell.x = curcell.x+1;
      newcell.y = curcell.y;
      edgepoint.x = centerpoint.x+GetCellRadius();
      edgepoint.y = centerpoint.y;
      break;
    }

    // if we leave the board, we hit the wall.
    if (newcell.x < 0 || newcell.y < 0 || newcell.x == boardsize || newcell.y == boardsize)
    {
      ChainingAnimationElement cae = new CrashAnimation(false,edgepoint,plcolor);
      AddAnimationElement(cae);
      outgoingelement.AddChain(cae);
      return;
    }

    // if we didn't hit a wall, we can animate to the center of the next cell.
    ChainingAnimationElement incomingelement = new SegmentChainingAnimationElement(false,
                                                                                   plcolor,
                                                                                   edgepoint,
                                                                                   info.GetMove(movestep),
                                                                                   GetCellRadius());
    AddAnimationElement(incomingelement);
    outgoingelement.AddChain(incomingelement);

    // ok...if we're here, then we have to decide whether or not to recurse.
    // if we're not on the last move, then we recurse.
    movestep++;
    if (movestep < gameInfo.GetMoveCount())
    {
      BuildAnimationStep(info,movestep,incomingelement,plcolor,newcell);
      return;
    }

    // if we're here, we decided not to recurse because we're at the end.
    // one final case...if this player crashed, we add the animation
    if (info.Crashed())
    {
      Point nextpoint = new Point(GetCellCenter(newcell.x),GetCellCenter(newcell.y));
      ChainingAnimationElement cae = new CrashAnimation(false,nextpoint,plcolor);
      AddAnimationElement(cae);
      incomingelement.AddChain(cae);
    }
  }

  private void BuildAnimationList(PlayerInfo info,Color plcolor,Point startcell)
  {
    BuildAnimationStep(info,0,null,plcolor,startcell);
  }

  public LightCyclePanel(GameInfo i_gameInfo,int i_boardSize)
  {
    super(WIDTH,HEIGHT,CYCLEMILLIS);
    gameInfo = i_gameInfo;
    boardsize = i_boardSize;
    setBackground(Color.black);

    AddAnimationElement(new NamesElement(gameInfo.GetPlayerA().GetName(),gameInfo.GetPlayerB().GetName()));
    AddAnimationElement(new LinesElement());

    BuildAnimationList(gameInfo.GetPlayerA(),ACOLOR,new Point(0,boardsize/2));
    BuildAnimationList(gameInfo.GetPlayerB(),BCOLOR,new Point(boardsize-1,boardsize/2));
    Display();
  }
}

    
