class ThatsLife
{
  public static void main(String[] args)
  {
    if (args.length != 1)
    {
      System.out.println("bad command line: <results file>");
      System.exit(1);
    }

    ThatsLifeGame g = new ThatsLifeGame(args[0]);

    MyAnimationFrame frame = new MyAnimationFrame(new ThatsLifePanel(g),"That's Life");
    frame.pack();
    frame.setVisible(true);
    frame.start();
  }
}
