import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class CalculationNode {
    private static Set<CalculationNode> allNodes = new HashSet<>();

    Resource resource;          // the resource that this calcuation is for
    Resource recipeResource;   // what resource's recipe is managing the calculation

    double rate = 0.0;

    public void remove() {
        resource.removeResourceNode(this);
        recipeResource.removeRecipeNode(this);
        allNodes.remove(this);
    }

    public CalculationNode(Resource resource, Resource recipeResource) {
        this.resource = resource;
        this.recipeResource = recipeResource;
        resource.addResourceNode(this);
        recipeResource.addRecipeNode(this);
        allNodes.add(this);
    }

    public Resource getResource() { return resource; }
    public Resource getRecipeResource() { return recipeResource; }
    public void setRate(double rate) { this.rate = rate; }
    public double getRate() { return rate; }

    public static Collection<CalculationNode> getAllActiveNodes() { return allNodes; }

}
