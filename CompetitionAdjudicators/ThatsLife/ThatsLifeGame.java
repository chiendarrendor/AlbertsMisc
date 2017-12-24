
import java.io.*;
import java.util.regex.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

class ThatsLifeGame
{
    public class Player
    {
	public boolean isGuardian = false;
	public int index;
	public String name;
	public List<Tile> claimedTiles = new ArrayList<Tile>();

	public int Score()
	{
	    List<Integer> negScores = new ArrayList<Integer>();
	    int score = 0;
	    int negcount = 0;
	    for (int i = 0 ; i < claimedTiles.size() ; ++i)
	    {
		Tile t = claimedTiles.get(i);
		switch(t.type)
		{
		case POSITIVE: score += t.value; break;
		case NEGATOR: ++negcount ; break;
		case NEGATIVE: negScores.add(new Integer(t.value));
		}
	    }
	    Collections.sort(negScores);

	    int i;
	    for (i = 0 ; i < negScores.size() - negcount ; ++i)
	    {
		score -= negScores.get(i).intValue();
	    }

	    for ( ; i < negScores.size() ; ++i)
	    {
		score += negScores.get(i).intValue();
	    }

	    return score;
	}
    };

    public class Token
    {
	public int id;
	public Player owner;
	public Token(int i,Player o) { id = i ; owner = o; }
    };

    public enum TileType { START,POSITIVE,NEGATIVE,NEGATOR,END };
    public class Tile
    {
	public TileType type;
	public int value;
	public int uid;
	public List<Token> tokens = new ArrayList<Token>();
	public Tile(TileType t,int v,int u) { type = t ; value = v; uid = u; }
	public String toString()
	{
	    switch(type)
	    {
	    case START: return "Start";
	    case END: return "End";
	    case NEGATOR: return "+";
	    case POSITIVE: return "+" + value;
	    case NEGATIVE: return "-" + value;
	    default: return "?";
	    }
	}
    };

    public class Turn
    {
	public Player actor;
	public int dieroll;
	public Token token;
    };


    public List<Player> players = new ArrayList<Player>();
    public Player guardian;
    public List<Tile> board = new ArrayList<Tile>();
    public List<Turn> plays = new ArrayList<Turn>();

    public void ShowState()
    {
	int i;
	System.out.println("Players:");
	for (i = 0 ; i < players.size() ; ++i)
	{
	    System.out.println("Player: " + players.get(i).name);
	    for (int j = 0 ; j < players.get(i).claimedTiles.size() ; ++j)
	    {
		System.out.println("  " + players.get(i).claimedTiles.get(j).toString());
	    }
	}
	System.out.println("Board:");
	for (i = 0 ; i < board.size() ; ++i)
	{
	    System.out.println(board.get(i).toString());
	    for (int j = 0 ; j < board.get(i).tokens.size() ; ++j)
	    {
		System.out.println("  " + board.get(i).tokens.get(j).owner.name + "_" +
				   board.get(i).tokens.get(j).id);
	    }
	}
	for (i = 0 ; i < plays.size() ; ++i)
	{
	    Turn turn = plays.get(i);
	    String tokstr;
	    if (turn.token != null)
	    {
		tokstr = " Piece owner: " + turn.token.owner.name + " Id: " + turn.token.id;
	    }
	    else
	    {
		tokstr = " null token";
	    }

	    System.out.println("Player: " + turn.actor.name + " roll: " + turn.dieroll + tokstr);
	}
    }

    public ThatsLifeGame(String filename)
    {
	guardian = new Player();
	guardian.isGuardian = true;
	guardian.index = -1;
	guardian.name = "Guardian";

	int linenum = 0;
	String line = null;
	BufferedReader input = null;
	int tid = 0;
	try
	{
	    input = new BufferedReader(new FileReader(filename));
	    while((line = input.readLine()) != null)
	    {
		++linenum;
		String[] cols = line.split(",");
		if (linenum == 1)
		{
		    for (int i = 0 ; i < cols.length ; ++i)
		    {
			Player newP = new Player();
			newP.index = i;
			newP.name = cols[i];
			players.add(newP);
		    }
		}
		else if (linenum == 2)
		{
		    for(int i = 0 ; i < cols.length ; ++i)
		    {
			String tileid = cols[i];

			Pattern pattern = Pattern.compile("^([^(]+)(?:\\(guardian_(\\d+)\\))?$");
			Matcher matcher = pattern.matcher(tileid);
			if (!matcher.matches())
			{
			    throw new IOException("name fails to regex match");
			}

			tileid = matcher.group(1);
			int guardid = -1;

			if (matcher.group(2) != null && matcher.group(2).length() > 0)
			{
			    guardid = Integer.parseInt(matcher.group(2));
			}

			Tile t;
			if (tileid.equals("start")) { t = new Tile(TileType.START,0,tid); }
			else if (tileid.equals("end")) { t = new Tile(TileType.END,0,tid); }
			else if (tileid.contains("negator")) { t = new Tile(TileType.NEGATOR,0,tid); }
			else
			{
			    String[] parts = tileid.split("_");
			    TileType type = parts[0].equals("plus") ? TileType.POSITIVE : TileType.NEGATIVE;
			    int value = Integer.parseInt(parts[1]);
			    t = new Tile(type,value,tid);
			}
			++tid;

			if (guardid != -1)
			{
			    Token tok = new Token(guardid,guardian);
			    t.tokens.add(tok);
			}

			board.add(t);
		    }

		    for (int i =  0 ; i < players.size() ; ++i)
		    {
			Player curp = players.get(i);
			for (int j = 0 ; j < 3 ; ++j)
			{
			    Token newt = new Token(j,curp);
			    board.get(0).tokens.add(newt);
			}
		    }

		}
		else
		{
		    Turn turn = new Turn();
		    int i,j;

		    for (i = 0 ; i < players.size() ; ++i)
		    {
			turn.actor = players.get(i);
			if (turn.actor.name.equals(cols[0])) break;
		    }
		    turn.dieroll = Integer.parseInt(cols[1]);

		    Player searchp = (cols[2].equals("token")) ? turn.actor : guardian;
		    int idx = Integer.parseInt(cols[3]);

		    for (i = 0 ; i < board.size() ; ++i)
		    {
			for (j = 0 ; j < board.get(i).tokens.size() ; ++j)
			{
			    Token searcht = board.get(i).tokens.get(j);
			    if (searcht.owner == searchp && searcht.id == idx) 
			    {
				turn.token = searcht;
				break;
			    }
			}
		    }

		    plays.add(turn);
		}
	    }
	}
	catch (IOException ex)
	{
	    ex.printStackTrace();
	}
    }
}
    
    