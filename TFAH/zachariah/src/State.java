import OnTheFlyAStar.AStarNode;
import grid.copycon.CopyCon;
import grid.copycon.Deep;
import grid.copycon.Ignore;
import grid.copycon.Shallow;
import grid.puzzlebits.CellContainer;
import grid.puzzlebits.Direction;

import java.awt.Point;
import java.util.ArrayList;
import java.util.List;

public class State implements AStarNode<State> {
    @Deep CellContainer<Integer> cells;
    @Ignore int movex = -1;
    @Ignore int movey = -1;
    @Ignore Direction moved = null;

    public State() {
        cells = new CellContainer<Integer>( 3,4,(x,y)->y*3+x);
        cells.setCell(0,1 , 6);
        cells.setCell(0,2,3);

    }

    public State(State right) {
        CopyCon.copy(this,right);
    }


    @Override public int winGrade() {
        return 12;
    }

    @Override public int getGrade() {
        int result = 0;
        for (int y = 0 ; y < 4 ; ++y) {
            for (int x = 0 ; x < 3 ; ++x) {
                if (cells.getCell(x,y) == y * 3 + x) ++result;
            }
        }
        return result;
    }

    @Override public String getCanonicalKey() {
        StringBuffer sb = new StringBuffer();
        for (int y = 0 ; y < 4 ; ++y ){
            for (int x = 0 ; x < 3; ++x) {
                sb.append(cells.getCell(x,y)).append(" ");
            }
        }
        return sb.toString();
    }

    public void rotate(int x,int y,Direction d) {
        int t = cells.getCell(x,y);
        Point curp = new Point(x,y);
        for (int index = 1 ; ; ++index) {
            Point np = d.delta(x,y,index);
            if (cells.onBoard(np)) {
                cells.setCell(curp.x,curp.y,cells.getCell(np.x,np.y));
            } else {
                cells.setCell(curp.x,curp.y,t);
                break;
            }
            curp = np;
        }
    }

    public State Rotate(int x,int y,Direction d) {
        State ns = new State(this);
        ns.rotate(x,y,d);
        ns.movex = x;
        ns.movey = y;
        ns.moved = d;
        return ns;
    }




    @Override public List<State> successors() {
        List<State> result = new ArrayList<>();
        for(int x = 0 ; x < 3 ; ++x) {
            result.add(Rotate(x,3, Direction.NORTH));
            result.add(Rotate(x,0,Direction.SOUTH));
        }
        for (int y = 0 ; y < 4 ; ++y) {
            result.add(Rotate(0,y,Direction.EAST));
            result.add(Rotate(2,y,Direction.WEST));
        }


        return result;
    }
}
