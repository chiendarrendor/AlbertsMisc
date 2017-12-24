
// properties to load
// folder_arme: name_arme id_arme (parent_id_arme)
// event: name_arme (parent_id_arme)
// within start:
//   set_variable
//   set_timer
//   (everything else)
// within event
//   if_variable
//   if_timer_finished
//   (all other ifs)
//   ----
//   set_variable
//   set_timer
//   (all other non-ifs)

// there are three kinds of event conditions:
// 1) variables: set value inherently controlled by game events, so firing is automatic
// 2) timers: presence inherently controlled by game events, firing is manually controlled
// 3) everything else: firing is manually controlled.


import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.io.File;
import java.io.StringWriter;
import java.util.Vector;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMSource;

public class MissionReader
{
	private FolderSet folderset = new FolderSet();
	
	private MissionState state = new MissionState();
	
	
	public MissionReader(String filename)
	{
		int unknowneventid = 1;
		try
		{
			File f = new File(filename);
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbf.newDocumentBuilder();
			Document doc = dBuilder.parse(f);
			doc.getDocumentElement().normalize();
			
			// process all folders.
			NodeList folders = doc.getElementsByTagName("folder_arme");
			for (int i = 0 ; i < folders.getLength() ; ++i)
			{
				Element folder = (Element)folders.item(i);
				String foldname = folder.getAttribute("name_arme");
				String foldid = folder.getAttribute("id_arme");
				String foldpar = folder.hasAttribute("parent_id_arme") ? folder.getAttribute("parent_id_arme") : null;
				folderset.AddFolder(foldname,foldid,foldpar);
			}
			
			// process all events.
			NodeList events = doc.getElementsByTagName("event");
			for (int i = 0 ; i < events.getLength() ; ++i)
			{
				Element event = (Element)events.item(i);
				String name = null;
				// try to figure out what this event should be called.
				// if it has a 'name' attribute, use that
				if (event.hasAttribute("name"))
				{
					name = event.getAttribute("name");
				}
				// if it was created by the ARME, figure out what to do there.
				else if (event.hasAttribute("name_arme"))
				{
					name = event.getAttribute("name_arme");
					if (event.hasAttribute("parent_id_arme"))
					{
						String p = folderset.GetFullFolderName(event.getAttribute("parent_id_arme"));
						if (p.length() > 0)
						{
							name = p + '/' + name;
						}
					}
				}
				// ok..so no 'name' and no 'name_arme'... make something up.
				else
				{
					name = "Unknown Event " + unknowneventid++;
				}
					
				MissionEvent mev = new MissionEvent(name);
				state.events.add(mev);
				ProcessEventInternals(mev,event);
			}
			
			// create initial environment.
			NodeList starts = doc.getElementsByTagName("start");
			Node start = starts.item(0);
			NodeList startchildren = start.getChildNodes();
			for (int i = 0 ; i < startchildren.getLength() ; ++i)
			{
				Node child = startchildren.item(i);
				if (child.getNodeType() != Node.ELEMENT_NODE) continue;
				Element chel = (Element)child;
				if (chel.getNodeName().equals("set_variable"))
				{
					state.GetCurrentEnvironment().SetVariable(chel.getAttribute("name"),Double.parseDouble(chel.getAttribute("value")));
				}
				else if (chel.getNodeName().equals("set_timer"))
				{
					state.GetCurrentEnvironment().SetTimer(chel.getAttribute("name"),Integer.parseInt(chel.getAttribute("seconds")));
				}
			}
		}
		catch(Exception e)
		{
			throw new RuntimeException("parsing mission file",e);
		}
	}
	
	private void ProcessEventInternals(MissionEvent mev,Element event) throws TransformerConfigurationException,TransformerException
	{
		NodeList children = event.getChildNodes();
		for (int i = 0 ;  i < children.getLength() ; ++i)
		{
			Node child = children.item(i);
			if (child.getNodeType() != Node.ELEMENT_NODE) continue;
			Element chel = (Element)child;
			
			if (chel.getNodeName().equals("if_variable"))
			{
				mev.AddVarCompare(chel.getAttribute("name"),
								  MissionCondition.ParseRelOp(chel.getAttribute("comparator")),
								  Double.parseDouble(chel.getAttribute("value")));
			}
			else if (chel.getNodeName().equals("if_timer_finished"))
			{
				mev.AddTimerCheck(chel.getAttribute("name"));
			}
			else if (chel.getNodeName().startsWith("if_"))
			{
				mev.AddOtherCheck(NodeXML(chel));
			}
			else if (chel.getNodeName().equals("set_variable"))
			{
				mev.AddVarSet(chel.getAttribute("name"),
							  Double.parseDouble(chel.getAttribute("value")));
			}
			else if (chel.getNodeName().equals("set_timer"))
			{
				mev.AddTimerSet(chel.getAttribute("name"),
								Integer.parseInt(chel.getAttribute("seconds")));
			}
			else
			{
				mev.AddOtherAction(NodeXML(chel));
			}
		}
	}
	
	private String NodeXML(Node node) throws TransformerConfigurationException,TransformerException
	{
		TransformerFactory transfac = TransformerFactory.newInstance();
		Transformer trans = transfac.newTransformer();
		trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION,"yes");
		StringWriter sw = new StringWriter();
		StreamResult result = new StreamResult(sw);
		DOMSource source = new DOMSource(node);
		trans.transform(source,result);
		return sw.toString();
	}

	public MissionState GetMissionState()
	{
		return state;
	}
	
}
