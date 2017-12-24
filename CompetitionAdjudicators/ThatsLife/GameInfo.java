
import java.io.*;
import java.util.regex.*;

class GameInfo
{
  private PlayerInfo playerA;
  private PlayerInfo playerB;
  private int movecount;

  private void HandleRecord(String record,PlayerInfo player) throws IOException
  {
    if (record.length() != 1 && record.length() != 2)
    {
      throw new IOException("bad record length: " + record);
    }
    char dir = record.charAt(0);
    if (dir != 'U' && dir != 'D' && dir != 'R' && dir != 'L' && dir != '-')
    {
      throw new IOException("bad record direction: " + record);
    }
    if (record.length() == 2)
    {
      if (record.charAt(1) != '*')
      {
        throw new IOException("bad record crash: " + record);
      }
    }
    
    player.AddMove(record.charAt(0));
    if (record.length() == 2)
    {
      player.SetCrashed();
    }
  }

  public GameInfo(String filename)
  {

    playerA = new PlayerInfo();
    playerB = new PlayerInfo();
    movecount = 0;

    try
    {
      BufferedReader input = new BufferedReader(new FileReader(filename));
      try
      {
        String line = null;
        boolean first = true;
        while(( line = input.readLine()) != null)
        {
          String[] cols = line.split(",");
          if (cols.length != 2)
          {
            throw new IOException("bad data file, not two columns");
          }

          if (first)
          {
            first = false;
            playerA.SetName(cols[0]);
            playerB.SetName(cols[1]);
            continue;
          }

          HandleRecord(cols[0],playerA);
          HandleRecord(cols[1],playerB);
          ++movecount;
        }
      }
      finally
      {
        input.close();
      }
    }
    catch (IOException ex)
    {
      ex.printStackTrace();
    }
  }

  public PlayerInfo GetPlayerA() { return playerA; }
  public PlayerInfo GetPlayerB() { return playerB; }
  public int GetMoveCount() { return movecount; }


}

