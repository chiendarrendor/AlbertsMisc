
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.util.*;


public class ColumnListener implements ActionListener
{
	JComponent component;
	JButton mybutton;
	int mycolumn;
	String myname;
	MissionCondition.ConditionType type;
	boolean isOn;
	Color defBack;
	MissionEnvironment env;
	MissionGridPanel thegrid;
	
	private class ConditionPair
	{
		public MissionCondition condition;
		public JLabel label;
		public ConditionPair(MissionCondition mc,JLabel jl) { condition = mc; label = jl; }
		
		public void Update()
		{
			label.setBackground(condition.IsTrue(env) ? Color.green : defBack);
		}
	}
	
	private Vector<ConditionPair> conditionpairs = new Vector<ConditionPair>();
	
	
	
	
	public ColumnListener(JButton b,int col,MissionCondition.ConditionType t,MissionEnvironment me,String n,MissionGridPanel mgp)
	{
		component = mybutton = b;
		mycolumn = col;
		type  = t;
		env = me;
		myname = n;
		thegrid = mgp;
		
		b.addActionListener(this);
		
		Initialize();
	}
	
	public ColumnListener(JLabel label,int col,MissionCondition.ConditionType t,MissionEnvironment me,String n,MissionGridPanel mgp)
	{
		component = label;
		mybutton = null;
		mycolumn = col;
		type = t;
		env = me;
		myname = n;
		thegrid = mgp;
		
		Initialize();
	}
	
	private void Initialize()
	{
		defBack = component.getBackground();
		component.setOpaque(true);
		UpdateComponent();
	}
	
	private void UpdateComponent()
	{
		switch(type)
		{
			case VARIABLE: isOn = true; break;
			case TIMER: isOn = env.TimerExpired(myname); break;
			case OTHER: isOn = env.HasOther(myname); break;
		}
		
		component.setBackground(isOn ? Color.green : defBack);
	}
	
	public void AddSubordinate(MissionCondition cond,int row)
	{
		String ltext=null;
		switch(type)
		{
			case TIMER: ltext = "expired?"; break;
			case OTHER: ltext = "true?"; break;
			case VARIABLE: ltext = cond.GetRelOp().name() + " " + cond.GetValue() + "?"; break;
		}
		JLabel sublabel = new JLabel(ltext);
		sublabel.setBorder(BorderFactory.createLineBorder(Color.black));
		sublabel.setOpaque(true);
		
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = mycolumn;
		gbc.gridy = row;
		gbc.fill = GridBagConstraints.BOTH;
		thegrid.add(sublabel,gbc);
		ConditionPair cp = new ConditionPair(cond,sublabel);
		cp.Update();
		conditionpairs.add(cp);
	}
	
	
	public void actionPerformed(ActionEvent e)
	{
		isOn = !isOn;
		switch(type)
		{
			case TIMER: env.SetTimerExpiration(myname,isOn); break;
			case OTHER: env.SetOther(myname,isOn); break;
		}
		UpdateComponent();
		thegrid.UpdateGoButtons();
		for (ConditionPair cp : conditionpairs) { cp.Update(); }
	}
}
		
		
	

		
	