import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import java.io.File;

public class Main {
    /**
     * This progam will take an XML file describing DataNet jobs and produce the
     * GraphViz DOT language visualizing the relationships between the tables, databases, and jobs
     * @param args
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("bad command line");
            System.exit(1);
        }

        Jobs jobs = null;

        try
        {
            JAXBContext context = JAXBContext.newInstance(Jobs.class);
            Unmarshaller unm = context.createUnmarshaller();
            jobs = (Jobs)unm.unmarshal(new File(args[0]));
        } catch (JAXBException e)
        {
            e.printStackTrace();
        }

        Databases dbs = new Databases();
        NodeDictionary nd = new NodeDictionary();

        for (Job j : jobs.jobs) {
            dbs.associateTableToDatabase(j.db,j.table);
            nd.getNodeId(j.file,true);
        }

        System.out.println("strict digraph G {");

        int idx = 0;
        for (Database db : dbs.databases.values()) {
            System.out.println("  subgraph cluster_" + idx++ + " {");
            System.out.println("    label=\"" + db.name + "\";");
            for (String table : db.tables) {
                int nodeid = nd.getNodeId(db.name + "_" + table);
                System.out.println("    " + nodeid + " [label=\"" + table + "\"];");
            }
            System.out.println("  }");
        }

        for (String fname : nd.getFiles()) {
            System.out.println("  " + nd.getNodeId(fname) + " [label=\"" + fname + "\"];");
        }

        for (Job j : jobs.jobs) {
            int dbid = nd.getNodeId(j.db + "_" + j.table);
            int fid = nd.getNodeId(j.file);

            String type;
            if ("extract".equals(j.type)) {
                System.out.print("  " + dbid + "->" + fid);
                type = "E";

            } else {
                System.out.print("  " + fid + "->" + dbid);
                type = "L";
            }
            System.out.print(" [label=\"" + j.name + "(" + type + j.id + ")\"");
            if (j.color != null) System.out.print(" color=\"" + j.color + "\"");

            System.out.println("];");
        }



        System.out.println("}");

        System.out.println("");
    }
}
