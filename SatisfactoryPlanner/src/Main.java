public class Main {

    private static void printResource(Resource r) {
        System.out.println(r.getName() + " now has " + r.getMachineCount() + " machines.");

        for(CalculationNode cn : r.getRecipeNodes()) {
            System.out.println("Resource " + cn.getResource().getName() + ": " + cn.getRate());
        }
    }


    public static void main(String[] args) {
	    if (args.length != 1) {
	        System.out.println("Bad Command Line");
	        System.exit(1);
        }
        ResourceManager resources = new ResourceManager(args[0]);


        // TODO:
        // total shard count display
        // set resource boxes not on top of each other
        // load/save
        // why does new ResourcePanel() take exponentially longer on each panel?

        SatisfactoryPlannerFrame frame = new SatisfactoryPlannerFrame(resources);
    }
}
