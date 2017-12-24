
import java.util.Vector;

class PlayerInfo
{
  private String name;
  private Vector<Character> moves;
  private boolean crashed;

  public PlayerInfo()
  {
    moves = new Vector<Character>();
    crashed = false;
  }

  public void SetName(String name) { this.name = name; }
  public void SetCrashed() { this.crashed = true; }
  public void AddMove(char move) { this.moves.add(move); }

  public String GetName() { return this.name; }
  public boolean Crashed() { return this.crashed; }
  public char GetMove(int index) { return moves.get(index); } }
