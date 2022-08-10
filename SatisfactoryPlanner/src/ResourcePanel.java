import javax.swing.BorderFactory;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SpringLayout;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class ResourcePanel extends DraggablePanel {
    SatisfactoryPanel parent;
    ResourceManager manager;
    String myname;
    Resource resource;
    JLabel recipeName = new JLabel();
    JLabel machineCount = new JLabel();
    JLabel machineType = new JLabel();
    JLabel recipeOutputPerMinute = new JLabel();
    JLabel totalConsumption = new JLabel();
    JLabel totalNonSelfProduction = new JLabel();
    JLabel totalSelfProduction = new JLabel();
    JLabel totalNetProduction = new JLabel();

    JPanel infoPanel;

    JTextField desiredNet = new JTextField("0",5);
    private class DesiredNetAction implements ActionListener {
        @Override public void actionPerformed(ActionEvent e) {
            JTextField tf = (JTextField)e.getSource();
            try {
                int newDesiredNet = Integer.parseInt(tf.getText());
                resource.setNetRate(newDesiredNet);
                manager.updateAllForNetRate();
                parent.updateAllPanels("DesiredNet Text Field Action Listener");
                System.out.println("Updating net rate of " + myname);
            } catch (NumberFormatException nfe) {
                tf.setText(""+resource.getNetRate());
            }
        }
    }


    private static final String[] shardStrings = new String[] { "0","1","2","3"};
    JComboBox shardCount = new JComboBox(shardStrings);

    private class ShardAction implements ActionListener {
        @Override public void actionPerformed(ActionEvent e) {
            JComboBox cb = (JComboBox)e.getSource();
            if (!cb.isEnabled()) return;
            int newShardCount = Integer.parseInt((String)cb.getSelectedItem());
            if (newShardCount == resource.getShardCount()) return;
            resource.setShardCount(newShardCount);
            manager.updateAllForNetRate();
            parent.updateAllPanels("Shard Count Action Listener " + myname + " " + e);
        }
    }

    public Point getCenter() {
        Rectangle brect = getBounds();
        return new Point(brect.x + brect.width/2,brect.y + brect.height/2);
    }




    public void updateLabels(String whereFrom) {
        System.out.println("Update Labels " + whereFrom);
        Recipe recipe = resource.producingRecipe;

        if (recipe != null) {
            recipeName.setText(recipe.getName());
            recipeOutputPerMinute.setText(""+recipe.productionRate);
            machineCount.setText(""+resource.getMachineCount());
            machineType.setText(recipe.machine);
            shardCount.setEnabled(true);
            desiredNet.setEnabled(true);
        } else {
            shardCount.setSelectedIndex(0);
            shardCount.setEnabled(false);
            desiredNet.setEnabled(false);
            desiredNet.setText("0");
        }

        double tcval = 0;
        double tnspval = 0;
        double tspval = 0;
        double tnpval = 0;

        for(CalculationNode cnode : resource.getResourceNodes()) {
            if (cnode.getRate() < 0) tcval -= cnode.getRate();
            else if (cnode.getResource().getName().equals(myname)) tspval += cnode.getRate();
            else tnspval += cnode.getRate();

            tnpval += cnode.getRate();
        }

        totalConsumption.setText(""+tcval);
        totalNonSelfProduction.setText(""+tnspval);
        totalSelfProduction.setText(""+tspval);
        totalNetProduction.setText(""+tnpval);

        infoPanel.validate();
    }

    Map<String,String> recipeLabelMap = new HashMap<>();

    private class RecipeMenuSelector implements ActionListener {
        @Override public void actionPerformed(ActionEvent e) {
            String s = e.getActionCommand();
            resource.setRecipe(manager.getRecipe(recipeLabelMap.get(s)));
            updateLabels("Recipe Menu Action Performed");

            Collection<CalculationNode> recipeNodes = resource.getRecipeNodes();
            for (CalculationNode cn : recipeNodes) {
                if (cn.getResource().getName().equals(myname)) continue;
                parent.activateResource(cn.getResource().getName());
            }

            parent.updateAllPanels("Recipe Selector Action Listener");
            manager.updateAllForNetRate();
            parent.repaint();
        }
    }



    public ResourcePanel(SatisfactoryPanel parent,ResourceManager manager, Resource r) {
        this.parent = parent;
        this.manager = manager;
        myname = r.getName();
        resource = r;

        JPanel innerPane = new JPanel();
        innerPane.setLayout(new BorderLayout());

        MenuPanel outerPane = new MenuPanel(innerPane);
        add(outerPane);

        Collection<Recipe> myRecipes = manager.getRecipesForResource(myname);

        if (myRecipes != null) {
            JMenu recipes = new JMenu("Recipes");
            outerPane.getMenuPanelMenuBar().add(recipes);
            RecipeMenuSelector rms = new RecipeMenuSelector();


            for (Recipe recipe : myRecipes) {
                StringBuffer sb = new StringBuffer();
                sb.append(recipe.getName()).append(" (");

                boolean first = true;
                for(String input : recipe.getInputResources()) {
                    if (!first) {
                        sb.append(", ");
                    }
                    first = false;
                    sb.append(input);
                }
                sb.append(')');

                JMenuItem item = new JMenuItem(sb.toString());
                recipeLabelMap.put(sb.toString(),recipe.getName());

                recipes.add(item);
                item.addActionListener(rms);
            }
        }

        JLabel title = new JLabel( r.getName(),JLabel.CENTER);
        title.setFont(title.getFont().deriveFont(title.getFont().getStyle() | Font.BOLD));
        title.setFont(title.getFont().deriveFont(title.getFont().getSize()*2.0f));
        title.setBorder(BorderFactory.createLineBorder(Color.BLACK));



        innerPane.add(title , BorderLayout.NORTH);
        infoPanel = new JPanel(new SpringLayout());
        innerPane.add(infoPanel,BorderLayout.CENTER);
        infoPanel.setBorder(BorderFactory.createLineBorder(Color.BLACK));

        if (myRecipes != null) {
            infoPanel.add(new JLabel("Recipe Name:", JLabel.TRAILING));
            infoPanel.add(recipeName);
            infoPanel.add(new JLabel("Recipe Output Rate:", JLabel.TRAILING));
            infoPanel.add(recipeOutputPerMinute);
            infoPanel.add(new JLabel("Machine:",JLabel.TRAILING));
            infoPanel.add(machineType);
            infoPanel.add(new JLabel("Machine Count:", JLabel.TRAILING));
            infoPanel.add(machineCount);
            infoPanel.add(new JLabel("Desired Net Rate:", JLabel.TRAILING));
            infoPanel.add(desiredNet);
            desiredNet.addActionListener(new DesiredNetAction());
            infoPanel.add(new JLabel("Shard Count (per Machine):", JLabel.TRAILING));
            infoPanel.add(shardCount);
            shardCount.addActionListener(new ShardAction());
        }
        infoPanel.add(new JLabel("Total Consumption:",JLabel.TRAILING)); infoPanel.add(totalConsumption);
        infoPanel.add(new JLabel("Total off-label Production:",JLabel.TRAILING)); infoPanel.add(totalNonSelfProduction);
        infoPanel.add(new JLabel("Total Primary Recipe Production:",JLabel.TRAILING)); infoPanel.add(totalSelfProduction);
        infoPanel.add(new JLabel("Total Rate:",JLabel.TRAILING)); infoPanel.add(totalNetProduction);


        int rowcount = infoPanel.getComponentCount() / 2;

        SpringUtilities.makeCompactGrid(infoPanel,
              rowcount,2,
                3,3,
                3,3);

        updateLabels("ResourcePanel constructor");
    }
}
