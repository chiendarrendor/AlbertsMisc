
import java.util.*;

public class MissionState
{
	public Vector<MissionEnvironment> environments = new Vector<MissionEnvironment>();
	public Vector<MissionEvent> events = new Vector<MissionEvent>();
	
	public MissionState()
	{
		environments.add(new MissionEnvironment());
	}
	
	public MissionEnvironment GetCurrentEnvironment()
	{
		return environments.lastElement();
	}
	
	public void MakeNewEnvironment()
	{
		environments.add(new MissionEnvironment(GetCurrentEnvironment()));
	}
	
	public boolean DumpEnvironment()
	{
		if (environments.size() == 1) return false;
		environments.remove(environments.size()-1);
		return true;
	}
		
	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("Env:\n");
		sb.append(GetCurrentEnvironment().toString());
		for (MissionEvent mev : events)
		{
			sb.append(mev.toString());
		}
		return sb.toString();
	}
	
	public Vector<MissionEvent> GetAvailableEvents()
	{
		Vector<MissionEvent> result = new Vector<MissionEvent>();
		for (MissionEvent mev : events)
		{
			if (!mev.IsAvailable(GetCurrentEnvironment())) continue;
			result.add(mev);
		}
		return result;
	}
	
	private Vector<String> GetAvailableConditionNamesOfType(MissionCondition.ConditionType type)
	{
		TreeSet<String> uvset = new TreeSet<String>();
		Vector<MissionEvent> avails = GetAvailableEvents();
		
		for(MissionEvent mev : avails)
		{
			for (MissionCondition mc : mev.GetConditions())
			{
				if (mc.GetType() != type) continue;
				uvset.add(mc.GetName());
			}
		}
		
		return new Vector<String>(uvset);		
}
	
	public Vector<String> GetUsedVars() { return GetAvailableConditionNamesOfType(MissionCondition.ConditionType.VARIABLE); }
	public Vector<String> GetUsedTimers() { return GetAvailableConditionNamesOfType(MissionCondition.ConditionType.TIMER); }
	public Vector<String> GetOtherConditions() { return GetAvailableConditionNamesOfType(MissionCondition.ConditionType.OTHER); }


		
}