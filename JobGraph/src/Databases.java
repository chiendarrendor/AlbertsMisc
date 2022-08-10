import java.util.HashMap;
import java.util.Map;

public class Databases {
    Map<String,Database> databases = new HashMap<>();

    public void associateTableToDatabase(String dbname,String tablename) {
        if (!databases.containsKey(dbname)) {
            databases.put(dbname,new Database(dbname));
        }
        databases.get(dbname).addTable(tablename);
    }
}
