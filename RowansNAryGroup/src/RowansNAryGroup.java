
// Rowan McKee posits the following:
//
//  given a set S with 4 elements { 0, 1, 2, 3 }
//  and a ternary operator T such that for a,b,c ∈ S, T(a,b,c) ∈ S
//
// * T is ASSOCIATIVE: ∀ a,b,c,d,e ∈ S, T(a,b,T(c,d,e)) = T(a,T(b,c,d),e) = T(T(a,b,c),d,e)
// * T on S has an IDENTITY: ∀ all a ∈ S, T(a,0,1) = T(0,a,1) = T(0,1,a) = a
// * all elements of S have a unique 0_INVERSE under T: ∀ a ∈ S, ∃ unique v ∈ S s.t. T(a,v,v) = T(v,a,v) = T(v,v,a) = 0
// * all elements of S have a unique 1_INVERSE under T: ∀ a ∈ S, ∃ unique w ∈ S s.t. T(a,w,w) = T(w,a,w) = T(w,w,a) = 1
// * for a given a ∈ S, 0_INVERSE != 1_INVERSE



// to rephrase, for all a ∈ S, given this table:
// T(a,0,0)   T(0,a,0)   T(0,0,a)
// T(a,1,1)   T(1,a,1)   T(1,1,a)
// T(a,2,2)   T(2,a,2)   T(2,2,a)
// T(a,3,3)   T(3,a,3)   T(3,3,a)
// EXACTLY one row will be all 0, EXACTLY one row will be all 1, and the other two rows
// are can have any values as long as they are not all 0 or all 1

// Rowan isn't sure about this inverse thing.


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class RowansNAryGroup {
    public static void main(String[] args) {
        List<Integer> theset = new ArrayList<>();
        theset.add(0); theset.add(1); theset.add(2);

        try {
            Operator op = new Operator(theset, 3, "ternaryoperatororder3.csv");

            System.out.println("Associativity: " + AssociativityValidator.validate(op));

        } catch (Exception ex) {
            System.out.println("Exception Caught: " + ex);
        }

    }
}
