import grid.spring.ClickableGridPanel;
import grid.spring.SinglePanelFrame;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Main {

    private static final String key1 = "6a5339";
    private static final String ctx1 = "223a18";

    private static final String[] cypherstrings = new String[]{
            "095c53232228661529080e79594454543d101c0001617d7456034e5739323c197f0175240d5f102956235401746162696c312d2d1766233f617208253c08275f53007c1423472c5006284409103612202a77167b08373c2a506a7d204f126b28622f5a08715e3d7c1f0f6f5e4b11310d273c6100304b57716c2c4c",
            "07415836762064092d0a076c15540b542a0a0050057c7b65431a454b393a215d3e106e241d0653295e705416626a78697323683f59646c2c2f60013f33132c18101f63162246265c0b2f0d1216770f6e7a711b684d293a6f57677a314e12742f303a571b670c216f4d1266574b152c0639312250374b4c75292d071f0a0c3e7b0c362f517e1f432357425f017d4a19777a32",
            "095c53232228661529080e79595d551d260a59541e33687f474a405d7d3620137f1366344951513510664602726a78696b212427177335232e6f142b260f315f47066511764c2b5015255d12177915622a77167b08242121556a6130435d6a6e2d281e177a4a216f00077a5b040b790227372c503019517d683b031c0200706f5827295d280a5866165f4a137c4e106629721b0d0305365e5137",
            "1e464f733935680021160774165f071b2f58184e5176727450135d467c3772103a0172300e431035586252016429786878642c3b546f28242f664d322c192a11591e641c76462b5f1e7c5a0f0a7e5b2764771b704c222a6f516a702a5a5b6120363d1e0a7b0c3e6f080562470f007905363b24032219456a6632421f0a13356e5f272f516d0d19",
            "07414e36242921043a011674164a55153910000018603c7f470b5b5b752a721f3e01643549495e665d62540c72646d7474272932177424282e7314662814265f53007c09235d2041472f4e0f1b78182b2a730c7f4b33272c4634",
            "2b424d3c242e750f250b46610b4807102c0b10471f767837431842477737721e301f71241d47442f5f6d410837616d72792a2d2d44202d3e327400363d132d114343311437422c5d007c5e131d7e5b2f6664116c41332622502f7b225856243a2d6e5c0c714d253d04082e4219043a103c3b2450334003796726421f0a13356e5f272f4126",
            "035a0a3a2567750f2d1714650d44441525140000017c6f644b08415739273d5d3d00643002064333536b0005377a75736921257e55796c2f33741923641c2d0d53067f1e7a092746137c44125e7f086e636d187b4934272d4f6a333745126021623d515e76556e7c031f2e59050a2e0a75283311324d4a7b683342130b043e6f02",
            "1e464f2033677204201d0b650a0d46062c580d48146179714d1848126d3620103a162132064b40334462540d78676d6c713d682d5263393f243a4d32211f2d0d551b781a37456552032a4c081d73086e6b6d1a3e4e263d3b467d3320455f743b3627501934582b7e0508615e04022044273d3005384b46387d37070d0b452373403329516710446603401a106b0b1d7d67681d0d050134414d394c0f731e5d354955",
            "1e464f213367641f210b12201043411b3b151854187c72375602485d6b3626143c136d3d1006432353765201377a6f6878292d2d1774242c35210e2727142d0b100d7459345b2a5802320d030873156e7d6a0a76083220234a627a374f56242d2d234e0b6045207a4d1661450e177544262d221871585038663107531a0c3d790c363c5c24",
            "285b5e73222f64142d58156311484a113a58185214337178500f0d56703534143c076d2549525f66596e50087264696e69643c36566e6c3929644d242c09365f44077416244c315a043d410a0736193c6f62157f4a2b2b6f417a6763495d693e373a5f0a7d43207c010a771218003a11273d611d345a4b79673611131d4b",
            "0d414537762d6e05681e0972595f4217260e1c52187d7b37560244413920371e2d1775710443433551644545374569743a37683c45612b6d356e4d3f260f305f561d781c384d3613063e42130a360f2663705f"
    };

    private static Map<Character,Integer> distribution = null;
    
    private static void setupDistribution() {
        distribution = new HashMap<>();
       distribution.put(' ', 1293934);
       distribution.put('(', 628);
        distribution.put(',', 83174);
        distribution.put('0', 299);
        distribution.put('4', 93);
        distribution.put('8', 40);
        distribution.put('<', 468);
        distribution.put('@', 8);
        distribution.put('D', 15683);
        distribution.put('H', 18462);
        distribution.put('L', 23858);
        distribution.put('P', 11939);
        distribution.put('T', 39800);
        distribution.put('X', 606);
        distribution.put('`', 1);
        distribution.put('d', 133779);
        distribution.put('h', 218406);
        distribution.put('l', 146161);
        distribution.put('p', 46525);
        distribution.put('t', 289975);
        distribution.put('x', 4688);
        distribution.put('|', 33);
        distribution.put('#', 1);
        distribution.put('\'', 31069);
        distribution.put('/', 5);
        distribution.put('3', 330);
        distribution.put('7', 41);
        distribution.put(';', 17199);
        distribution.put('?', 10476);
        distribution.put('C', 21497);
        distribution.put('G', 11164);
        distribution.put('K', 6196);
        distribution.put('O', 33209);
        distribution.put('S', 34011);
        distribution.put('W', 16496);
        distribution.put('[', 2085);
        distribution.put('_', 71);
        distribution.put('c', 66688);
        distribution.put('g', 57035);
        distribution.put('k', 29212);
        distribution.put('o', 281391);
        distribution.put('s', 214978);
        distribution.put('w', 72894);
        distribution.put('\n', 124456);
        distribution.put('"', 470);
        distribution.put('&', 21);
        distribution.put('*', 63);
        distribution.put('.', 78025);
        distribution.put('2', 366);
        distribution.put('6', 63);
        distribution.put(':', 1827);
        distribution.put('>', 441);
        distribution.put('B', 15413);
        distribution.put('F', 11713);
        distribution.put('J', 2067);
        distribution.put('N', 27338);
        distribution.put('R', 28970);
        distribution.put('V', 3580);
        distribution.put('Z', 532);
        distribution.put('b', 46543);
        distribution.put('f', 68803);
        distribution.put('j', 2712);
        distribution.put('n', 215924);
        distribution.put('r', 208894);
        distribution.put('v', 33989);
        distribution.put('z', 1099);
        distribution.put('~', 1);
        distribution.put('!', 8844);
        distribution.put('%', 1);
        distribution.put(')', 629);
        distribution.put('-', 8074);
        distribution.put('1', 928);
        distribution.put('5', 82);
        distribution.put('9', 948);
        distribution.put('=', 1);
        distribution.put('A', 44486);
        distribution.put('E', 42583);
        distribution.put('I', 55806);
        distribution.put('M', 15872);
        distribution.put('Q', 1178);
        distribution.put('U', 14129);
        distribution.put('Y', 9099);
        distribution.put(']', 2077);
        distribution.put('a', 244664);
        distribution.put('e', 404621);
        distribution.put('i', 198184);
        distribution.put('m', 95580);
        distribution.put('q', 2404);
        distribution.put('u', 114818);
        distribution.put('y', 85271);
        distribution.put('}', 2);
    }


    private static List<Integer> numerify(String s) {
        List<Integer> result = new ArrayList<Integer>();
        if (s.length() % 2 != 0) throw new RuntimeException("Illegal String Length");
        for (int i = 0 ; i < s.length() ; i += 2) {
            result.add(Integer.parseInt(s.substring(i,i+2),16));
        }
        return result;
    }

    private static List<Integer> xor(List<Integer> a,List<Integer>b) {
        if (a.size() != b.size()) throw new RuntimeException("List length mismatch");
        List<Integer> result = new ArrayList<Integer>();
        for (int i = 0 ; i < a.size() ; ++i) {
            result.add((a.get(i) ^ b.get(i))&0xff);
        }
        return result;
    }

    private static List<Integer> xor(List<Integer> a,int b) {
        List<Integer> result = new ArrayList<Integer>();
        for (int i = 0 ; i < a.size() ; ++i) {
            result.add((a.get(i) ^ b)&0xff);
        }
        return result;
    }

    private static String stringify(List<Integer> ints) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0 ; i < ints.size() ; ++i ) {
            sb.append((char)ints.get(i).intValue());
        }
        return sb.toString();
    }

    private static List<Integer> stripe(List<List<Integer>> lists,int item){
        List<Integer> result = new ArrayList<>();

        for (List<Integer> list : lists) {
            if (item >= list.size()) continue;
            result.add(list.get(item));
        }
        return result;
    }

    private static int grade(List<Integer> list) {
        int result = 0;
        for (int item : list) {
            if (item < 32) return -1;
            char citem = (char)item;
            if (distribution.containsKey(citem)) result += distribution.get(citem);
        }
        return result;
    }



    private static class KeyInfo {
        int keyval;
        int grade;
        public KeyInfo(int keyval,int grade) { this.keyval = keyval; this.grade = grade; }
    }


    private static List<Integer> getorderedkeys(List<Integer> list) {
        List<KeyInfo> keypairs = new ArrayList<>();

        for (int i = 0 ; i < 256 ; ++i) {
            List<Integer> toGrade = xor(list,i);
            int grade = grade(toGrade);
            keypairs.add(new KeyInfo(i,grade));
        }
        Collections.sort(keypairs,(a,b)-> b.grade - a.grade);
        return keypairs.stream().map(kp->kp.keyval).collect(Collectors.toList());
    }



    private static int bestgrade(List<Integer> list) {
       return getorderedkeys(list).get(0);
    }


    private static List<Integer> getbestkey(List<List<Integer>> lists,int longest) {
        List<Integer> result = new ArrayList<>();
        for (int i = 0 ; i < longest ; ++i) {
            List<Integer> stripe = stripe(lists,i);
            result.add(bestgrade(stripe));
        }
        return result;
    }

    private static List<Integer> decrypt(List<Integer> cypher,List<Integer> onetimepad) {
        return xor(cypher,onetimepad.subList(0,cypher.size()));
    }


    public static void main(String[] args) {
        setupDistribution();
        System.out.println(stringify(xor(numerify(key1),numerify(ctx1))));
        List<List<Integer>> cyphers = new ArrayList<>();
        int longest = 0;
        for (String c : cypherstrings) {
            List<Integer> cypher = numerify(c);
            cyphers.add(cypher);
            if (cypher.size() > longest) longest = cypher.size();
        }
        System.out.println("# of strings: " + cyphers.size() + " Largest: " + longest);
        List<Integer> key = getbestkey(cyphers,longest);
        System.out.println("Key: " + key);


        System.out.print("   ");
        for (int i = 0 ; i < 10 ; ++i) {
            for (int j = 0 ; j < 16 ; ++j ) {
                System.out.print(Integer.toHexString(i));
            }
        }
        System.out.println("");

        System.out.print("   ");
        for (int i = 0 ; i < 10 ; ++i) {
            System.out.print("0123456789ABCDEF");
        }
        System.out.println("");

        for (int i = 0 ; i < cyphers.size() ; ++i) {
            List<Integer> cypher = cyphers.get(i);
            System.out.format("%02d %s%n",i,stringify(decrypt(cypher,key)));
        }

        List<List<Integer>> keyblock = new ArrayList<>();
        for (int i = 0 ; i < longest ; ++i) {
            keyblock.add(getorderedkeys(stripe(cyphers,i)));
        }


        BlockContainer bc = new BlockContainer(cyphers,keyblock);
        MyGridListener mgl = new MyGridListener(bc);

        ClickableGridPanel cgp = new ClickableGridPanel(1800,800,mgl,null);
        cgp.addCellClicker(mgl);
        mgl.setPainter(cgp);

        SinglePanelFrame spf = new SinglePanelFrame("One Time Pad Solver",cgp);




    }
}
