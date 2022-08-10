import grid.spring.FixedSizePanel;
import grid.spring.SinglePanelFrame;

import java.awt.Graphics;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import static org.apache.commons.lang3.math.NumberUtils.max;
import static org.apache.commons.lang3.math.NumberUtils.min;

public class Main {

    public static int[] recaman(int count) {
        int[] result = new int[count];
        Set<Integer> seen = new HashSet<Integer>();

        result[0] = 0;
        for (int i = 1 ; i < count ; ++i) {
            int prev = result[i-1];
            int low = prev - i;
            int use = prev + i;
            if (low > 0 && !seen.contains(low)) use = low;
            seen.add(use);
            result[i] = use;
        }
        return result;
    }



    private static class MyDrawPanel extends FixedSizePanel {
        private static final int WIDTH = 2000;
        private static final int HEIGHT = 1000;
        private static final int INSET = 10;
        int[] sequence;
        double scale;
        public MyDrawPanel(int[] sequence) {
            super(WIDTH,HEIGHT);
            this.sequence = sequence;
            int max = Arrays.stream(sequence).max().getAsInt();
            scale = (WIDTH-2.0*INSET)/max;
        }


        public void paint(Graphics g) {
            int ycoord = HEIGHT/2;

            for (int i = 1; i < sequence.length; ++i) {
                int s1 = min(sequence[i-1],sequence[i]);
                int s2 = max(sequence[i-1],sequence[i]);


                double x1 = INSET + s1 * scale;
                double x2 = INSET + s2 * scale;
                int ix1 = (int)x1;
                int ix2 = (int)x2;
                int diameter = (ix2-ix1);

                if (i%2 == 0) {
                    g.drawArc(ix1,ycoord-diameter/2,diameter,diameter,0,180);
                } else {
                    g.drawArc(ix1,ycoord-diameter/2,diameter,diameter,180,180);
                }
            }
        }

    }




    public static void main(String[] args) {
        int[] sequence = recaman(150);
        System.out.print("Sequence: " );
        Arrays.stream(sequence).forEach(x->System.out.print("" + x + " " ));
        System.out.println("");

        SinglePanelFrame spf = new SinglePanelFrame("Recaman sequence",new MyDrawPanel(sequence));



    }
}
