import java.util.HashSet;
import java.util.Set;

public class Database
{
    String name;
    Set<String> tables = new HashSet<>();

    public Database(String name) { this.name = name; }

    public void addTable(String name) { tables.add(name); }

}
