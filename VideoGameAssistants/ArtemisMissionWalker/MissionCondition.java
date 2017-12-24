
public class MissionCondition 
{
	public enum ConditionType { VARIABLE,TIMER,OTHER };
	public enum RelOp { EQUALS,NOT,GREATER,LESS,GREATER_EQUAL,LESS_EQUAL};
	
	public static RelOp ParseRelOp(String instr)
	{
		if (instr.equals("=") || instr.equals("EQUALS")) return RelOp.EQUALS;
		if (instr.equals("!=") || instr.equals("NOT")) return RelOp.NOT;
		if (instr.equals(">") || instr.equals("GREATER")) return RelOp.GREATER;
		if (instr.equals("<") || instr.equals("LESS")) return RelOp.LESS;
		if (instr.equals("<=") || instr.equals("LESS_EQUAL")) return RelOp.LESS_EQUAL;
		if (instr.equals(">=") || instr.equals("GREATER_EQUAL")) return RelOp.GREATER_EQUAL;
		throw new RuntimeException("invalid relative operator " + instr);
	}
	
	
	
	private ConditionType type;
	private String name;
	public RelOp op;
	public double value;
	public MissionCondition(String n,RelOp o,double v) { type=ConditionType.VARIABLE; name = n ; op = o ; value = v; }
	public MissionCondition(String n,ConditionType type) { this.type = type; name = n; }

	public ConditionType GetType() { return type; }
	public RelOp GetRelOp() { return op; }
	public double GetValue() { return value; }
	public String GetName() { return name; }
	
	public boolean IsTrue(MissionEnvironment me)
	{
		if (type == ConditionType.OTHER) return me.HasOther(name);
		if (type == ConditionType.TIMER) return me.TimerExpired(name);
	
		if (!me.IsVariableSet(name)) return false;
		double mev = me.GetVariableValue(name);
		switch(op)
		{
		case EQUALS: return mev == value;
		case NOT: return mev != value;
		case GREATER: return mev > value;
		case LESS: return mev < value;
		case GREATER_EQUAL: return mev >= value;
		case LESS_EQUAL: return mev <= value;
		default: return false;
		}
	}
	
	public boolean IsAvailable(MissionEnvironment me)
	{
		if (type == ConditionType.VARIABLE) return IsTrue(me);
		if (type == ConditionType.TIMER) return me.IsTimer(name);
		return true;
	}
	
	public String toString()
	{
		if (type == ConditionType.OTHER) return name;
		if (type == ConditionType.TIMER) return "timer " + name;
		return name + " " + op.name() + " " + value;
	}
	
}