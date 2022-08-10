import org.jgraph.graph.DefaultEdge;
import org.jgrapht.graph.SimpleDirectedGraph;
import org.jgrapht.graph.SimpleGraph;
import org.jgrapht.traverse.TopologicalOrderIterator;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ResourceManager implements ResourceRetriever{
    Map<String,Resource> resources = new HashMap<>();
    Map<String,Recipe> recipesByName = new HashMap<>();
    Map<String,List<Recipe>> recipesByOutputResource = new HashMap<>();

    public ResourceManager(String fname) {
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING,true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document recipeXML = db.parse(new File(fname));

            NodeList recipes = recipeXML.getElementsByTagName("recipe");
            for (int i = 0 ; i < recipes.getLength() ; ++i) {
                Element recipeElement  = (Element)recipes.item(i);

                Recipe recipe = new Recipe(recipeElement);
                recipesByName.put(recipe.getName(),recipe);
                for (String resource : recipe.getOutputResources()) {
                    if (!recipesByOutputResource.containsKey(resource)) {
                        recipesByOutputResource.put(resource,new ArrayList<>());
                    }
                    recipesByOutputResource.get(resource).add(recipe);
                }
                for (String resource : recipe.getAllResources()) {
                    if (!resources.containsKey(resource)) {
                        resources.put(resource,new Resource(this,resource));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Collection<String> getRecipeNames() { return recipesByName.keySet(); }
    public Recipe getRecipe(String name) { return recipesByName.get(name); }
    public Collection<String> getResourceNames() { return resources.keySet(); }
    public Resource getResource(String name) { return resources.get(name); }

    public Collection<Recipe> getRecipesForResource(String resource) {
        return recipesByOutputResource.get(resource);
    }



    public Collection<String> getActiveResourceNames() {
        Set<String> result = new HashSet<>();
        for (CalculationNode node : CalculationNode.getAllActiveNodes()) {
            result.add(node.getResource().getName());
        }
        return result;
    }

    public Collection<CalculationNode> getActiveNonLoopEdges() {
        List<CalculationNode> result = new ArrayList<>();
        for (CalculationNode node : CalculationNode.getAllActiveNodes()) {
            if (node.getResource() == node.getRecipeResource()) continue;
            result.add(node);
        }
        return result;
    }

    public void updateAllForNetRate() {
        SimpleDirectedGraph<String,DefaultEdge> dependencies = new SimpleDirectedGraph<>(DefaultEdge.class);
        getActiveResourceNames().stream().forEach(name->dependencies.addVertex(name));
        getActiveNonLoopEdges().stream().forEach(node->dependencies.addEdge(node.getResource().getName(),node.getRecipeResource().getName()));

        List<String> ordered = new ArrayList<>();
        TopologicalOrderIterator<String,DefaultEdge> toi = new TopologicalOrderIterator(dependencies);
        while(toi.hasNext()) {
            String item = toi.next();
            ordered.add(item);
        }
        Collections.reverse(ordered);
        for (String s : ordered) {
            getResource(s).updateForNetRate();
        }
    }




}
