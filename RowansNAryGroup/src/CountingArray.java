
// this class maintains a list of numcounters counters in an integer array
// each counter has a min of 0 and a max of 'countheight-1'
// we an do the following operations:
// reset -- returns all counters to 0
// ismax -- returns true iff all counters are at countheight-1
// ismin -- returns true iff all counters are at 0
// increment -- increments right hand most counter by 1... if counter is already at maxheight,
//      rolls to 0 and increments the next counter to left (exactly as you'd expect carry on +1 to work)
// decrement... works the same way

import java.util.ArrayList;
import java.util.List;

public class CountingArray {
    private List<Integer> counters = new ArrayList<>();
    private int maxval;



    public CountingArray(int countheight, int numcounters) {
        this.maxval = countheight - 1;
        for(int i = 0 ; i < numcounters; ++i) counters.add(0);
    }

    public void reset() {
        for (int i = 0 ; i < counters.size() ; ++i) counters.set(i,0);
    }

    public boolean isMin() {
        for (int i = 0 ; i < counters.size() ; ++i) {
            if (counters.get(i) != 0) return false;
        }
        return true;
    }

    public boolean isMax() {
        for (int i = 0 ; i < counters.size() ; ++i) {
            if (counters.get(i) != maxval) return false;
        }
        return true;
    }

    public int getCounter(int idx) { return counters.get(idx); }

    public void increment() {
        for(int i = counters.size() - 1 ; i >= 0 ; --i) {
            if (counters.get(i) == maxval) {
                counters.set(i,0);
            } else {
                counters.set(i,counters.get(i)+1);
                break;
            }
        }
    }

    public void decrement() {
        for (int i = counters.size() - 1 ; i >= 0 ; --i) {
            if (counters.get(i) == 0) {
                counters.set(i,maxval);
            } else {
                counters.set(i,counters.get(i)-1);
                break;
            }
        }
    }

}
