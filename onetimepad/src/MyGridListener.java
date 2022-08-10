import com.sun.org.apache.regexp.internal.RE;
import grid.spring.ClickInfo;
import grid.spring.ClickableGridPanel;
import grid.spring.GridPanel;

import javax.swing.JPanel;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.List;

public class MyGridListener implements GridPanel.GridListener, ClickableGridPanel.CellClicked {
    BlockContainer bc;
    int uprow;
    int downrow;
    int lockrow;

    public MyGridListener(BlockContainer bc) { this.bc = bc; uprow = 0; downrow = getNumYCells() - 2 ; lockrow = getNumYCells() - 1; }

    @Override public int getNumXCells() { return  85; }//longest; }
    @Override public int getNumYCells() { return bc.getTextCount() + 3; }
    @Override public boolean drawGridNumbers() { return true; }
    @Override public boolean drawGridLines() { return true; }
    @Override public boolean drawBoundary() { return true; }

    private void fill(BufferedImage bi,Color c) {
        Graphics2D g = (Graphics2D)bi.getGraphics();
        g.setColor(c);
        g.fillRect(0,0,bi.getWidth(),bi.getHeight());
    }

    @Override public boolean drawCellContents(int cx, int cy, BufferedImage bi) {
        if (cy == uprow) {
            if (bc.canRise(cx)) fill(bi,Color.GREEN);
            GridPanel.DrawStringInCell(bi, Color.BLACK,"^");
            return true;
        } else if (cy == downrow) {
            if (bc.canFall(cx)) fill(bi,Color.GREEN);
            GridPanel.DrawStringInCell(bi, Color.BLACK,"v");
            return true;
        } else if (cy == lockrow) {
            if (bc.locked(cx)) fill(bi, Color.RED);
            GridPanel.DrawStringInCell(bi, Color.BLACK,"X");
            return true;
        }

        --cy;


        if (cx >= bc.getTextWidth(cy)) return false;

        GridPanel.DrawStringInCell(bi, bc.locked(cx) ? Color.RED : Color.BLACK,""+bc.getClearCharAt(cy,cx));

        return true;
    }

    @Override public String[] getAnswerLines() {
        return new String[0];
    }

    private JPanel paintpanel = null;
    public void setPainter(JPanel panel) { paintpanel = panel; }

    @Override public void clicked(ClickInfo ci) {
        if (ci.celly == uprow) {
            if (bc.canRise(ci.cellx)) bc.rise(ci.cellx);
        } else if (ci.celly == downrow) {
            if (bc.canFall(ci.cellx)) bc.fall(ci.cellx);
        } else if (ci.celly == lockrow) {
            bc.locktoggle(ci.cellx);
        } else {
            return;
        }
        paintpanel.repaint();
    }

}
