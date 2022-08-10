import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class NodeDictionary {
    private Map<String,Integer> dict = new HashMap<>();
    private Set<String> files = new HashSet<>();

    public int getNodeId(String s) { return getNodeId(s,false); }

    public int getNodeId(String s,boolean isFile) {
        if (isFile) files.add(s);
        if (!dict.containsKey(s)) {
            int newid = dict.size();
            dict.put(s,newid);
            return newid;
        }
        return dict.get(s);
    }

    public Set<String> getFiles() { return files; }

    public void show() {
        for (String key : dict.keySet()) {
            System.out.println(dict.get(key) + ": " + key + (files.contains(key) ? "(file)" : "" ));
        }
    }
}
