
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.awt.event.*;

// the action being processed for this object being ActionListener
// is the 'back' functionality.
public class MissionGridPanel extends JPanel implements ActionListener
{
	private MissionState state;
	static String vlprefix = "<html><bold>";
	static String vlsuffix = "</bold></html>";
	private Vector<GoButtonListener> gobuttonlisteners;
	
	public void UpdateGoButtons()
	{
		for (GoButtonListener gbl : gobuttonlisteners) gbl.Update();
	}
	
	private GridBagConstraints TitleConstraints(int xcoord)
	{
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = xcoord;
		gbc.gridy = 0;
		gbc.fill = GridBagConstraints.BOTH;
		gbc.anchor = GridBagConstraints.FIRST_LINE_START;
		gbc.ipadx = 5;
		return gbc;
	}

	private JButton AddTitleButton(String text,int swingconstant,int xcoord)
	{
		String newtext = text.replace("<","&lt;").replace(">","&gt;").replace(" ","<p>");
		JButton result = new JButton(vlprefix + newtext + vlsuffix);
		add(result,TitleConstraints(xcoord));
		return result;
	}


	
	private JLabel AddTitleLabel(String text,int swingconstant,int xcoord)
	{
		String newtext = text.replace("<","&lt;").replace(">","&gt;").replace(" ","<p>");
		JLabel result = new JLabel(vlprefix + newtext + vlsuffix,swingconstant);
		result.setBorder(BorderFactory.createLineBorder(Color.black));
		add(result,TitleConstraints(xcoord));
		return result;
	}
	
	private JButton AddNameLabel(String text,int ycoord)
	{
		JLabel result = new JLabel(text,SwingConstants.LEFT);
		result.setBorder(BorderFactory.createLineBorder(Color.black));
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = 0;
		gbc.gridy = ycoord;
		gbc.fill = GridBagConstraints.BOTH ;
		gbc.ipadx = 5;
		gbc.anchor = GridBagConstraints.FIRST_LINE_START;
		add(result,gbc);
		
		JButton jb = new JButton("Go!");
		gbc.gridx = 1;
		add(jb,gbc);
		
		return jb;
		
	}
	
	
	public void RebuildGrid()
	{
		removeAll();
		Vector<MissionEvent> availevents = state.GetAvailableEvents();
		Vector<String> usedvars = state.GetUsedVars();
		Vector<String> timercons = state.GetUsedTimers();
		Vector<String> othercons = state.GetOtherConditions();
		MissionEnvironment me = state.GetCurrentEnvironment();
		
		int numcons = usedvars.size() + othercons.size();
		
		
		AddTitleLabel("name",SwingConstants.LEFT,0);
		AddTitleLabel("Go",SwingConstants.CENTER,1);
		
		Map<String,ColumnListener> varcols = new HashMap<String,ColumnListener>();
		Map<String,ColumnListener> timercols = new HashMap<String,ColumnListener>();
		Map<String,ColumnListener> othercols = new HashMap<String,ColumnListener>();
		
		int xpos = 2;
		int finalxpos = 1 + numcons;
		for (String var : usedvars)
		{
			StringBuffer sb = new StringBuffer();
			sb.append(var);
			sb.append(" = ");
			if (me.IsVariableSet(var))
			{
				sb.append(me.GetVariableValue(var));
			}
			JLabel jl = AddTitleLabel(sb.toString(),SwingConstants.CENTER,xpos);
			varcols.put(var,new ColumnListener(jl,xpos,MissionCondition.ConditionType.VARIABLE,me,var,this));
			xpos++;
		}

		for (String var : timercons)
		{
			JButton jb = AddTitleButton(var,SwingConstants.CENTER,xpos);
			timercols.put(var,new ColumnListener(jb,xpos,MissionCondition.ConditionType.TIMER,me,var,this));
			xpos++;
		}

		for (String var : othercons)
		{
			JButton jb = AddTitleButton(var,SwingConstants.CENTER,xpos);
			othercols.put(var,new ColumnListener(jb,xpos,MissionCondition.ConditionType.OTHER,me,var,this));
			xpos++;
		}		
		
		
		int ypos = 1;
		gobuttonlisteners = new Vector<GoButtonListener>();
		for (MissionEvent mev : availevents)
		{
			JButton jb = AddNameLabel(mev.GetName(),ypos);
			GoButtonListener gbl = new GoButtonListener(jb,state,mev,this);
			gobuttonlisteners.add(gbl);
			
			for (MissionCondition mc : mev.GetConditions())
			{
				Map<String,ColumnListener> colset = null;
				switch(mc.GetType())
				{
				case VARIABLE: colset = varcols; break;
				case TIMER: colset = timercols; break;
				case OTHER: colset = othercols; break;
				}
				colset.get(mc.GetName()).AddSubordinate(mc,ypos);
			}
			
			
			
			
			++ypos;
		}
		
		
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = xpos;
		gbc.gridy = ypos;
		gbc.weightx = 1;
		gbc.weighty = 1;
		JLabel dl = new JLabel("");
		add(dl,gbc);
		
		revalidate();
		repaint();
	}

	//  this is the 'back' functionality.
	public void actionPerformed(ActionEvent e)
	{
		boolean dumped = state.DumpEnvironment();
		if (!dumped) return;
		RebuildGrid();
	}
	
	
		
	public MissionGridPanel(MissionState state)
	{
		super(new GridBagLayout());
		this.state = state;
		RebuildGrid();
	}
}