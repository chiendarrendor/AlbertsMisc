import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;

public class Job {
    String type;
    String name;
    int id;
    String db;
    String table;
    String file;
    String color;

    @XmlElement(name="name")  public void setName(String name) { this.name = name; }
    @XmlAttribute(name="type") public void setType(String type) { this.type = type; }
    @XmlElement(name="id") public void setId(int id) { this.id = id; }
    @XmlElement(name="db") public void setDB(String db) { this.db = db; }
    @XmlElement(name="table") public void setTable(String table) { this.table = table; }
    @XmlElement(name="file") public void setFile(String file) { this.file = file; }
    @XmlElement(name="color") public void setColor(String color) { this.color = color; }


}

