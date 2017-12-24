import java.awt.Panel;
import java.awt.BorderLayout;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.CardLayout;

// this class represents the central core of the running game.
// it has three main parts:
// the BalanceBeam -- a small panel animating the balance beam
// the WorkArea -- a larger panel embodying the blueprint, the
//     workbench, and the River (Sushi Bar)
// the RulesEngine -- a non-graphical object that communicates
//     information between the BalanceBeam and the WorkArea
//
// in addition, this class is the ActionListener to the 'UnPause' button
//    in the Control Panel, which turns animation on and switches back to
//    the game board card.
// also, it responds to several Keys:
//    'escape' pauses the animations and switches to the Pause card
//    'space' turns accelerate mode on in the RulesEngine
//      (makes the Sushi Bar run faster)
//    releasing 'space' turns accelerate mode off



public class GiltHeadEngine implements KeyListener,ActionListener
{
  private BalanceBeam m_bb;
  private WorkArea m_wa;
  private RulesEngine m_engine;

  private Panel m_mainpanel;

  public GiltHeadEngine(Panel i_mainpanel,
                        Panel i_basepanel,
                        WoodPieceFactoryPolicyInterface i_wpfpi,
                        GameStartPolicyInterface i_gspi,
                        WeighingPolicyInterface i_weighingpolicy,
                        ScoringPolicyInterface i_scoringpolicy,
                        GameEndPolicyInterface i_gameendpolicy,
                        MousePolicyInterface i_mousepolicy,
                        MouseSpeedPolicyInterface i_mousespeed,
                        MatchSpaceGenerationPolicyInterface i_msgpi,
                        WoodPieceChanger i_wpc,
                        int i_BlueprintGoal,
                        int i_SushiBoatVelocity)
  {
    m_mainpanel = i_mainpanel;
    
    m_engine = new RulesEngine(i_wpfpi,i_gspi,i_weighingpolicy,
                               i_scoringpolicy,i_gameendpolicy,
                               i_mousepolicy,i_mousespeed,i_msgpi,
                               i_BlueprintGoal,i_SushiBoatVelocity);

    m_bb = new BalanceBeam(m_engine);
    m_wa = new WorkArea(m_engine,i_wpc);

    i_basepanel.add(m_bb,BorderLayout.NORTH);
    i_basepanel.add(m_wa,BorderLayout.CENTER);

    m_bb.start();
    m_wa.start();

    m_bb.addKeyListener(this);
    m_wa.addKeyListener(this);

    Thread eth = new Thread(m_engine);
    eth.start();
  }

  // keylistener methods
  public void keyPressed(KeyEvent e) 
  {
    if (e.getKeyCode() == 32)
    {
      m_engine.SetAccelerate(true);
    }
  }

  public void keyReleased(KeyEvent e) 
  {
    if (e.getKeyCode() == 32)
    {
      m_engine.SetAccelerate(false);
    }
  }

  public void pause()
  {
    // stop thread processing for Work Area
    m_wa.pause();
    // stop thread processing for Engine
    m_engine.pause();
  }

  public void unpause()
  {
    // restart thread processing for Work Area
    m_wa.unpause();
    // restart thread processing for Engine
    m_engine.unpause();
  }    



  public void keyTyped(KeyEvent e)
  {
    if (e.getKeyChar() != KeyEvent.VK_ESCAPE) return;

    pause();

    // switch to pause screen
    CardLayout clayout = (CardLayout)m_mainpanel.getLayout();
    clayout.next(m_mainpanel);
  }

  public void actionPerformed(ActionEvent e)
  {
    unpause();

    // switch from pause screen
    CardLayout clayout = (CardLayout)m_mainpanel.getLayout();
    clayout.previous(m_mainpanel);
  }
}
