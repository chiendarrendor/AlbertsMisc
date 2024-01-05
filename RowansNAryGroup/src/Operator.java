

// this class

import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class Operator {



    private int width;
    private Set<Integer> myset;
    private List<Integer> ordered; // this is a fixed ordering of the items in the set so we can refer to them by index as well as identity
                                    // don't want to make the assumption that the items are adjacent starting from 0
                                    // also, more importantly, the first width-1 items in this list, in order, represent the
                                    // identity of this set on this operator (which means that the set has to have at least width-1 items)
    private Map<String,Integer> opmap = new HashMap<>();
    public Operator(List<Integer> orderedsetitems, int width, String fname) throws IOException, NoSuchMethodException, InvocationTargetException, InstantiationException, IllegalAccessException {
        if (orderedsetitems == null || orderedsetitems.size() == 0) {
            throw new RuntimeException("Can't make an operator without a valid set!");
        }
        this.width = width;

        ordered = orderedsetitems;
        myset = orderedsetitems.stream().collect(Collectors.toSet());

        if (orderedsetitems.size() < width-1) {
            throw new RuntimeException("Can't make an operator of width " + width + " without at least " + (width-1) + " members of the set for the identity");
        }


        File file = new File(fname);
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        int linenum = 0;

        while((line = br.readLine()) != null) {
            ++linenum;
            if (linenum == 1) continue; // eat the header
            String[] items = line.split(","); // is a CSV
            if (items.length != width+1) throw new RuntimeException("bad operator line: " + line);
            StringBuffer sb = new StringBuffer();
            for (int i = 0 ; i < width+1 ; ++i) {
                int item = Integer.parseInt(items[i]);
                // this bit of magic gets the "constructor taking a string" from T and calls that on the string item.
                // this works on Strings and Integers...don't know what all else it works on.
                if (!myset.contains(item)) throw new RuntimeException("operator file has bad line, item not in set: " + line);
                if (i < width ){
                    sb.append("_" + item);
                } else {
                    String key = sb.toString();
                    if (opmap.containsKey(key)) throw new RuntimeException("operator file has duplicate line " + line);
                    opmap.put(key, item);
                }
            }
        }
        int opsize = (int)Math.pow(myset.size(),width);
        if (opsize != opmap.size()) throw new RuntimeException("operator file is missing lines, got " + opmap.size() + " expected " + opsize );
    }



    public Integer op(int... operands) {
        if (operands.length != width) throw new RuntimeException("bad op, wrong number of args");
        StringBuffer sb = new StringBuffer();
        for (int operand : operands) {
            if (!myset.contains(operand)) throw new RuntimeException("bad op, unknown element");
            sb.append("_" + operand);
        }
        return opmap.get(sb.toString());
    }

    public int getWidth() { return width; }
    public Set<Integer> getOpSet() { return myset; }
    public List<Integer> getOrderedSet() { return ordered; }
}
