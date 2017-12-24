
import java.util.Vector;


public class MissionEvent
{
	
	private class VarSet
	{
		public String name;
		public double value;
		public VarSet(String n,double v) { name = n ; value = v; }
	}
	
	private class TimerSet
	{
		public String name;
		public int seconds;
		public TimerSet(String n,int s) { name = n ; seconds = s; }
	}
		
		
	private String name;

	private Vector<MissionCondition> conditions = new Vector<MissionCondition>();
	
	private Vector<VarSet> varsets = new Vector<VarSet>();
	private Vector<TimerSet> timersets = new Vector<TimerSet>();
	private Vector<String> otheractions = new Vector<String>();
	
	public MissionEvent(String name)
	{
		this.name = name;
	}
	
	public String GetName() { return name; }
//	public String GetFullName() 
//	{
//		String p = folderset.GetFullFolderName(parentid);
//		if (p.length() > 0) return p + '/' + name;
//		return name;
//	}
	public Vector<MissionCondition> GetConditions() { return conditions; }
	
	public void AddVarCompare(String name,MissionCondition.RelOp op,double value) 
	{ 
		conditions.add(new MissionCondition(name,op,value)); 
	}
	
	public void AddTimerCheck(String name) 
	{ 
		conditions.add(new MissionCondition(name,MissionCondition.ConditionType.TIMER)); 
	}
	
	public void AddOtherCheck(String check) 
	{ 
		conditions.add(new MissionCondition(check,MissionCondition.ConditionType.OTHER)); 
	}
	
	public void AddVarSet(String name,double value) { varsets.add(new VarSet(name,value)); }
	public void AddTimerSet(String name,int seconds) { timersets.add(new TimerSet(name,seconds)); }
	public void AddOtherAction(String action) { otheractions.add(action); }
	
	
	// an event is available iff:
	// every VarCompare is true given the current environment
	// every Timer exists in the current environment
	public boolean IsAvailable(MissionEnvironment me)
	{
		for(MissionCondition mc : conditions)
		{
			if (!mc.IsAvailable(me)) return false;
		}
		return true;
	}
	
	
	// an event is ready iff:
	// it is available
	// all listed timers have expired
	// all other boolean terms are present
	public boolean IsReady(MissionEnvironment me)
	{
		for(MissionCondition mc : conditions)
		{
			if (!mc.IsTrue(me)) return false;
		}
		return true;
	}
	
	public void ActOnEnvironment(MissionEnvironment me)
	{
		for (VarSet vs : varsets) me.SetVariable(vs.name,vs.value);
		for (TimerSet ts : timersets) me.SetTimer(ts.name,ts.seconds);
	}
	
	
	
	
	public String toString()
	{
		StringBuffer sb = new StringBuffer();
		sb.append("Name: " + GetName() + "\n");
		sb.append("IF" + "\n");
		
		for (MissionCondition mc : conditions)
		{
			sb.append("  " + mc.toString() + "\n");
		}
		
		sb.append("THEN" + "\n");
		for (VarSet vs : varsets)
		{
			sb.append("  SET VAR " + vs.name + " = " + vs.value + "\n");
		}
		for (TimerSet ts : timersets)
		{
			sb.append("  SET TIMER " + ts.name + " to " + ts.seconds + " seconds\n");
		}
		for (String other : otheractions)
		{
			sb.append("  AND " + other + "\n");
		}
		sb.append("DONE\n");
		
		return sb.toString();
	}
	
	
}

	