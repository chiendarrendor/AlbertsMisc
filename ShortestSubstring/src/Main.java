public class Main {

    private static void go(ShortestSubstring ss,String input,String charset) {
        StringPos sp = ss.shortestSubstring(input,charset);
        System.out.println("Position: " + sp.position);
        if (sp.position != -1) {
            System.out.println("Length: " + sp.length);
            System.out.println("Substring: " + input.substring(sp.position,sp.position+sp.length));
        }
    }

    private static void tests(ShortestSubstring ss) {
        String input = "Now is the time for all good men to come to the aid of their party.";
        System.out.println("SS: " + ss);
        go(ss,input,"h");
        go(ss,input,"himtt");
        go(ss,input,"himtta");
        go(ss,input,"ttt");
    }


    public static void main(String[] args) {

        tests(new RecursiveShortestSubstring());
        tests(new NaiveShortestSubstring());
        tests(new FasterShortestSubstring());
        tests(new BackAndForthShortestSubstring());
    }
}
