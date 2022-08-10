import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JMenuBar;
import javax.swing.JPanel;
import java.awt.BorderLayout;
import java.awt.Dimension;

// This class creates a Panel that will hold one other JComponent, and provide access to a menu
public class MenuPanel extends JPanel {
    private JMenuBar menuBar = new JMenuBar();
    private JComponent component = null;

    public MenuPanel() {
        this(null);
    }

    public MenuPanel(JComponent child) {
        setLayout(new BorderLayout());
        add(menuBar,BorderLayout.NORTH);

        if (child != null) setMenuPanelComponent(child);
    }

    public void setMenuPanelComponent(JComponent child) {
        if (component != null) throw new RuntimeException("MenuPanel shouldn't get component twice");
        component = child;
        add(child,BorderLayout.CENTER);
    }
    public JMenuBar getMenuPanelMenuBar() {
        return menuBar;
    }

    public Dimension getMinimumSize() { return getPreferredSize(); }

    public Dimension getPreferredSize() {
        int width = menuBar.getPreferredSize().width;
        int height = menuBar.getPreferredSize().height;

        if (component != null) {
            width = Math.max(width,component.getPreferredSize().width);
            height += component.getPreferredSize().height;
        }

        return new Dimension(width,height);
    }

}
