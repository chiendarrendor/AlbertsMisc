import grid.spring.FixedSizePanel;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.geom.Rectangle2D;
import java.util.Map;

public class DependencyPaintingPanel extends FixedSizePanel {
    ResourceManager manager;
    Map<String,ResourcePanel> resourcePanels;

    public DependencyPaintingPanel(int width, int height,ResourceManager manager,Map<String,ResourcePanel> resourcePanels) {
        super(width, height);
        this.manager = manager;
        this.resourcePanels = resourcePanels;
    }

    @Override
    public void paint(Graphics g) {
        Graphics2D g2d = (Graphics2D)g;

        g2d.setColor(Color.DARK_GRAY);
        g2d.fillRect(0,0,getWidth(),getHeight());


        g2d.setColor(Color.WHITE);
        g2d.setStroke(new BasicStroke(5.0f));

        for (CalculationNode cnode : CalculationNode.getAllActiveNodes()) {
            ResourcePanel fromPanel = resourcePanels.get(cnode.getResource().getName());
            ResourcePanel toPanel = resourcePanels.get(cnode.getRecipeResource().getName());
            if (fromPanel == null || toPanel == null) continue;
            Point fromPoint = fromPanel.getCenter();
            Point toPoint = toPanel.getCenter();
            g.drawLine(fromPoint.x,fromPoint.y,toPoint.x,toPoint.y);

            int meanx = (fromPoint.x+toPoint.x)/2;
            int meany = (fromPoint.y+toPoint.y)/2;

            String rateString = "" + cnode.getRate();
            g.setColor(Color.BLACK);
            FontMetrics fm = g.getFontMetrics();
            Rectangle2D rect = fm.getStringBounds(rateString,g);
            g.fillRect(meanx,meany-fm.getAscent(),(int)rect.getWidth(),(int)rect.getHeight());
            g.setColor(Color.WHITE);
            g2d.drawString(rateString,meanx,meany);



        }
    }
}
