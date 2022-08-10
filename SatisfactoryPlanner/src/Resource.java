import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Resource {
    String name;
    Recipe producingRecipe = null;
    int machineCount = 0;
    double desiredNetRate = 0;
    CalculationType calcType = CalculationType.INACTIVE;
    ResourceRetriever retriever;

    public String getName() { return name; }
    public void setNetRate(double rate) { desiredNetRate = rate; }
    public int getMachineCount() { return machineCount; }
    public double getNetRate() { return desiredNetRate; }

    private int shardCount;
    private double multiplier;
    public void setShardCount(int count) {
        if (count < 0 || count > 3) throw new RuntimeException("Illegal Shard Count");
        multiplier = 1.0 + 0.5 * count;
    }
    public int getShardCount() { return shardCount; }
    public double getMultiplier() { return multiplier; }

    public Resource(ResourceRetriever retriever, String name) {
        this.retriever = retriever;
        this.name = name;
        setShardCount(0);
    }

    private Set<CalculationNode> resourceNodes = new HashSet<>();
    private Set<CalculationNode> recipeNodes = new HashSet<>();

    public void removeRecipeNode(CalculationNode node) { recipeNodes.remove(node); }
    public void removeResourceNode(CalculationNode node) { resourceNodes.remove(node); }
    public void addRecipeNode(CalculationNode node) { recipeNodes.add(node); }
    public void addResourceNode(CalculationNode node) { resourceNodes.add(node); }
    public Collection<CalculationNode> getRecipeNodes() { return recipeNodes; }
    public Collection<CalculationNode> getResourceNodes() { return resourceNodes; }

    public void clearRecipe() {
        if (producingRecipe == null) return;
        Set<CalculationNode> doomed = new HashSet<>();
        doomed.addAll(recipeNodes);
        doomed.stream().forEach(n->n.remove());
        producingRecipe = null;
        machineCount = 0;
    }

    public void setRecipe(Recipe recipe) {
        clearRecipe();
        producingRecipe = recipe;
        for (String resourceName : recipe.getAllResources()) {
            Resource resourceResource = retriever.getResource(resourceName);
            // this automatically hooks up all links
            CalculationNode node = new CalculationNode(resourceResource,this);
        }
    }

    public void setNodes() {
        if (producingRecipe == null) return;

        for (CalculationNode cnode : recipeNodes) {
            double reciperate = producingRecipe.getResourceRate(cnode.getResource().getName());
            cnode.setRate(reciperate * machineCount * getMultiplier());
        }
    }


    public void updateForNetRate() {
        if (producingRecipe == null) return;
        double consumption = 0.0;
        double otherproduction = 0.0;

        for (CalculationNode cnode: resourceNodes) {
            if (cnode.getRate() < 0) consumption -= cnode.getRate();
            if (cnode.getRate() > 0 && cnode.getResource() != this) otherproduction += cnode.getRate();
        }

        double rateperfactory = producingRecipe.getResourceRate(getName()) * getMultiplier();
        double desiredRate = consumption - otherproduction + desiredNetRate;

        machineCount = (int) Math.ceil(desiredRate / rateperfactory);
        setNodes();
    }



}
