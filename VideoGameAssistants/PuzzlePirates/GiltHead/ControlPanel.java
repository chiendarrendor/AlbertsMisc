import java.awt.FlowLayout;
import java.awt.Panel;
import java.awt.Button;
import java.awt.Choice;
import javax.swing.BoxLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.CardLayout;
import java.awt.BorderLayout;
import java.awt.Label;

// this class, when instanciated, attaches two panels (cards)
// (one of which is itself) to the parent panel
// the first of which 'Start Panel' has three buttons:
// greenie game     normal game     Define custom parameters
// and the second of which 'ControlPanel' has a set of options Choice objects
// and a 'start game' button at the bottom

// This object is the action listener for all four buttons.

// the 'define custom parameters' button, when pressed,
// switches the active 'card' of the parent panel to the
// 'Control Panel', making visible all the Choice objects

// the 'Greenie Game' button sets the Choice objects to
// the values appropriate to the greenie game, while
// the 'Normal Game' button sets the Choice objects
// to the values appropriate for the normal game.

// in both of those cases, as well as the 'Start Game'
// button, the selected item in each choice object
// is used to create the 'policy' objects and
// arguments for the game itself, embodied in the
// GiltHeadEngine object, which draws itself on a panel
// added as a card panel 'MainPanel' to the applet panel.
// Additionally, another panel is created and added as a
// card 'Pause Panel' with a single button 'Resume Game'
// the GiltHeadEngine object is the Action Listener for
// that button.

// optionally, based on one of the Choice objects, 
// a WoodPieceMenu is added as the 'Wood Piece Panel' card.

// finally, the 'MainPanel' card is selected.

// The policy objects are (generally) small snippets of code
// that are used (generally) by the RulesEngine code
// to embody various rule alternatives we wanted.
// see the individual files for more information.


public class ControlPanel extends Panel implements ActionListener
{
  Button m_gobutton;
  Button m_easybutton;
  Button m_hardbutton;
  Button m_custombutton;
  Choice m_color;
  Choice m_shape;
  Choice m_mouse;
  Choice m_mousespeed;
  Choice m_matching;
  Choice m_numbp;
  Choice m_riverspeed;
  Choice m_debugmode;

  Panel m_mainpanel;
  Panel m_startpanel;
  
  public ControlPanel(Panel i_mainpanel)
  {
    m_mainpanel = i_mainpanel;

    setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));

    add(new Label("Which Colors To Use:"));
    m_color = new Choice();
    m_color.add("Beginner Color Set");
    m_color.add("Intermediate Color Set");
    m_color.add("Advanced Color Set");
    add(m_color);

    add(new Label("Which Shapes To Use:"));
    add(new Label("(Including Cedar Gilthead/Knot 'Shapes')"));
    m_shape = new Choice();
    m_shape.add("Beginner Shape Set");
    m_shape.add("Full Shape Set");
    m_shape.add("Full Shape Set w/ bonuses");
    m_shape.add("Full Shape Set w/ bonuses and Knots");
    m_shape.add("Full Shape Set w/ Knots");
    add(m_shape);

    add(new Label("What does the piRat eat on piRat incursion #3?"));
    add(new Label("(Including no eating at all (for testing))"));
    m_mouse = new Choice();
    m_mouse.add("piRat Eats Random Heaviest Piece");
    m_mouse.add("piRat Eats a Completely Random Piece");
    m_mouse.add("piRat Doesn't eat (Really _Really_ easy)");
    add(m_mouse);

    add(new Label("How long (in seconds) for piRat incursion #1,#2,#3"));
    m_mousespeed = new Choice();
    m_mousespeed.add("15+15+15 = 45 (Very Easy)");
    m_mousespeed.add("10+10+10 = 30 (Easier)");
    m_mousespeed.add("13+7+5   = 25 (Normal)");
    m_mousespeed.add("10+5+5   = 20 (Harder)");
    m_mousespeed.add("5+5+5    = 15 (Very Hard)");
    add(m_mousespeed);

    add(new Label("Whether or not to use Shape Targets"));
    m_matching = new Choice();
    m_matching.add("No");
    m_matching.add("Yes");
    add(m_matching);
    
    add(new Label("How many boards constitute a full game?"));
    m_numbp = new Choice();
    m_numbp.add("1 Blueprint");
    m_numbp.add("2 Blueprints");
    m_numbp.add("3 Blueprints");
    m_numbp.add("4 Blueprints");
    m_numbp.add("5 Blueprints");
    m_numbp.add("6 Blueprints");
    add(m_numbp);

    add(new Label("How Fast should the river flow?"));
    m_riverspeed = new Choice();
    m_riverspeed.add("1 (Normal)");
    m_riverspeed.add("2 (Faster)");
    m_riverspeed.add("3");
    m_riverspeed.add("4");
    m_riverspeed.add("5 (Crazy Fast)");
    add(m_riverspeed);

    add(new Label("Debug Mode:"));
    m_debugmode = new Choice();
    m_debugmode.add("Off");
    m_debugmode.add("On (right click on piece in river to alter piece)");
    add(m_debugmode);

    m_gobutton = new Button("Start Game");
    add(m_gobutton);
    m_gobutton.addActionListener(this);

    SelectNormalDifficulty();
    MakeStartPage();
  }

  public void MakeStartPage()
  {
    Panel m_startpanel = new Panel();
    m_mainpanel.add(m_startpanel,"Start Panel");

    m_startpanel.setLayout(new FlowLayout());

    m_easybutton = new Button("Greenie Game");
    m_startpanel.add(m_easybutton);
    m_easybutton.addActionListener(this);

    m_hardbutton = new Button("Normal Game");
    m_startpanel.add(m_hardbutton);
    m_hardbutton.addActionListener(this);

    m_custombutton = new Button("Define Custom Parameters");
    m_startpanel.add(m_custombutton);
    m_custombutton.addActionListener(this);
  }


  private void SelectNormalDifficulty()
  {
    m_color.select(2);
    m_shape.select(3);
    m_mouse.select(1);
    m_mousespeed.select(2);
    m_matching.select(1);
    m_numbp.select(2);
    m_riverspeed.select(1);
    m_debugmode.select(0);
  }
  
  private void SelectEasyDifficulty()
  {
    m_color.select(0);
    m_shape.select(0);
    m_mouse.select(0);
    m_mousespeed.select(0);
    m_matching.select(0);
    m_numbp.select(2);
    m_riverspeed.select(0);
    m_debugmode.select(0);
  }



  public void actionPerformed(ActionEvent e)
  {
    CardLayout clayout = (CardLayout)m_mainpanel.getLayout();

    if (e.getSource() == m_custombutton)
    {
      clayout.show(m_mainpanel,"ControlPanel");
      return;
    }

    if (e.getSource() == m_easybutton)
    {
      SelectEasyDifficulty();
    }

    if (e.getSource() == m_hardbutton)
    {
      SelectNormalDifficulty();
    }

    FactoryColorInterface fci;
    switch(m_color.getSelectedIndex())
    {
    case 0: fci = new BeginnerFactoryColor(); break;
    case 1: fci = new IntermediateFactoryColor(); break;
    case 2:
    default: fci = new FullFactoryColor(); break;
    }

    FactoryShapeInterface fsi;
    switch(m_shape.getSelectedIndex())
    {
    case 0: fsi = new BeginnerFactoryShape(); break;
    case 1: fsi = new FullFactoryShape(); break;
    case 2: fsi = new FullBonusFactoryShape(); break;
    case 3: fsi = new FullAllFactoryShape(); break;
    case 4:
    default: fsi = new FullKnotFactoryShape(); break;
    }

 
    WoodPieceFactoryPolicyInterface wpfpi = new GenericWoodPieceFactoryPolicy(fci,fsi);
    GameStartPolicyInterface gspi = new BasicGameStartPolicy(3,6);
    WeighingPolicyInterface wpi = new BasicWeighingPolicy();
    ScoringPolicyInterface spi = new BasicScoringPolicy();
    GameEndPolicyInterface gepi = new BasicGameEndPolicy();
    
    MousePolicyInterface mpi;
    switch(m_mouse.getSelectedIndex())
    {
    case 0:
      mpi = new HeaviestMousePolicy();
      break;
    case 1:
      mpi = new RandomMousePolicy();
      break;
    default:
      mpi = new NoOpMousePolicy();
      break;
    }

    MouseSpeedPolicyInterface mousespeed;
    switch(m_mousespeed.getSelectedIndex())
    {
    case 0: mousespeed = new MouseSpeedPolicy(15,15,15); break;
    case 1: mousespeed = new MouseSpeedPolicy(10,10,10); break;
    case 2: mousespeed = new MouseSpeedPolicy(13,7,5); break;
    case 3: mousespeed = new MouseSpeedPolicy(10,5,5); break;
    case 4:
    default: mousespeed = new MouseSpeedPolicy(5,5,5); break;
    }

    MatchSpaceGenerationPolicyInterface msgpi;
    switch(m_matching.getSelectedIndex())
    {
    case 0:      msgpi = new NoOpMatchSpaceGenerationPolicy(); break;
    case 1:
    default: msgpi = new BasicMatchSpaceGenerationPolicy(); break;
    }

    int numBlueprints;
    switch(m_numbp.getSelectedIndex())
    {
    case 0: numBlueprints = 1 ; break;
    case 1: numBlueprints = 2 ; break;
    case 2: numBlueprints = 3 ; break;
    case 3: numBlueprints = 4 ; break;
    case 4: numBlueprints = 5 ; break;
    case 5: 
    default:
      numBlueprints = 6 ; break;
    }

    int riverSpeed;
    switch(m_riverspeed.getSelectedIndex())
    {
    case 0: riverSpeed = 1; break;
    case 1: riverSpeed = 2; break;
    case 3: riverSpeed = 3; break;
    case 4: riverSpeed = 4; break;
    case 5:
    default: riverSpeed = 5; break;
    }


    Panel jp = new Panel();
    jp.setLayout(new BorderLayout());
    m_mainpanel.add(jp,"MainPanel");

    Panel pausep = new Panel();
    Button pauseb = new Button("Resume Game");
    pausep.add(pauseb);
    m_mainpanel.add(pausep,"Pause Panel");

    WoodPieceMenu wpm = null;

    if (m_debugmode.getSelectedIndex() == 1)
    {
      wpm = new WoodPieceMenu(m_mainpanel);
    }

    GiltHeadEngine gha = new GiltHeadEngine(m_mainpanel,
                                            jp,
                                            wpfpi,
                                            gspi,
                                            wpi,
                                            spi,
                                            gepi,
                                            mpi,
                                            mousespeed,
                                            msgpi,
                                            wpm,
                                            numBlueprints,
                                            riverSpeed);


    pauseb.addActionListener(gha);

    if (wpm != null)
    {
      wpm.SetGiltHeadEngine(gha);
      m_mainpanel.add(wpm,"Wood Piece Panel");
    }


    clayout.show(m_mainpanel,"MainPanel");
  }
}
