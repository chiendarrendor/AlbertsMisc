import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;

public class PokeCalc
{
	interface CompOfRow { JComponent get(PokeRow pr); }

	private static class PokeRow
	{
		public String name;
		public PokeSet mySet;
		public JButton upButton = new JButton("^");
		public JButton remButton = new JButton("Remove");
		public JButton setButton = new JButton("Set");
		public JLabel nameLabel;
		public JLabel xpLabel = new JLabel("0");
		private Map<Integer,JButton> numbuttons = new HashMap<Integer,JButton>();
		
		int curxp;
	
		public PokeRow(String name, PokeSet pset)
		{
			this.name = name;
			this.mySet = pset;
			nameLabel = new JLabel(name);
			
			remButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e){ mySet.removeRow(PokeRow.this); } } );
			setButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e){ PokeRow.this.setXP(); } } );
			upButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) { mySet.rowUp(PokeRow.this); } } );
			
		}
		
		public void setXP()
		{
			String xpstr = (String)JOptionPane.showInputDialog(mySet.getFrame(),"Amount of XP to Next Level ",
						"Set Amount of XP to next level",JOptionPane.PLAIN_MESSAGE,null,null,null);
			int newval;
			try
			{
				newval = Integer.parseInt(xpstr);
			}
			catch(NumberFormatException nfe)
			{
				return;
			}
		
			curxp = newval;
			xpLabel.setText(String.valueOf(newval));
		}
		
		public void subXP(int delta)
		{
			curxp -= delta;
			xpLabel.setText(String.valueOf(curxp));
		}
		
		private class ButtonPusher implements ActionListener
		{
			private int num;
			public ButtonPusher(int num) { this.num = num; }
			public void actionPerformed(ActionEvent e) { PokeRow.this.subXP(num); }
		}
		
		public void addNumButton(int num)
		{
			JButton thisbutton = new JButton(String.valueOf(num));
			numbuttons.put(num,thisbutton);
			thisbutton.addActionListener(new ButtonPusher(num) );
		}
		
		public JButton getNumButton(int num)
		{
			return numbuttons.get(num);
		}
		
		public void removeNumButton(int num)
		{
			numbuttons.remove(num);
		}
		
		
	}


	private static class PokeSet extends JPanel implements ActionListener
	{
		private Vector<PokeRow> rowvec = new Vector<PokeRow>();
		private JFrame theFrame;
		private GroupLayout theLayout; 
		private Set<Integer> numSet = new TreeSet<Integer>();
		private Map<Integer,JButton> delButtons = new HashMap<Integer,JButton>();
		private JLabel delLabel = new JLabel("Delete:");
		
		public JFrame getFrame() { return theFrame; }
		
		public PokeSet(JFrame frame)
		{
			theLayout = new GroupLayout(this);
			theLayout.setAutoCreateGaps(true);
			theLayout.setAutoCreateContainerGaps(true);
			this.setLayout(theLayout);
			this.theFrame = frame;
		}
		
		private class DeleterAction implements ActionListener
		{
			private int myNum;
			public DeleterAction(int num) { myNum = num; }
			public void actionPerformed(ActionEvent e)
			{
				delButtons.remove(myNum);
				numSet.remove(myNum);
				for (PokeRow pr : rowvec) { pr.removeNumButton(myNum); }
				updateLayout();
			}
		}
		
		
		// this is the action Listener for the 'Add New Pokemon' button.
		public void actionPerformed(ActionEvent e)
		{
			String action = e.getActionCommand();
			
			if (action.equals("New"))
			{
				// first, get a pokemon name
				String newName = (String)JOptionPane.showInputDialog(theFrame,"New Pokemon Name","Get New Pokemon Name",JOptionPane.PLAIN_MESSAGE,null,null,null);
				// then make a rowvec
				PokeRow newRow = new PokeRow(newName,this);
				rowvec.add(newRow);
				for (int num : numSet) { newRow.addNumButton(num); }
				updateLayout();
			}
			
			else if (action.equals("XPD"))
			{
				String xpstr = (String)JOptionPane.showInputDialog(theFrame,"Amount of XP Delta",
						"Set Amount of XP Delta",JOptionPane.PLAIN_MESSAGE,null,null,null);
				int newval;
				try
				{
					newval = Integer.parseInt(xpstr);
				}
				catch(NumberFormatException nfe)
				{
					return;
				}
				
				if (numSet.contains(newval))
				{
					return;
				}
				
				numSet.add(newval);
				
				JButton newdb = new JButton(String.valueOf(newval));
				delButtons.put(newval,newdb);
				newdb.addActionListener(new DeleterAction(newval));
				
				for (PokeRow pr : rowvec) { pr.addNumButton(newval); }
				updateLayout();
			}
		}
		
		private GroupLayout.ParallelGroup addCrossRowParallelGroup(GroupLayout.SequentialGroup gcon,CompOfRow  getter)
		{
			GroupLayout.ParallelGroup pgroup = theLayout.createParallelGroup(GroupLayout.Alignment.LEADING);
			for (PokeRow pr : rowvec)
			{
				pgroup.addComponent(getter.get(pr));
			}
			gcon.addGroup(pgroup);
			return pgroup;
		}
			
		
		
		private void updateLayout()
		{
			// format:
			// 
			// <del> <set> <Name> <XP> [<delta XP buttons>]
			// <del> <set> <Name> <XP> [<delta XP buttons>]
		
			// horizontal group:
			// sequential of:
			//   parallel of: all del buttons
			//   parallel of: all set buttons	
			//	 parallel of: all Name Labels
			//   parallel of: all XP Labels
						
			this.removeAll();
			GroupLayout.ParallelGroup nameColumn;
			GroupLayout.SequentialGroup hgroup = theLayout.createSequentialGroup();
			addCrossRowParallelGroup(hgroup, new CompOfRow() { public JComponent get(PokeRow pr) { return pr.upButton; } } );
			addCrossRowParallelGroup(hgroup, new CompOfRow() { public JComponent get(PokeRow pr) { return pr.remButton; } } );
			addCrossRowParallelGroup(hgroup, new CompOfRow() { public JComponent get(PokeRow pr) { return pr.setButton; } } );
			nameColumn = addCrossRowParallelGroup(hgroup, new CompOfRow() { public JComponent get(PokeRow pr) { return pr.nameLabel; } } );
			addCrossRowParallelGroup(hgroup, new CompOfRow() { public JComponent get(PokeRow pr) { return pr.xpLabel; } } );
			
			if (numSet.size() > 0)
			{
				nameColumn.addComponent(delLabel);
			}
			
			for (final int num : numSet)
			{
				GroupLayout.ParallelGroup pg;
				pg = addCrossRowParallelGroup(hgroup, new CompOfRow() { public JComponent get(PokeRow pr) { return pr.getNumButton(num); } } );
				pg.addComponent(delButtons.get(num));
			}
			theLayout.setHorizontalGroup(hgroup);
			
			// vertical group
			// sequential of:
			//   parallel of: a players <del> <set> <Name> <XP>
			GroupLayout.SequentialGroup vgroup = theLayout.createSequentialGroup();
			for (PokeRow pr : rowvec)
			{
				GroupLayout.ParallelGroup rowgroup = theLayout.createParallelGroup(GroupLayout.Alignment.BASELINE);
				rowgroup.addComponent(pr.upButton).addComponent(pr.remButton).
					addComponent(pr.setButton).addComponent(pr.nameLabel).addComponent(pr.xpLabel);
				
				for (int num : numSet)
				{
					rowgroup.addComponent(pr.getNumButton(num));
				}
				
				vgroup.addGroup(rowgroup);
			}
			
			if (numSet.size() > 0)
			{
				GroupLayout.ParallelGroup delgroup = theLayout.createParallelGroup(GroupLayout.Alignment.BASELINE);
				delgroup.addComponent(delLabel);
				for (int num : numSet)
				{
					delgroup.addComponent(delButtons.get(num));
				}
				vgroup.addGroup(delgroup);
			}
			
			
			theLayout.setVerticalGroup(vgroup);
			theLayout.layoutContainer(this);
		}
		
		public void removeRow(PokeRow pr)
		{
			rowvec.remove(pr);
			updateLayout();
		}
		
		public void rowUp(PokeRow pr)
		{
			int curI = rowvec.indexOf(pr);
			if (curI == -1) return;
			if (curI == 0) return;
			
			Collections.swap(rowvec,curI,curI-1);
			updateLayout();
		}
		
		
		
	}
		
	private static void createAndShowGUI()
	{
		JFrame frame = new JFrame("Pokemon XP Calculator");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	
		PokeSet pset = new PokeSet(frame);
		frame.add(pset,BorderLayout.CENTER);
	
		JPanel bpanel = new JPanel();
		bpanel.setLayout(new FlowLayout());
		frame.add(bpanel,BorderLayout.NORTH);
	
		JButton newButton = new JButton("Add New Pokemon");
		bpanel.add(newButton);
		newButton.setActionCommand("New");
		newButton.addActionListener(pset);
		
		JButton numButton = new JButton("Add New XP Decrement");
		bpanel.add(numButton);
		numButton.setActionCommand("XPD");
		numButton.addActionListener(pset);

		
		
		frame.pack();
		frame.setSize(500,500);
		frame.setVisible(true);
	}



	public static void main(String[] args)
	{
		javax.swing.SwingUtilities.invokeLater(new Runnable()
			{
				public void run()
				{
					createAndShowGUI();
				}
			});
	}
}
