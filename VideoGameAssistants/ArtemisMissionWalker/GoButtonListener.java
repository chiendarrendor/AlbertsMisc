
import java.awt.event.*;
import javax.swing.JButton;


public class GoButtonListener implements ActionListener
{
	private MissionGridPanel mgp;
	private MissionState state;
	private JButton mybutton;
	private MissionEvent event;
	
	public GoButtonListener(JButton b,MissionState s,MissionEvent e,MissionGridPanel p)
	{
		mgp = p;
		state = s;
		mybutton = b;
		event = e;
		
		b.addActionListener(this);
		
		
		Update();
	}
	
	public void Update()
	{
		mybutton.setEnabled(event.IsReady(state.GetCurrentEnvironment()));
	}
	
	public void actionPerformed(ActionEvent e)
	{
		state.MakeNewEnvironment();
		event.ActOnEnvironment(state.GetCurrentEnvironment());
		System.out.println(state.GetCurrentEnvironment());
		mgp.RebuildGrid();
	}
}
