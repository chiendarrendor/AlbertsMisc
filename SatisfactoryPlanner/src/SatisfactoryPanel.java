import grid.spring.FixedSizePanel;

import javax.swing.JComponent;
import javax.swing.JLayeredPane;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.LayoutManager;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SatisfactoryPanel extends MenuPanel {
    private static final int WIDTH = 1200;
    private static final int HEIGHT = 800;
    ResourceManager manager;

    JLayeredPane layers = new JLayeredPane();

    FixedSizePanel linePanel;

    FixedSizePanel widgetPanel;
    Map<String,ResourcePanel> resourcePanels = new HashMap<>();

    private class MyLayoutContainer implements LayoutManager {
        boolean doSwell = false;

        public MyLayoutContainer() {}
        public MyLayoutContainer(boolean doSwell) {this.doSwell = doSwell; }

        @Override public void addLayoutComponent(String name, Component comp) {}
        @Override public void removeLayoutComponent(Component comp) {}
        @Override public Dimension preferredLayoutSize(Container parent) { return new Dimension(WIDTH,HEIGHT); }
        @Override public Dimension minimumLayoutSize(Container parent) { return new Dimension(WIDTH,HEIGHT); }

        @Override public void layoutContainer(Container parent) {
            for (Component comp : parent.getComponents()) {
                JComponent jc = (JComponent)comp;
                if (doSwell) {
                    jc.setBounds(jc.getX(), jc.getY(), jc.getMaximumSize().width, jc.getMaximumSize().height);
                } else {
                    jc.setBounds(jc.getX(), jc.getY(), jc.getMinimumSize().width, jc.getMinimumSize().height);
                }
            }
        }
    }

    private class ResourceMenuSelector implements ActionListener {
        @Override public void actionPerformed(ActionEvent e) {
            String s = e.getActionCommand();
            activateResource(s);

        }
    }

    private ResourceMenuSelector rms = new ResourceMenuSelector();
    public void activateResource(String resourceName) {
        if (resourcePanels.containsKey(resourceName)) return;

        Resource res = manager.getResource(resourceName);

        ResourcePanel newPanel = new ResourcePanel(this, manager,res);
        widgetPanel.add(newPanel);
        revalidate();
        repaint();

        resourcePanels.put(resourceName,newPanel);
        newPanel.addPainter(this);
    }

    public void updateAllPanels(String wherefrom) {
        for (ResourcePanel rp : resourcePanels.values()) {
            rp.updateLabels("Satisfactory Panel Update All Panels: " + wherefrom);
        }
        revalidate();
        repaint();
    }

    public void drawAllLines() {
        repaint();
    }

    SatisfactoryPanel(ResourceManager manager) {
        this.manager = manager;

        JMenu resourceMenu = new JMenu("Resources");
        getMenuPanelMenuBar().add(resourceMenu);

        List<String> resources = new ArrayList<>();
        resources.addAll(manager.getResourceNames());
        Collections.sort(resources);


        for (String s: resources) {
            JMenuItem jmi = new JMenuItem(s);
            resourceMenu.add(jmi);
            jmi.addActionListener(rms);

        }

        layers.setLayout(new MyLayoutContainer(true));

        widgetPanel = new FixedSizePanel(WIDTH,HEIGHT);
        widgetPanel.setLayout(new MyLayoutContainer());
        widgetPanel.setBackground(Color.DARK_GRAY);
        widgetPanel.setOpaque(false);

        linePanel = new DependencyPaintingPanel(WIDTH,HEIGHT,manager,resourcePanels);
        linePanel.setBackground(Color.GREEN);

        setMenuPanelComponent(layers);
        layers.add(widgetPanel,new Integer(1));
        layers.add(linePanel,new Integer(0));
    }
}
