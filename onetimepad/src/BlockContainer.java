import java.util.ArrayList;
import java.util.List;

public class BlockContainer {
    List<List<Integer>> cyphertexts;
    List<List<Integer>> keyblock;
    List<Integer> keyindex;
    List<Boolean> locked;

    public BlockContainer(List<List<Integer>> cyphertexts,List<List<Integer>> keyblock) {
        this.cyphertexts = cyphertexts;
        this.keyblock = keyblock;
        keyindex = new ArrayList<Integer>();
        locked = new ArrayList<>();

        for(int i = 0 ; i < keyblock.size(); ++i) {
            keyindex.add(0);
            locked.add(false);
        }
    }

    public boolean locktoggle(int pos) { return locked.set(pos,!locked.get(pos)); }
    public boolean locked(int pos) { return locked.get(pos); }

    public boolean canRise(int pos) { return locked(pos) ? false : keyindex.get(pos) > 0; }
    public boolean canFall(int pos) { return locked(pos) ? false : keyindex.get(pos) < 255; }
    public void rise(int pos) { keyindex.set(pos,keyindex.get(pos)-1); }
    public void fall(int pos) { keyindex.set(pos,keyindex.get(pos)+1); }


    public int getTextCount() { return cyphertexts.size(); }
    public int getWidth() { return keyblock.size(); }
    public int getTextWidth(int text) { return cyphertexts.get(text).size(); }
    public int getKeyAt(int pos) { return keyblock.get(pos).get(keyindex.get(pos)); }
    public int getCypherAt(int text,int pos) { return cyphertexts.get(text).get(pos); }
    public int getClearAt(int text,int pos) { return (getKeyAt(pos) ^ getCypherAt(text,pos)) & 0xff; }
    public char getClearCharAt(int text,int pos) { return (char)getClearAt(text,pos); }
}
