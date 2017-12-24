import java.awt.Graphics;
import java.awt.Color;
import java.util.Vector;
import java.awt.Point;
import java.awt.Rectangle;
import javax.swing.event.MouseInputListener;
import java.awt.event.MouseEvent;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.Graphics2D;
import java.awt.Font;

// This is the primary animation area for the game.
// the code in this file is responsible for drawing
// the blueprint, with pieces on it and the completed scrolls down the middle,
// the workbench,
// the animations for the end-of-table tabletop drop and the descending words
// by proxy, the Sushi Bar
// this code is also responsible for handling the mouse processing, including
// animating the picked-up piece.


public class WorkArea extends MyAnimationPanel implements MouseInputListener
{
  private RulesEngine m_rulesengine;
  private SushiBar m_sb;
  private Vector<Rectangle> m_WorkBenchSpaces;
  private Vector<Rectangle> m_BlueprintClickAreas;
  private Point m_CurMouse;
  private int m_workmousedown;
  private Color basecolor = new Color(0x99,0x66,0x00);
  private Color brightcolor = new Color(0xff,0xff,0x00);
  private Color backcolor = new Color(0x98,0xB8,0xD6);
  private Color benchcolor = new Color(0x99,0x66,0x33);
  private Color bluecolor = new Color(0x77,0x96,0xB8);
  private Color darkbluecolor = new Color(0x24,0x34,0x68);

  public WorkArea(RulesEngine i_rulesengine,WoodPieceChanger i_wpc)
  {
    super(GiltHeadConstants.SCREEN_WIDTH,
          GiltHeadConstants.WORK_AREA_HEIGHT,
          GiltHeadConstants.WORK_AREA_CYCLE_TIME);
    m_rulesengine = i_rulesengine;
    m_sb = new SushiBar(m_rulesengine,i_wpc);

    setBackground(backcolor);

    m_workmousedown = -1;
    m_WorkBenchSpaces = new Vector<Rectangle>();
    m_WorkBenchSpaces.setSize(GiltHeadConstants.WORK_BENCH_COUNT);

    CalculateWorkBenchSpaces();
    CalculateBlueprintClickAreas();

    m_CurMouse = new Point(0,0);
    addMouseMotionListener(this);
    addMouseListener(this);
  }


  // this code calculates the locations of the six rectangles on the
  // screen that represent the drop/pickup locations for the workbench

  private void CalculateWorkBenchSpaces()
  {
    int i;

    int hsep = (GiltHeadConstants.SCREEN_WIDTH - 
                GiltHeadConstants.WORK_BENCH_COUNT * GiltHeadConstants.PIECE_WIDTH) / 
      (GiltHeadConstants.WORK_BENCH_COUNT+1);
    int vsep = GiltHeadConstants.WORK_BENCH_Y_LOCATION + 
      (GiltHeadConstants.WORK_BENCH_HEIGHT - GiltHeadConstants.PIECE_HEIGHT) / 2;

    for (i = 0 ; i < GiltHeadConstants.WORK_BENCH_COUNT ; ++i)
    {
      m_WorkBenchSpaces.set(i,new Rectangle(
                                            hsep+(hsep+GiltHeadConstants.PIECE_WIDTH)*i,
                                            vsep,
                                            GiltHeadConstants.PIECE_WIDTH, 
                                            GiltHeadConstants.PIECE_HEIGHT));
    }
  }

  // this code calculates four tall rectangles representing the four columns of
  // the blueprint, used for drop locations.

  private void CalculateBlueprintClickAreas()
  {
    m_BlueprintClickAreas = new Vector<Rectangle>();
    m_BlueprintClickAreas.setSize(GiltHeadConstants.BLUEPRINT_NUM_COLUMNS);

    m_BlueprintClickAreas.set(0,
                              new Rectangle(
                                            GiltHeadConstants.BLUEPRINT_COLUMN1_INSET,
                                            0,
                                            GiltHeadConstants.PIECE_WIDTH, 
                                            GiltHeadConstants.BLUEPRINT_HEIGHT
                                            )
                              );

    m_BlueprintClickAreas.set(1,
                              new Rectangle(
                                            GiltHeadConstants.BLUEPRINT_COLUMN1_INSET + 
                                            GiltHeadConstants.PIECE_WIDTH + 
                                            GiltHeadConstants.BLUEPRINT_COLUMN2_INSET,
                                            0,
                                            GiltHeadConstants.PIECE_WIDTH, 
                                            GiltHeadConstants.BLUEPRINT_HEIGHT
                                            )
                              );

    m_BlueprintClickAreas.set(2,
                              new Rectangle(
                                            GiltHeadConstants.SCREEN_WIDTH-
                                            GiltHeadConstants.BLUEPRINT_COLUMN1_INSET-
                                            2*GiltHeadConstants.PIECE_WIDTH-
                                            GiltHeadConstants.BLUEPRINT_COLUMN2_INSET,
                                            0,
                                            GiltHeadConstants.PIECE_WIDTH, 
                                            GiltHeadConstants.BLUEPRINT_HEIGHT
                                            )
                              );

    m_BlueprintClickAreas.set(3,
                              new Rectangle(
                                            GiltHeadConstants.SCREEN_WIDTH-
                                            GiltHeadConstants.BLUEPRINT_COLUMN1_INSET-
                                            GiltHeadConstants.PIECE_WIDTH,
                                            0,
                                            GiltHeadConstants.PIECE_WIDTH, 
                                            GiltHeadConstants.BLUEPRINT_HEIGHT
                                            )
                              );
    
  }


  // keeps track of mouse movement for animating the lifted piece

  public void mouseDragged(MouseEvent e)
  {
    mouseMoved(e);
  }

  public void mouseMoved(MouseEvent e)
  {
    synchronized(m_CurMouse)
    {
      m_CurMouse.x = e.getX();
      m_CurMouse.y = e.getY();
    }
  }

  // what do do on a mousedown
  public void mousePressed(MouseEvent e)
  { 
    // if we already have a piece in hand, mousedown isn't useful
    if (m_rulesengine.GetTransferPiece() != null) return;
    int i;

    // checking work bench spaces
    for (i = 0 ; i < GiltHeadConstants.WORK_BENCH_COUNT ; ++i)
    {
      Rectangle r = m_WorkBenchSpaces.get(i);
      if (!r.contains(e.getX(),e.getY())) continue;
      // if we are over one of the work bench spaces....
        
      WoodPiece wp = m_rulesengine.GetWorkBench(i);
      if (wp == null) continue;

      // pop it off of the bench, and put it in hand.
      m_workmousedown = i;
      m_rulesengine.SetWorkBench(null,i);
      m_rulesengine.PieceToTransfer(wp,RulesEngine.PieceLocation.WORKBENCH);
      return;
    }

    // if we got here, check if the sushibar wants the mousepress.
    m_sb.mousePressed(e);
  }

  public void mouseReleased(MouseEvent e)
  { 
    // if we release the mouse, and we don't have a transfer piece, it's not interesting.
    WoodPiece tp = m_rulesengine.GetTransferPiece();

    if (tp == null) return;

    int i;
    for (i = 0 ; i < GiltHeadConstants.WORK_BENCH_COUNT ; ++i)
    {
      Rectangle r = m_WorkBenchSpaces.get(i);
      if (!r.contains(e.getX(),e.getY())) continue;

      // if we release over a work bench space
        
      WoodPiece wp = m_rulesengine.GetWorkBench(i);

      // that's empty
      if (wp != null) return;

      // drop it there.
      m_rulesengine.SetWorkBench(tp,i);
      m_rulesengine.PieceToTransfer(null,RulesEngine.PieceLocation.NO_LOCATION);
      return;
    }
    
    // blueprint click release stuff
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      Rectangle r = m_BlueprintClickAreas.get(i);
      if (r.contains(e.getX(),e.getY()))
      {
        // if we are over a blueprint column when we release, see if we can add a piece
        // to that column
        if (m_rulesengine.AddPieceToColumn(tp,i))
        {
          // if so, clear the transfer piece.
          m_rulesengine.PieceToTransfer(null,RulesEngine.PieceLocation.NO_LOCATION);
        }
      }
    }
  }

  public void mouseClicked(MouseEvent e) { }
  public void mouseEntered(MouseEvent e)  {  }
  public void mouseExited(MouseEvent e)  {  }


  private void drawWorkBench(Graphics g)
  {
    g.setColor(benchcolor);
    // draw the background image for the bench
    g.drawImage(ImageManager.getImage("Workbench3.png"),
                0,
                GiltHeadConstants.WORK_BENCH_Y_LOCATION,
                null);


    int i;
    // for each space on the bench
    for (i = 0 ; i < GiltHeadConstants.WORK_BENCH_COUNT ; ++i)
    {
      WoodPiece wp = m_rulesengine.GetWorkBench(i);
      Rectangle r = m_WorkBenchSpaces.get(i);
      
      // if there's no piece there, draw a shaded transparent rounded rectangle there
      if (wp == null)
      {
        g.setColor(new Color(0x00,0x00,0x00,0x80));
        g.fillRoundRect(r.x,r.y,r.width,r.height,25,25);
      }
      else
      {
        // otherwase, draw the piece.
        wp.Draw(g,r.x,r.y);
      }
    }
  }


  // calculate the upper side of a line in the given row.
  private int getCellY(int i_row)
  {
    return 
      GiltHeadConstants.BLUEPRINT_HEIGHT-GiltHeadConstants.BLUEPRINT_BOTTOM_UPSET -
      GiltHeadConstants.PIECE_HEIGHT -
      i_row * (GiltHeadConstants.BLUEPRINT_VERTICAL_SEPARATION + 
               GiltHeadConstants.PIECE_HEIGHT);
  }




  private void drawBlueprintCell(Graphics g,int i_column,int i_row)
  {
    int pheight =  getCellY(i_row);

    int pleft = m_BlueprintClickAreas.get(i_column).x;

    WoodPiece wp = m_rulesengine.GetBlueprintCell(i_column,i_row);
    if (wp == null)
    {
      int shape = m_rulesengine.GetMatchSpace(i_column,i_row);
      if (shape == WoodPiece.NO_SHAPE) return;

      Image img;

      switch(shape)
      {
      case WoodPiece.THIN_INNIE: img = ImageManager.getImage("Silhouette_Thin_Concave.png"); break;
      case WoodPiece.THIN_STRAIGHT: img = ImageManager.getImage("Silhouette_Thin_Straight.png"); break;
      case WoodPiece.THIN_OUTIE: img = ImageManager.getImage("Silhouette_Thin_Convex.png"); break;
      case WoodPiece.MEDIUM_INNIE: img = ImageManager.getImage("Silhouette_Medium_Concave.png"); break;
      case WoodPiece.MEDIUM_STRAIGHT: img = ImageManager.getImage("Silhouette_Medium_Straight.png"); break;
      case WoodPiece.MEDIUM_OUTIE: img = ImageManager.getImage("Silhouette_Medium_Convex.png"); break;
      case WoodPiece.THICK_INNIE: img = ImageManager.getImage("Silhouette_Thick_Concave.png"); break;
      case WoodPiece.THICK_STRAIGHT: img = ImageManager.getImage("Silhouette_Thick_Straight.png"); break;
      case WoodPiece.THICK_OUTIE: 
      default: img = ImageManager.getImage("Silhouette_Thick_Convex.png"); break;
      }

      g.drawImage(img,pleft,pheight,null);
    }
    else
    {
      wp.Draw(g,pleft,pheight);
    }
  }

  private void drawBlueprint(Graphics g)
  {
    g.drawImage(ImageManager.getImage("Blueprint.png"),0,0,null);

    int height = m_rulesengine.GetBlueprintSize();
    WoodPiece wp;

    int tw = m_rulesengine.GetTableTopWeight();
    int th;
    switch(tw)
    {
    case 1: th = GiltHeadConstants.TABLETOP_HEIGHT_1; break;
    case 2: th = GiltHeadConstants.TABLETOP_HEIGHT_2; break;
    case 3: 
    default:th = GiltHeadConstants.TABLETOP_HEIGHT_3; break;
    }

    g.setColor(bluecolor);
    g.fillRoundRect((GiltHeadConstants.SCREEN_WIDTH -
                     GiltHeadConstants.TABLETOP_WIDTH)/2,
                    getCellY(height-1) - 
                    GiltHeadConstants.BLUEPRINT_VERTICAL_SEPARATION -
                    th,
                    GiltHeadConstants.TABLETOP_WIDTH,
                    th,
                    25,25);

    

    

    int i,j;

    for (i = 0 ; i < height; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++j)
      {
        drawBlueprintCell(g,j,i);
      }
    }
  }


  private void drawActivePiece(Graphics g)
  {
    WoodPiece twp = m_rulesengine.GetTransferPiece();
    if (twp == null) return;
    twp.Draw(g,
             m_CurMouse.x - GiltHeadConstants.PIECE_WIDTH/2,
             m_CurMouse.y - GiltHeadConstants.PIECE_HEIGHT/2
             );
  }

  private void drawNumCompleted(Graphics g)
  {
    Vector<Integer> comps = m_rulesengine.GetBlueprintCompletions();
    int i;

    for (i = 0 ; i < m_rulesengine.GetBlueprintGoal() ; ++i)
    {
      int x = GiltHeadConstants.COMPLETED_X - GiltHeadConstants.COMPLETED_WIDTH/2;
      int y = GiltHeadConstants.BLUEPRINT_HEIGHT - 
        GiltHeadConstants.COMPLETED_BOTTOM_UPSET - 
        (i+1)*GiltHeadConstants.COMPLETED_HEIGHT -
        i * GiltHeadConstants.COMPLETED_SEP;


      if (i < comps.size())
      {
        int qual = comps.get(i).intValue();
        String inames[] = {"Booched","Poor","Fine","Good","Excellent","Incredible"};
        g.drawImage(ImageManager.getImage("Scroll_" + inames[qual] + ".png"),x,y,null);
      }
      else
      {
        g.drawImage(ImageManager.getImage("Scroll_Blank.png"),x,y,null);
      }
    }
  }

  private ScoringDescriptor m_curScoring = null;
  private int m_CurStatusLocation;
  private long m_pausefinish;

  private Image m_ttim = null;

  private void buildTabletopImage()
  {
    int th;
    switch(m_rulesengine.GetTableTopWeight())
    {
    case 1: th = GiltHeadConstants.TABLETOP_HEIGHT_1; break;
    case 2: th = GiltHeadConstants.TABLETOP_HEIGHT_2; break;
    case 3: th = GiltHeadConstants.TABLETOP_HEIGHT_3; break;
    default:th = GiltHeadConstants.TABLETOP_HEIGHT_3; break;
    }
    int tw = GiltHeadConstants.TABLETOP_WIDTH;

    BufferedImage bi = new BufferedImage(tw,th,BufferedImage.TYPE_INT_ARGB);
    Graphics2D g = (Graphics2D)bi.createGraphics();
    g.setColor(new Color(0x00,0x00,0x00));
    g.fillRoundRect(0,0,tw,th,25,25);

    BufferedImage biwood = new BufferedImage(tw,th,BufferedImage.TYPE_INT_ARGB);
    biwood.createGraphics().drawImage(ImageManager.getImage("Workbench3.png"),0,0,null);

    int i,j;
    for (i = 0 ; i < bi.getWidth() ; ++i)
    {
      for (j = 0 ; j < bi.getHeight() ; ++j)
      {
        if (bi.getRGB(i,j) != 0)
        {
          bi.setRGB(i,j,biwood.getRGB(i,j));
        }
      }
    }
    m_ttim = bi;
    m_FinalTTLocation = 
      getCellY(m_rulesengine.GetBlueprintSize()-1) - GiltHeadConstants.BLUEPRINT_VERTICAL_SEPARATION - th;

  }

  int m_CurTableTopLocation;
  int m_FinalTTLocation;

  private void drawOutlineString(Graphics g,Color forecolor,Color backcolor,String s,
                                 int x,int y)
  {
    g.setColor(backcolor);
    g.drawString(s,x+1,y);
    g.drawString(s,x-1,y);
    g.drawString(s,x,y+1);
    g.drawString(s,x,y-1);
    g.setColor(forecolor);
    g.drawString(s,x,y);
  }


  private void drawStatusString(Graphics g)
  {
    if (m_curScoring == null)
    {
      m_curScoring = m_rulesengine.GetScoringDescriptor();
      m_pausefinish = -1;
      
      if (m_curScoring == null)
      {
        return;
      }
      // if we get here, we're starting a new set of animations
      // (i.e. null to non-null)
      buildTabletopImage();
      m_CurTableTopLocation = 0 - m_ttim.getHeight(null);

      m_CurStatusLocation = GiltHeadConstants.STATUS_START_OFFSET;
    }
    
    // if we're here, we have a non-null m_curScoring.
    if (m_CurStatusLocation >= GiltHeadConstants.STATUS_END_OFFSET)
    {
      if (m_curScoring.m_isFinal == false)
      {
        if (m_pausefinish == -1)
        {
          m_pausefinish = System.currentTimeMillis() + m_curScoring.m_pauseSeconds * 1000;
        }
        else
        {
          if (m_pausefinish < System.currentTimeMillis())
          {
            m_curScoring = m_rulesengine.GetScoringDescriptor();
            m_pausefinish = -1;
      
            if (m_curScoring == null)
            {
              m_rulesengine.ResetBoard();
              return;
            }
            m_CurStatusLocation = GiltHeadConstants.STATUS_START_OFFSET;
          }
        }
      }
    }      

    // if we're here, we have a non-null m_curScoring with a valid location
    // if we get here, we're going to draw the text.

    // if we get here, we increment them.
    m_CurTableTopLocation += GiltHeadConstants.TABLE_TOP_VELOCITY;
    if (m_CurTableTopLocation > m_FinalTTLocation)
    {
      m_CurTableTopLocation = m_FinalTTLocation;
    }

    if (m_CurStatusLocation < GiltHeadConstants.STATUS_END_OFFSET)
    {
      m_CurStatusLocation += GiltHeadConstants.STATUS_VELOCITY;
    }






    // animate the tabletop
    g.drawImage(m_ttim,
                (GiltHeadConstants.SCREEN_WIDTH-m_ttim.getWidth(null)) / 2,
                m_CurTableTopLocation,
                null);


    g.setFont(new Font("Serif",Font.BOLD,50));
    g.setColor(Color.black);
    int swidth = g.getFontMetrics().stringWidth(m_curScoring.m_String);

    drawOutlineString(g,Color.black,Color.white,m_curScoring.m_String,
                      (GiltHeadConstants.SCREEN_WIDTH - swidth) / 2,
                      m_CurStatusLocation );

    if (m_curScoring.m_type == 1)
    {
      // columns:
      g.setColor(Color.white);
      int ulx = m_BlueprintClickAreas.get(m_curScoring.m_address).x-1;
      int uly = getCellY(m_rulesengine.GetBlueprintSize()-1)-1;
      g.drawRect(ulx,uly,
                 GiltHeadConstants.PIECE_WIDTH+2,
                 m_rulesengine.GetBlueprintSize() * GiltHeadConstants.PIECE_HEIGHT +
                 (m_rulesengine.GetBlueprintSize() - 1) * GiltHeadConstants.BLUEPRINT_VERTICAL_SEPARATION + 2);

      g.drawRect(ulx-1,uly-1,
                 GiltHeadConstants.PIECE_WIDTH+4,
                 m_rulesengine.GetBlueprintSize() * GiltHeadConstants.PIECE_HEIGHT +
                 (m_rulesengine.GetBlueprintSize() - 1) * GiltHeadConstants.BLUEPRINT_VERTICAL_SEPARATION + 4);
    }

    if (m_curScoring.m_type == 2)
    {
      int ulx1 = m_BlueprintClickAreas.get(0).x;
      int ulx2 = m_BlueprintClickAreas.get(2).x;
      int uly = getCellY(m_curScoring.m_address);
      int h = GiltHeadConstants.PIECE_HEIGHT;
      int w = GiltHeadConstants.PIECE_WIDTH*2 + GiltHeadConstants.BLUEPRINT_COLUMN2_INSET;

      g.setColor(Color.white);
      g.drawRect(ulx1-1,uly-1,w+2,h+2);
      g.drawRect(ulx1-2,uly-2,w+4,h+4);
      g.drawRect(ulx2-1,uly-1,w+2,h+2);
      g.drawRect(ulx2-2,uly-2,w+4,h+4);
    }
  }

  private int m_LastMouse = 0;
  private int m_MouseCount = 1;
  private int m_MouseEnd = 0;

  public void drawMouse(Graphics g)
  {
    Image pm;
    int wga = GiltHeadConstants.MOUSE_WIGGLE_AMPLITUDE;
    // sneak in/sneak out delta
    int dx = m_MouseCount;
    if (dx > m_MouseEnd/2)
    {
      dx = m_MouseEnd - m_MouseCount;
    }


    if (m_MouseCount < m_MouseEnd)
    {
      m_MouseCount++;
      switch(m_LastMouse)
      {
      case 1:
        pm = ImageManager.getImage("PirateMousie.png");

        g.drawImage(pm,
                    -GiltHeadConstants.MOUSESIDE_WIDTH+dx*2,
                    GiltHeadConstants.MOUSE_Y1 - pm.getHeight(null),
                    null);

        break;
      case 2:
        pm = ImageManager.getImage("PirateMousie2.png");
        g.drawImage(pm,
                    GiltHeadConstants.SCREEN_WIDTH - dx * 2,
                    GiltHeadConstants.MOUSE_Y2 - pm.getHeight(null),
                    null);
        break;
      case 3:
        Point mp = m_rulesengine.GetMousePoint();
        int mx;
        int my;

        if (mp == null)
        {
          pm = ImageManager.getImage("PirateMousie3.png");
          mx = GiltHeadConstants.MOUSE_X3 - pm.getWidth(null)/2;
          my = GiltHeadConstants.BLUEPRINT_HEIGHT;
          g.drawImage(pm,mx,my-dx*2,null);
        }
        else
        {
          pm = ImageManager.getImage("PirateMousie4.png");
          mx = m_BlueprintClickAreas.get(mp.x).x + GiltHeadConstants.PIECE_WIDTH/2 - GiltHeadConstants.MOUSEBUTT_NOSE_OFFSET_X;
          my = getCellY(mp.y) + GiltHeadConstants.PIECE_HEIGHT/2 - GiltHeadConstants.MOUSEBUTT_NOSE_OFFSET_Y;

          int wigfifth = m_MouseEnd / 5;
          int curfifth = m_MouseCount / wigfifth;

          if (curfifth < 5)
          {
            g.setFont(new Font("SansSerif",Font.PLAIN,12));
            g.setColor(Color.black);
            g.drawString("Nom!",mx+curfifth * 15+5,my-10-(curfifth%2)*10);
          }
          g.drawImage(pm,mx+(m_MouseCount % wga),my,null);
        }



        break;
      default:
      }
      return;
    }
    int curMouse = m_rulesengine.GetMouseLevel();
    if (curMouse != m_LastMouse)
    {
      m_LastMouse = curMouse;
      if (m_LastMouse != 0) 
      {
        m_MouseCount = 0;
        if (m_LastMouse == 1) m_MouseEnd = GiltHeadConstants.MOUSE_LEFT_WIGGLE_TIME;
        if (m_LastMouse == 2) m_MouseEnd = GiltHeadConstants.MOUSE_RIGHT_WIGGLE_TIME;
        if (m_LastMouse == 3) 
        {
          if (m_rulesengine.GetMousePoint() == null) m_MouseEnd = GiltHeadConstants.MOUSE_BOTTOM_WIGGLE_TIME;
          else m_MouseEnd = GiltHeadConstants.MOUSE_EAT_WIGGLE_TIME;
        }
      }

      if (curMouse == 3 && m_rulesengine.GetMousePoint() != null)
      {
        SoundManager.playSound("piRat_Nom.wav");
      }
    }
  }

  public void paint(Graphics g)
  {
    drawBlueprint(g);
    drawNumCompleted(g);
    drawStatusString(g);
    drawMouse(g);
    drawWorkBench(g);

    m_sb.paint(g);

    // must be last to be painted
    drawActivePiece(g);
  }


}
