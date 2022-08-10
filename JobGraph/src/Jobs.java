import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;


@XmlRootElement(name="jobs")
public class Jobs {
    @XmlElement(name="job")
    ArrayList<Job> jobs;
}
