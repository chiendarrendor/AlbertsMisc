import java.applet.Applet;
import java.awt.BorderLayout;
import java.awt.Panel;
import java.awt.CardLayout;

// this is the main applet for Gilthead.

public class GiltHeadApplet extends Applet 
{
  public void init()
  {
    // initialize my random number generator
    MyRand.Init();
    // this class knows about how to load images from disk, and
    // stores them by name
    ImageManager imgr = new ImageManager(this);

    // --- this next section preloads all images.

    // the WoodPieceFactory object knows about the wood piece 
    // images
    WoodPieceFactory.Initialize();
    // these are miscellaneous images
    imgr.addImage("PirateMousie.png");
    imgr.addImage("PirateMousie2.png");
    imgr.addImage("PirateMousie3.png");
    imgr.addImage("PirateMousie4.png");
    imgr.addImage("SushiWater.png");
    imgr.addImage("Workbench3.png");
    imgr.addImage("Blueprint.png");

    // scroll images.
    String[] scrolls = {"Blank","Booched","Poor","Fine","Good","Excellent","Incredible"};
    int i;
    for (i = 0 ; i < scrolls.length ; ++i)
    {
      imgr.addImage("Scroll_" + scrolls[i] + ".png");
    }

    // wait until they load (pretty fast since they are in the same jar.
    while(!imgr.allLoaded())
      ;

    System.out.println("All Images Loaded");

    // --- this section loads sounds
    SoundManager smgr = new SoundManager(this);
    smgr.addSound("piRat_Nom.wav");
    // wait until sounds load.
    while(!smgr.allSoundsLoaded())
      ;

    System.out.println("All Sounds Loaded");

    // the card layout is so that we can change from
    // menus to the game board 
    setLayout(new CardLayout());

    // the control panel embodies and manages all the other
    // panels of the game, drawn as cards onto 
    // the applet panel.
    ControlPanel cp = new ControlPanel(this);
    add(cp,"ControlPanel");
  }

  public void start()
  {
  }


  public void stop()
  {
  }

  public void destroy()
  {
  }
}
