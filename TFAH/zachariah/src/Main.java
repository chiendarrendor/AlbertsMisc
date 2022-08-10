import OnTheFlyAStar.AStar;

public class Main {

    public static void main(String[] args) {
        State s = new State();
        AStar.AStarSolution<State> solution = AStar.execute(s);
        //System.out.println("Test Grade: " + s.getGrade());


    }
}
