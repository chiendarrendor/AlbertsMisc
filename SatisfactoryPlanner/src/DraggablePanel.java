import javax.swing.JComponent;
import javax.swing.JPanel;
import java.awt.Point;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.util.ArrayList;
import java.util.List;

public class DraggablePanel extends JPanel {
    int screenX = 0;
    int screenY = 0;
    int startx = 0;
    int starty = 0;

    List<JComponent> painters = new ArrayList<>();


    private class MyMouseListener extends MouseAdapter {
        public void mousePressed(MouseEvent e) {
            screenX = e.getXOnScreen();
            screenY = e.getYOnScreen();
            startx = getX();
            starty = getY();
        }
    }

    private class MyMouseMotionListener extends MouseMotionAdapter {
        public void mouseDragged(MouseEvent e) {
            int deltaX = e.getXOnScreen() - screenX;
            int deltaY = e.getYOnScreen() - screenY;
            setLocation(startx+deltaX,starty+deltaY);

            painters.stream().forEach(p->p.repaint());

        }
    }

    public DraggablePanel() {
        this.setLocation(0,0);
        this.addMouseListener(new MyMouseListener());
        this.addMouseMotionListener(new MyMouseMotionListener());
    }

    public void addPainter(JComponent painter) { painters.add(painter); }

}
