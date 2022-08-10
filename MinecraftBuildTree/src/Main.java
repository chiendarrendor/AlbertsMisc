import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.SimpleDirectedGraph;
import org.jgrapht.traverse.TopologicalOrderIterator;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
    private static class CountObject {
        int count;
        String name;
        public CountObject(String name) { this.name = name; this.count = 0; }
        public CountObject(String name, int count) { this.name = name; this.count = count; }
        public String toString() {
            int stacks = count/64;
            int leftovers = count % 64;
            String stackinfo = "";
            if (stacks > 0) {
                stackinfo = " (" + stacks + "+" + leftovers + ")";
            }
            return "" + count + stackinfo + " copies of " + name;
        }
    }

    private static class Makeable {
        CountObject me;
        List<Makeable> parts = new ArrayList<>();
        int depth = 0;
        StringBuffer comment = new StringBuffer();
        public Makeable(CountObject me) { this.me = me; }
        public Makeable(CountObject me,Makeable parent) { this.me = me; this.depth = parent.depth + 1; }
        public String getComment() { return comment.toString(); }
    }


    private static Map<String,Makeable> database = new HashMap<String, Makeable>();
    private static SimpleDirectedGraph<String,DefaultEdge> depgraph = new SimpleDirectedGraph<String, DefaultEdge>(DefaultEdge.class);

    public static void makeDatabase(String fname) {
        Pattern commentpattern = Pattern.compile("^# ?(.*)$");
        Pattern linepattern = Pattern.compile("(-> )?(\\d+) (.*)");
        Makeable curmake = null;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(fname));

            String line = null;
            while((line = reader.readLine()) != null) {
                if (line.length() == 0) continue;


                Matcher cm = commentpattern.matcher(line);
                if (cm.matches()) {
                    if (curmake != null) {
                        curmake.comment.append(cm.group(1));
                    }
                    continue;
                }


                Matcher m = linepattern.matcher(line);
                if (!m.find()) {
                    System.out.println("Couldn't match line: " + line);
                } else {
                    CountObject thing = new CountObject(m.group(3),Integer.parseInt(m.group(2)));

                    if (m.group(1) == null) {
                        if (database.containsKey(thing.name)) {
                            System.out.println("Duplicate Recipe for " + thing.name);
                            System.exit(1);
                        }

                        curmake = new Makeable(thing);
                        database.put(curmake.me.name,curmake);
                        depgraph.addVertex(thing.name);
                    } else {
                        if (curmake == null) {
                            System.out.println("Bad file: child outside of parent");
                            System.exit(1);
                        }

                        curmake.parts.add(new Makeable(thing));
                        depgraph.addVertex(thing.name);
                        depgraph.addEdge(curmake.me.name,thing.name);
                    }
                }
            }
            reader.close();
        } catch (FileNotFoundException e) {
            System.out.println("File Not Found");
            System.exit(1);
        } catch (IOException e) {
            System.out.println("IOException: " + e);
            System.exit(1);
        }
    }

    public static SimpleDirectedGraph<String,DefaultEdge> makeDependencySubgraph(String root) {
        SimpleDirectedGraph<String,DefaultEdge> result = new SimpleDirectedGraph<String, DefaultEdge>(DefaultEdge.class);
        fillDependencies(result,root);
        return result;
    }

    private static void fillDependencies(SimpleDirectedGraph<String,DefaultEdge> graph, String curnode) {
        if (!depgraph.containsVertex(curnode)) {
            System.out.println("Node " + curnode + " isn't in master dependency graph!");
            System.exit(1);
        }
        graph.addVertex(curnode);
        for (DefaultEdge e : depgraph.outgoingEdgesOf(curnode)) {
            String child = depgraph.getEdgeTarget(e);

            graph.addVertex(child);
            graph.addEdge(curnode,child);
            fillDependencies(graph,child);
        }
    }










    public static void main(String[] args) {
        if (args.length != 3) {
            System.out.println("bad command line <build db> <thing to build> <how many to build>");
            System.exit(1);
        }
        String fname = args[0];
        String root = args[1];
        int buildcount = Integer.parseInt(args[2]);

        makeDatabase(fname);

        List<String> workorder = new ArrayList<>();
        Map<String,CountObject> newbom = new HashMap<>();

        SimpleDirectedGraph<String,DefaultEdge> subgraph = makeDependencySubgraph(root);
        TopologicalOrderIterator<String,DefaultEdge> iter = new TopologicalOrderIterator<>(subgraph);

        while(iter.hasNext()) {
            String curthing = iter.next();
            if (subgraph.outDegreeOf(curthing) > 0) workorder.add(0,curthing);

            if (subgraph.inDegreeOf(curthing) == 0) {
                if (!curthing.equals(root)) {
                    System.out.println("Confused!  Root of DAG should be root item " + root);
                    System.exit(1);
                }
                newbom.put(curthing,new CountObject(curthing,buildcount));
                continue;
            }

            // if we get here, then we are a thing that is used to make other things.
            // furthermore, the topo-sort should provide that we know everything we need to know about
            // the set of things that need us in order to be made.

            int selfcopies = 0;
            for (DefaultEdge e : subgraph.incomingEdgesOf(curthing)) {
                String parent = subgraph.getEdgeSource(e);
                int parentbuildcount = newbom.get(parent).count;

                Makeable parentrecipe = database.get(parent);
                int parentoutputcount = parentrecipe.me.count;

                int parentreciperuncount = parentbuildcount / parentoutputcount + ((parentbuildcount % parentoutputcount > 0) ? 1 : 0);

                int selfcopiesperrecipe = -1;
                for (Makeable possiblechild : parentrecipe.parts) {
                    if (possiblechild.me.name.equals(curthing)) {
                        selfcopiesperrecipe = possiblechild.me.count;
                        break;
                    }
                }
                if (selfcopiesperrecipe == -1) {
                    System.out.println("Can't find " + curthing + " in recipe for " + parentrecipe.me.name);
                    System.exit(1);
                }

                selfcopies += parentreciperuncount * selfcopiesperrecipe;
            }

            if (selfcopies == 0) selfcopies = 1;
            newbom.put(curthing,new CountObject(curthing,selfcopies));
        }

        for (String s : subgraph.vertexSet()) {
            if (subgraph.outDegreeOf(s) == 0) System.out.println(newbom.get(s).toString());
        }

        System.out.println("-------------------------");

        for (String s : workorder) {
            Makeable dbent = database.get(s);
            int outputcount = dbent.me.count;
            int amountcount = newbom.get(s).count;
            int runcount = amountcount / outputcount + ((amountcount % outputcount) > 0 ? 1 : 0);

            String where = "Crafting Table";
            if (dbent.getComment().length() > 0) {
                where = dbent.getComment();
            }
            System.out.print("In a " + where + ", turn");
            for (Makeable child : dbent.parts) {
                if (child.me.count == 0 || runcount == 0) continue;
                System.out.print(" " + (child.me.count) * runcount + "  " + child.me.name +",");
            }
            System.out.println(" into " + amountcount + " " + s);

        }
    }
}
