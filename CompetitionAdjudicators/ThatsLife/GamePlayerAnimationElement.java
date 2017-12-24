
import java.util.List;
import java.util.ArrayList;
import java.awt.Graphics;

class GamePlayerAnimationElement implements MyAnimationPanel.AnimationElement
{
    ThatsLifeGame gameInfo;
    AnimationExecutiveOfficer xo;
    int mi;

    public GamePlayerAnimationElement(ThatsLifeGame gi,AnimationExecutiveOfficer aeo)
    {
	gameInfo = gi;
	xo = aeo;
	mi = 0;
    }

    private interface AnimationItem
    {
	public void Start();
	public boolean IsStarted();
	public boolean IsDone();
    }

    private List<AnimationItem> items = null;

    private class DieItem implements AnimationItem
    {
	private int dieRoll;
	private int playerId;
	private boolean isStarted = false;
	public DieItem(int dr,int pid) { dieRoll = dr ; playerId = pid; isStarted = false; }
	public boolean IsStarted() { return isStarted; }
	public boolean IsDone() { return isStarted && xo.IsAnimationDone(); }
	public void Start()
	{
	    isStarted = true;
	    xo.Clear();
	    xo.RollDie(dieRoll,playerId);
	    
	}
    }

    private class MoveTokenItem implements AnimationItem
    {
	private int playerId;
	private int sourceTile;
	private int destTile;
	private boolean isStarted = false;
	public MoveTokenItem(int pid,int sTile,int dTile) { playerId = pid; sourceTile = sTile ; destTile = dTile; isStarted = false; }
	public boolean IsStarted() { return isStarted; }
	public boolean IsDone() { return isStarted && xo.IsAnimationDone(); }
	public void Start()
	{
	    isStarted = true;
	    xo.Clear();
	    xo.RemoveToken(playerId,sourceTile);
	    xo.MoveToken(playerId,sourceTile,destTile);
	}
    }

    private class PlaceTokenItem implements AnimationItem
    {
	private int playerId;
	private int sourceTile;
	private int destTile;
	private boolean isStarted = false;
	private ThatsLifeGame.Token mToken;
	public PlaceTokenItem(int pid,ThatsLifeGame.Token mt,int sTile,int dTile) 
	{ 
	    playerId = pid; 
	    mToken = mt;
	    sourceTile = sTile ; 
	    destTile = dTile; 
	}
	public boolean IsStarted() { return isStarted; }
	public boolean IsDone() { return isStarted && xo.IsAnimationDone(); }
	public void Start()
	{
	    isStarted = true;
	    xo.Clear();
	    xo.AddToken(playerId,destTile);

	    ThatsLifeGame.Tile sTile = null;
	    ThatsLifeGame.Tile dTile = null;
	    for (int i = 0 ; i < gameInfo.board.size() ; ++i)
	    {
		if (gameInfo.board.get(i).uid == sourceTile) sTile = gameInfo.board.get(i);
		if (gameInfo.board.get(i).uid == destTile) dTile = gameInfo.board.get(i);
	    }

	    sTile.tokens.remove(mToken);
	    dTile.tokens.add(mToken);
	}
    }

    private class TakeTileItem implements AnimationItem
    {
	private int playerId;
	private int sourceTile;
	private boolean isStarted = false;
	public TakeTileItem(int pid,int sTile) { playerId = pid; sourceTile = sTile; isStarted = false; }
	public boolean IsStarted() { return isStarted; }

	public boolean IsDone() 
	{ 
	    if (!isStarted) return false;
	    if (!xo.IsAnimationDone()) return false;

	    for (int i = 0 ; i < gameInfo.board.size() ; ++i)
	    {
		ThatsLifeGame.Tile t = gameInfo.board.get(i);
		if (t.uid == sourceTile)
		{
		    gameInfo.board.remove(i);
		    gameInfo.players.get(playerId).claimedTiles.add(t);
		    break;
		}
	    }
	    return true;
	}

	public void Start()
	{
	    isStarted = true;
	    xo.Clear();
	    xo.ExitTile(sourceTile,playerId);
	    int tloc;

	    for (tloc = 0 ; tloc < gameInfo.board.size() ; ++tloc)
	    {
		if (gameInfo.board.get(tloc).uid == sourceTile) break;
	    }

	    if (tloc*2 < gameInfo.board.size())
	    {
		for (int i = 0 ; i < tloc ; ++i)
		{
		    xo.ShiftTile(gameInfo.board.get(i).uid,true);
		}
	    }
	    else
	    {
		for (int i = tloc + 1 ; i < gameInfo.board.size() ; ++i)
		{
		    xo.ShiftTile(gameInfo.board.get(i).uid,false);
		}
	    }
	}
    }


    // for each move
    //   Clear()
    //   RollDie()
    //   IsAnimationDone()

    //   Clear()
    //   RemoveToken() 
    //   MoveToken
    //   IsAnimationDone

    //   Clear()
    //   AddToken()
    //     (remove token from board)
    //     (add token to board)
    //   IsAnimationDone

    //   if original location is non-empty or is Start continue
    //   Clear
    //   ExitTile()
    //   if removing tile is after the halfway point ShiftTile all later tiles back
    //   otherwise ShiftTile all earlier tiles forward

    //   IsAnimationDone
    //     (remove tile from board)
    //     (add tile to player list) (doesn't need IsAnimationDone)

    private void FillItems(ThatsLifeGame.Turn turn)
    {
	items = new ArrayList<AnimationItem>();

	items.add(new DieItem(turn.dieroll,turn.actor.index));

	ThatsLifeGame.Tile sTile = null;
	int sindex;

	for (sindex = 0 ; sindex < gameInfo.board.size() ; ++sindex)
	{
	    sTile = gameInfo.board.get(sindex);
	    int j;
	    for (j = 0 ; j < sTile.tokens.size() ; ++j)
	    {
		if (turn.token == sTile.tokens.get(j)) break;
	    }
	    if (j < sTile.tokens.size()) break;
	}

	int tindex = sindex + turn.dieroll;
	if (tindex >= gameInfo.board.size()) tindex = gameInfo.board.size()-1;
	ThatsLifeGame.Tile dTile = gameInfo.board.get(tindex);
	
	int tokOwner = turn.token.owner.isGuardian ? 6 : turn.token.owner.index;

	items.add(new MoveTokenItem(tokOwner,sTile.uid,dTile.uid));
	items.add(new PlaceTokenItem(tokOwner,turn.token,sTile.uid,dTile.uid));

	if (sTile.tokens.size() == 1 && sindex != 0)
	{
	    items.add(new TakeTileItem(turn.actor.index,sTile.uid));
	}
    }

    public void paint(Graphics g)
    {
	if (mi >= gameInfo.plays.size()) return;
	ThatsLifeGame.Turn turn = gameInfo.plays.get(mi);
	
	if (items == null)
	{
	    FillItems(turn);
	}
	
	// iterate until we find one that needs time to complete.
	while(items.size() > 0)
	{
	    AnimationItem item = items.get(0);
	    if (!item.IsStarted()) item.Start();
	    if (!item.IsDone()) return;
	    // if we get here, the first item on the list is both started and done
	    // remove it.
	    items.remove(0);
	}

	// if we get here, that means that we've emptied an items list.
	// wait for another paint cycle to start a new turn.
	items = null;
	++mi;
    }
}
