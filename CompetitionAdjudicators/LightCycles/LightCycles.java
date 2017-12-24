
class LightCycles
{
  public static void main(String[] args)
  {
    if (args.length != 2)
    {
      System.out.println("bad command line: <results file> <board size>");
      System.exit(1);
    }

    GameInfo g = new GameInfo(args[0]);
    int boardsize = Integer.parseInt(args[1]);

    int mc = g.GetMoveCount();

    LightCycleFrame frame = new LightCycleFrame(g,boardsize);
    frame.pack();
    frame.setVisible(true);
    frame.start();
  }
}
