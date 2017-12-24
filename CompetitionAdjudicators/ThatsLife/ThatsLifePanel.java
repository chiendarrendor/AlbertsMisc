
import java.util.Random;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.awt.*;

class ThatsLifePanel extends MyAnimationPanel 
{
    private static final int WIDTH = 800;
    private static final int HEIGHT = 800;
    private static final int INSET = 25;
    private static final int CYCLEMILLIS = 15;
    
    private Color[] playerColors = new Color[] { Color.white,Color.pink,Color.cyan,
						 Color.orange,Color.yellow,Color.gray} ;
    private Color guardColor = new Color(139,69,19);
    private Color plusColor = Color.green;
    private Color minusColor = Color.red;
    private Color negColor = new Color(222,184,135);
    private Color termColor = Color.blue;

    private int tileRadius = 44;
    private int tileCorner = 22;
    private int tokenDiam = 22;

    private class OctElement implements AnimationElement,TerminatingAnimation
    {
	Color color;
	String title;

	int tileId;
	int locId;


	int radius = tileRadius;
	int offset = tileCorner;

	int cdiam = tokenDiam;

	int[] pcx = {-radius*5/10,        0,+radius*5/10,+radius/2,+radius*5/10,        0,-radius*5/10};
	int[] pcy = {-radius*5/10,-radius/2,-radius*5/10,        0,+radius*5/10,+radius/2,+radius*5/10};

	int[] tcounter = {0,0,0,0,0,0,0};
	boolean removed = false;

	private PathMaker pm;
	private int animindex;

	public int GetLocId() { return locId; }
	public void Remove() 
	{
	    removed = true;
	    pm = new PathMaker(tlx[locId],tly[locId],tlx[finalTile],tly[finalTile],true,5);
	    locId = finalTile;
	}
	public void SetNewLoc(boolean goDownstream)
	{
	    int newLocId = locId + (goDownstream ? 1 : -1);
	    pm = new PathMaker(tlx[locId],tly[locId],tlx[newLocId],tly[newLocId],false,tileRadius*2);
	    locId = newLocId;
	}

	public boolean IsAnimationDone()
	{
	    return (pm.animindex == pm.x.length-1);
	}

	public void AlterCounter(int playerId,int amount)
	{
	    tcounter[playerId] += amount;
	}

	OctElement(String s,Color c,int[] tc,int id)
	{
	    pm = new PathMaker(tlx[id],tly[id],tlx[id],tly[id],false,1);
	    color = c;
	    title = s;
	    tileId = id;
	    locId = id;

	    for (int i = 0 ; i < 7 ; ++i) { tcounter[i] = tc[i]; }
	}

	public void paint(Graphics g)
	{
	    if (removed && IsAnimationDone()) return;

	    int curx = pm.x[pm.animindex];
	    int cury = pm.y[pm.animindex];

	    int[] xPoints = new int[8];
	    int[] yPoints = new int[8];
	    xPoints[0] = curx+offset; yPoints[0] = cury-radius;
	    xPoints[1] = curx+radius; yPoints[1] = cury-offset;
	    xPoints[2] = curx+radius; yPoints[2] = cury+offset;
	    xPoints[3] = curx+offset; yPoints[3] = cury+radius;
	    xPoints[4] = curx-offset; yPoints[4] = cury+radius;
	    xPoints[5] = curx-radius; yPoints[5] = cury+offset;
	    xPoints[6] = curx-radius; yPoints[6] = cury-offset;
	    xPoints[7] = curx-offset; yPoints[7] = cury-radius;

	    g.setColor(color);
	    g.fillPolygon(xPoints,yPoints,8);

	    for (int i = 0 ; i < 7 ; ++i)
	    {
		if (tcounter[i] == 0) continue;
		if (i!=6) g.setColor(playerColors[i]);
		else g.setColor(guardColor);
		g.fillOval(curx+pcx[i]-(cdiam/2),cury+pcy[i]-(cdiam/2),cdiam,cdiam);
		g.setColor(Color.black);
		g.setFont(g.getFont().deriveFont(Font.BOLD));
		String count = "" + tcounter[i];
		int h = g.getFontMetrics().getHeight();
		int w = g.getFontMetrics().stringWidth(count);
		g.drawString(count,curx+pcx[i]-w/2,cury+pcy[i]+h/2-3);
	    }

	    g.setColor(Color.white);
	    g.setFont(g.getFont().deriveFont(Font.BOLD));
	    int sw = g.getFontMetrics().stringWidth(title);
	    g.drawString(title,curx-sw,cury+7);

	    if (pm.animindex < pm.x.length-1) ++pm.animindex;
	}

	public String toString() { return "Oct Element"; }
    }

    private class PlayerDisplayAnimationElement implements AnimationElement
    {
	int toffset = 25;
	int loffset = 30;
	int cdiameter = tokenDiam;
	int hsepar = 10;
	int vsepar = 25;
	

	public void paint(Graphics g)
	{
	    for (int i = 0 ; i < gameInfo.players.size() ; ++i)
	    {
		g.setColor(playerColors[i]);
		g.fillOval(loffset,toffset+i*vsepar-cdiameter,cdiameter,cdiameter);
		g.setFont(g.getFont().deriveFont(Font.BOLD));

		ThatsLifeGame.Player curP = gameInfo.players.get(i);
		String stat = curP.name + "(";

		for (int j = 0 ; j < curP.claimedTiles.size() ; ++j)
		{
		    if (j > 0) stat += ",";
		    stat += curP.claimedTiles.get(j).toString();
		}


		stat += " = " + curP.Score();
		stat += ")";

		g.drawString(stat,loffset+cdiameter+hsepar,toffset+i*vsepar);
	    }
	}

	public String toString() { return "Player Display"; }
    }
		
    private OctElement BuildOctElement(ThatsLifeGame.Tile tile,int tloc)
    {
	String disp = tile.toString();
	Color col;
	switch(tile.type)
	{
	case START: col = termColor; break;
	case END: col = termColor; break;
	case NEGATOR: col = negColor ; break;
	case POSITIVE: col = plusColor; break;
	case NEGATIVE: col = minusColor ; break;
	default: col = termColor ; break;
	}

	int[] tcounter = {0,0,0,0,0,0,0};
	for (int i = 0 ; i < tile.tokens.size() ; ++i)
	{
	    ThatsLifeGame.Token t = tile.tokens.get(i);
	    if (t.owner.isGuardian) ++tcounter[6];
	    else ++tcounter[t.owner.index];
	}

	return new OctElement(disp,col,tcounter,tloc);
    }

    private interface TerminatingAnimation
    {
	public boolean IsAnimationDone();
    }

    private class ThatsLifeXO implements AnimationExecutiveOfficer
    {
	private List<TerminatingAnimation> pendings = null;
	private DieAnimationElement dim = null;
	private TokenAnimationElement tam = null;
	private Map<Integer,OctElement> tiles = new HashMap<Integer,OctElement>();

	public void Clear() {pendings = new ArrayList<TerminatingAnimation>(); }
	public void ConfigureDieAnimationElement(DieAnimationElement el) { dim = el; }
	public void ConfigureTokenAnimationElement(TokenAnimationElement el) { tam = el; }
	public void ConfigureTileElement(OctElement oe,int uid)
	{
	    tiles.put(new Integer(uid),oe);
	}

	public boolean IsAnimationDone() 
	{
	    for (int i = 0; i < pendings.size() ; ++i)
	    {
		if (!pendings.get(i).IsAnimationDone()) return false;
	    }
	    return true;
	}

	public void RemoveToken(int playerIndex,int tileId) 
	{
	    tiles.get(new Integer(tileId)).AlterCounter(playerIndex,-1);
	}

	public void AddToken(int playerIndex,int tileId) 
	{
	    tiles.get(new Integer(tileId)).AlterCounter(playerIndex,1);
	}

	public void MoveToken(int playerIndex,int oldTileId,int newTileId) 
	{
	    tam.StartAnimation(playerIndex,
			       tiles.get(new Integer(oldTileId)).GetLocId(),
			       tiles.get(new Integer(newTileId)).GetLocId());
	    pendings.add(tam);
	}
	public void ShiftTile(int tileId,boolean goDownstream) 
	{
	    OctElement oe = tiles.get(new Integer(tileId));
	    oe.SetNewLoc(goDownstream);
	    pendings.add(oe);
	}
	public void ExitTile(int tileId,int owningPlayerId) 
	{
	    OctElement oe = tiles.get(new Integer(tileId));
	    oe.Remove();
	    pendings.add(oe);
	}
	public void RollDie(int roll,int playerId) 
	{
	    pendings.add(dim);
	    dim.StartAnimation(playerId,roll);
	}
    }

    private class PathMaker
    {
	public int[] x;
	public int[] y;
	public int animindex = 0;
	public PathMaker(int sx,int sy,int ex,int ey,boolean isLength,int lengthorcount)
	{
	    int pcount;
	    if (isLength)
	    {
		double d = Math.sqrt(Math.pow(ex-sx,2.0) + 
				     Math.pow(ey-sy,2.0));
		pcount = (int)Math.round(d / lengthorcount);
	    }
	    else
	    {
		pcount = lengthorcount;
	    }

	    x = new int[pcount];
	    y = new int[pcount];
	    for (int i = 0 ; i < pcount ; ++i)
	    {
		x[i] = (int)Math.round((double)sx + (double)(ex-sx)/(double)pcount * (double)i);
		y[i] = (int)Math.round((double)sy + (double)(ey-sy)/(double)pcount * (double)i);
	    }
	}
    }



    private class TokenAnimationElement implements AnimationElement, TerminatingAnimation
    {
	private int dsize = tokenDiam;
	private boolean animating = false;
	private int playerId;
	private PathMaker pm;

	public void StartAnimation(int pid,int sourcetid,int desttid)
	{
	    animating = true;
	    playerId = pid;
	    pm = new PathMaker(tlx[sourcetid],tly[sourcetid],tlx[desttid],tly[desttid],true,3);
	}

	public void paint(Graphics g)
	{
	    if (!animating) return;

	    int curx = pm.x[pm.animindex];
	    int cury = pm.y[pm.animindex];

	    g.setColor(playerId == 6 ? guardColor : playerColors[playerId]);
	    g.fillOval(curx-dsize/2,cury-dsize/2,dsize,dsize);

	    // adjust curx and cury
	    ++pm.animindex;
	    if (pm.animindex == pm.x.length) animating = false;
	}
	public boolean IsAnimationDone() { return !animating; }
    }



    private class DieAnimationElement implements AnimationElement, TerminatingAnimation
    {
	private int dsize = tokenDiam;
	private int loffset = 5;
	private int toffset = 2;
	private int vsep = 25;
	private int numcels = 10;

	private int roll;
	private int playerId;
	private int celcount = -1;
	private Random rand = new Random();

        public void StartAnimation(int p,int r)
	{
	    roll = r;
	    playerId = p;
	    celcount = 0;
	}

	public boolean IsAnimationDone()
	{
	    return celcount >= numcels;
	}


	public void paint(Graphics g)
	{
	    if (celcount == -1) return;
	    else if (celcount >= numcels) DrawDie(g,playerId,roll);
	    else
	    {
		DrawDie(g,playerId,rand.nextInt(6)+1);
		++celcount;
	    }
	}

	private void DrawDie(Graphics g,int playerId,int roll)
	{
	    int ulx = loffset;
	    int uly = toffset+vsep*playerId;
	    int size = (dsize+1)/ 5 ;

	    g.setColor(Color.white);
	    g.drawRoundRect(ulx,uly,dsize,dsize,5,5);

	    if (roll == 4 || roll == 5 || roll == 6)
	    {
		g.fillOval(ulx+((dsize+1)/4)-size/2,uly+((dsize+1)/4)-size/2,size,size);
		g.fillOval(ulx+((dsize+1)*3/4)-size/2,uly+((dsize+1)*3/4)-size/2,size,size);
	    }

	    if (roll == 6)
	    {
		g.fillOval(ulx+((dsize+1)/4)-size/2,uly+((dsize+1)/2)-size/2,size,size);
		g.fillOval(ulx+((dsize+1)*3/4)-size/2,uly+((dsize+1)/2)-size/2,size,size);
	    }
	    
	    if (roll == 2 || roll == 3 || roll == 4 || roll == 5 || roll == 6)
	    {
		g.fillOval(ulx+((dsize+1)/4)-size/2,uly+((dsize+1)*3/4)-size/2,size,size);
		g.fillOval(ulx+((dsize+1)*3/4)-size/2,uly+((dsize+1)/4)-size/2,size,size);
	    }
	    
	    if (roll == 1 || roll == 3 || roll == 5)
		g.fillOval(ulx+((dsize+1)/2)-size/2,uly+((dsize+1)/2)-size/2,size,size);


	    

	}
	
    }
	    
    private int tlx[];
    private int tly[];
    private int finalTile;

    private void CalculateTileCenters()
    {
	int ccx = tileRadius+5;
	int ccy = 200+5;
	int dir = 0; // 0 = L, 1 = DL, 2 = DR, 3 = R
	int hcount = 0;

	tlx = new int[gameInfo.board.size()+1];
	tly = new int[gameInfo.board.size()+1];

	int i;
	for (i = 0 ; i < gameInfo.board.size() ; ++i)
	{
	    tlx[i] = ccx;
	    tly[i] = ccy;
	    hcount++;

	    switch(dir)
	    {
	    case 0: 
		if (hcount < 7)
		{
		    ccx += tileRadius * 2 + 1;
		}
		else
		{
		    dir = 1;
		    ccx += tileRadius * 2 - tileCorner + 1;
		    ccy += tileRadius * 2 - tileCorner + 1;
		}
		break;
	    case 1:
		dir = 2;
		ccx -= tileRadius * 2 - tileCorner + 1;
		ccy += tileRadius * 2 - tileCorner + 1;
		hcount = 0;
		break;
	    case 2:
		dir = 3;
		ccx -= tileRadius * 2 + 1;
		break;
	    case 3:
		if (hcount < 6)
		{
		    ccx -= tileRadius * 2 + 1;
		}
		else
		{
		    dir = 4;
		    ccx -= tileRadius * 2 - tileCorner + 1;
		    ccy += tileRadius * 2 - tileCorner + 1;
		}		    
		break;
	    case 4:
		dir = 5;
		ccx += tileRadius * 2 - tileCorner + 1;
		ccy += tileRadius * 2 - tileCorner + 1;
		hcount = 1;
		break;
	    case 5:
		dir = 0;
		ccx += tileRadius * 2 + 1;
		break;

	    default:
		System.out.println("how did we get here?");
		
	    }
	}
	tlx[i] = 50;
	tly[i] = 50;
	finalTile = i;
    }




    private ThatsLifeXO xo = new ThatsLifeXO();
    ThatsLifeGame gameInfo;
    public ThatsLifePanel(ThatsLifeGame i_gameInfo)
    {
	super(WIDTH,HEIGHT,CYCLEMILLIS);
	gameInfo = i_gameInfo;
	CalculateTileCenters();

	setBackground(Color.black);

	AddAnimationElement(new GamePlayerAnimationElement(gameInfo,xo));
	DieAnimationElement dim = new DieAnimationElement();
	AddAnimationElement(dim);
	xo.ConfigureDieAnimationElement(dim);
	AddAnimationElement(new PlayerDisplayAnimationElement());

	for (int i = 0 ; i < gameInfo.board.size() ; ++i)
	{
	    OctElement oe = BuildOctElement(gameInfo.board.get(i),i);
	    xo.ConfigureTileElement(oe,gameInfo.board.get(i).uid);
	    AddAnimationElement(oe);
	}

	TokenAnimationElement tam = new TokenAnimationElement();
	AddAnimationElement(tam);
	xo.ConfigureTokenAnimationElement(tam);
    }
}
