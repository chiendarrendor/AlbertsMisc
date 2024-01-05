import java.util.Iterator;
import java.util.List;

public class AssociativityValidator {
    public static boolean validate(Operator op) {

        // the associativity calculation is based on the with of the operator...an inner operation calculation must be
        // held at every position of the outer operation, so the total width of independent variables is 2 * width - 1
        // the associativity equality must be calculated with the inner operation at every argument of the outer

        // the counting array keeps track of the numeric index
        for (CountingArray cot = new CountingArray(op.getOpSet().size(),op.getWidth()+op.getWidth() - 1); ; cot.increment()) {

            Integer calcval = null;

            for (int outerpos = 0 ; outerpos < op.getWidth() ; ++outerpos) {
                // outerpos is "which position of the outer operation contains the inner operation"
                // it is also the starting index of the arguments for innerpos.
                int[] ipary = new int[op.getWidth()];
                for (int i = 0 ; i < op.getWidth() ; ++i) ipary[i] = op.getOrderedSet()[cot.getCounter(i+outerpos)]; // make the ipary the proper arg list for inner op
                int innerresult = op.op(ipary);
                int[] opary = new int[op.getWidth()];

                int coutidx = 0;
                for (int i = 0 ; i < op.getWidth() ; ++i) {
                    if (i != outerpos) {
                        opary[i] = op.getOrderedSet()[cot.getCounter(coutidx)];
                        ++coutidx;
                    } else {
                        opary[i] = innerresult;
                        coutidx += op.getWidth();
                    }
                }

                int outterresult = op.op(opary);

                if (calcval == null) {
                    calcval = Integer.valueOf(outterresult);
                } else {
                    if (calcval != outterresult) return false;
                }
            }
            // this is here in to allow the 0 and max  states of CountingArray to both be processed.
            if (cot.isMax()) break;
        }

        return true;

    }
}
