
import java.util.*;

public class MissionEnvironment
{	
	private class TimerState
	{
		public int seconds;
		public boolean expired;
		public TimerState(int s) { seconds = s; expired = false; }
	}
	
	private Map<String,Double> variables = new TreeMap<String,Double>();
	private Map<String,TimerState> timers = new TreeMap<String,TimerState>();
	private Set<String> others = new TreeSet<String>();
	
	public MissionEnvironment() 
	{
	}
	
	// copy constructor
	public MissionEnvironment(MissionEnvironment original)
	{
		for (Map.Entry<String,Double> ent : original.variables.entrySet()) SetVariable(ent.getKey(),ent.getValue());
		for (Map.Entry<String,TimerState> ent : original.timers.entrySet())
		{
			SetTimer(ent.getKey(),ent.getValue().seconds);
			SetTimerExpiration(ent.getKey(),ent.getValue().expired);
		}
		for (String s : original.others) SetOther(s,true);
	}
	
	void SetVariable(String varname, double value)
	{
		variables.put(varname,value);
	}
	
	boolean IsVariableSet(String varname)
	{
		return variables.containsKey(varname);
	}
	
	double GetVariableValue(String varname)
	{
		if (!IsVariableSet(varname)) return 0.0;
		return variables.get(varname);
	}
	
	void SetTimer(String tname,int time)
	{
		timers.put(tname,new TimerState(time));
	}
	
	void SetTimerExpiration(String tname,boolean expired)
	{
		timers.get(tname).expired = expired;
	}
	
	boolean IsTimer(String tname)
	{
		return timers.containsKey(tname);
	}
	
	int GetTimerLength(String tname)
	{
		if (!IsTimer(tname)) return -1;
		return timers.get(tname).seconds;
	}
	
	boolean TimerExpired(String tname)
	{
		if (!IsTimer(tname)) return false;
		return timers.get(tname).expired;
	}
	
	boolean HasOther(String other)
	{
		return others.contains(other);
	}
	
	void SetOther(String other,boolean isSet)
	{
		if (HasOther(other) && !isSet) others.remove(other);
		if (!HasOther(other) && isSet) others.add(other);
	}
	
	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("MissionEnvironment: " + "\n");
		for(Map.Entry<String,Double> ent : variables.entrySet())
		{
			sb.append(ent.getKey() + " = " + ent.getValue() + "\n");
		}
		for(Map.Entry<String,TimerState> ent : timers.entrySet())
		{
			sb.append("timer " + ent.getKey() + ": " + ent.getValue().seconds + " seconds");
			if (ent.getValue().expired) sb.append(" (expired)");
			sb.append("\n");
		}
		
		for (String o : others)
		{
			sb.append("other: " + o +  "\n");
		}
		
		return sb.toString();
	}
		
	
	
}