
import javax.swing.*;
import java.awt.*;

public class MissionWalker
{
	static MissionState state = null;
	static MissionGridPanel gpanel = null;
	
	
	// rows should only contain events feasible from this environment...
	// columns should only contain conditions needed for the above events...
	
	private static void createAndShowGUI()
	{	
		JFrame frame = new JFrame("Artemis Mission Event Walker");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	
		gpanel = new MissionGridPanel(state);
		JPanel mainpanel = new JPanel(new BorderLayout());
		JScrollPane sp = new JScrollPane(gpanel);
		mainpanel.add(sp,BorderLayout.CENTER);
		
		JButton backbutton = new JButton("back");
		JPanel toppanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
		toppanel.add(backbutton);
		backbutton.addActionListener(gpanel);
		mainpanel.add(toppanel,BorderLayout.PAGE_START);
		
		frame.setPreferredSize(new Dimension(800, 600));
		frame.getContentPane().add(mainpanel);
		frame.pack();
		frame.setVisible(true);
	}
	
	
	
	public static void main(String args[])
	{
		if (args.length != 1)
		{
			System.err.println("bad command line");
			System.exit(1);
		}
		
		MissionReader mreader = new MissionReader(args[0]);
		state = mreader.GetMissionState();
		
		javax.swing.SwingUtilities.invokeLater(
			new Runnable()
			{
				public void run()
				{
					createAndShowGUI();
				}
			}
		);
		
		
	}
}
