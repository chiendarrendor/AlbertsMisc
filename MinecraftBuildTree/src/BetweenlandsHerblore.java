import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class BetweenlandsHerblore {

    private static class Aspected {
        String name;
        Set<String> aspects = new HashSet<>();

        public Aspected(String name) { this.name = name; }
        public void addAspect(String asp) { aspects.add(asp); }

        public String toString() {
            StringBuffer sb = new StringBuffer();
            sb.append(name).append(":");
            aspects.stream().forEach(x->sb.append(' ').append(x));
            return sb.toString();
        }

    }

    private static class AspectedSet {
        List<Aspected> items = new ArrayList<>();

        public AspectedSet(String fname,int startcol) {
            try {
                BufferedReader br = new BufferedReader(new FileReader(fname));
                String line;

                Map<Integer,String> colToAspect = null;


                while((line = br.readLine()) != null) {
                    String[] fields = line.split(",",-1);

                    if (colToAspect == null) {
                        colToAspect = new HashMap<>();

                        for (int i = startcol ; i < fields.length ; ++i) {
                            colToAspect.put(i,fields[i]);
                        }

                        continue;
                    }

                    Aspected asp = new Aspected(fields[0]);
                    items.add(asp);
                    for (int i = startcol ; i < fields.length ; ++i) {
                        if (fields[i].length() == 0) continue;
                        asp.addAspect(colToAspect.get(i));
                    }




                }


            } catch (FileNotFoundException e) {
                throw new RuntimeException(e);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        public String toString() {
            StringBuffer sb = new StringBuffer();

            for (Aspected asp : items) {
                sb.append(asp.toString()).append('\n');
            }

            return sb.toString();
        }



    }


    private static int INGSTART = 3;
    private static int POTSTART = 1;

    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Bad Command Line");
            System.exit(1);
        }

        String ingredients_filename = args[0];
        String potions_filename = args[1];

        AspectedSet ingredients = new AspectedSet(ingredients_filename,INGSTART);
        AspectedSet potions = new AspectedSet(potions_filename,POTSTART);

        for (Aspected asp : potions.items) {
            System.out.println(asp);
            for (Aspected ingredient : ingredients.items) {
                Set<String> ingcopy = new HashSet<>(ingredient.aspects);
                ingcopy.removeAll(asp.aspects);

                if (ingcopy.size() > 0) continue;
                System.out.println("  " + ingredient);
            }
        }





    }


}
