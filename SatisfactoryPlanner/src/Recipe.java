
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Recipe {
    String name;
    String machine;
    double productionRate; // # of items/min for 'rateOutput' resource
    Map<String,Integer> inputs = new HashMap<String, Integer>(); // volume is rate per recipe
    Map<String,Integer> outputs = new HashMap<String, Integer>(); // volume is rate per recipe
    String rateOutput = null; // which output resource is the productionRate associated with?

    public String getName() { return name;}
    public Collection<String> getOutputResources() { return outputs.keySet(); }
    public Collection<String> getInputResources() { return inputs.keySet(); }
    public Collection<String> getAllResources() { return ratesPerMinute.keySet(); }
    public double getResourceRate(String name) { return ratesPerMinute.get(name); }

    private double recipesPerMinute;
    private Map<String,Double> ratesPerMinute = new HashMap<String, Double>(); // volume is rate per minute, with inputs having a negative rate

    private void calculateRates() {
        if (rateOutput == null || !outputs.containsKey(rateOutput)) throw new RuntimeException("Insufficient data to calculate recipe rates");
        recipesPerMinute = productionRate / outputs.get(rateOutput);

        for (String resource : inputs.keySet()) {
            ratesPerMinute.put(resource,-1.0 * recipesPerMinute * inputs.get(resource));
        }
        for (String resource:  outputs.keySet()) {
            ratesPerMinute.put(resource, recipesPerMinute * outputs.get(resource));
        }
    }

    public Recipe(Element element) {
        name = element.getAttribute("name");
        machine = element.getAttribute("building");
        productionRate = Double.parseDouble(element.getAttribute("rate"));
        NodeList inputList = element.getElementsByTagName("input");
        for(int i = 0 ; i < inputList.getLength() ; ++i) {
            Element inputElement = (Element)inputList.item(i);
            inputs.put(inputElement.getAttribute("resource"),
                    Integer.parseInt(inputElement.getAttribute("amount")));
        }
        NodeList outputList = element.getElementsByTagName("output");
        for (int i = 0 ; i < outputList.getLength() ; ++i) {
            Element outputElement = (Element)outputList.item(i);
            if (rateOutput == null) rateOutput = outputElement.getAttribute("resource");
            outputs.put(outputElement.getAttribute("resource"),
                    Integer.parseInt(outputElement.getAttribute("amount")));
        }
        calculateRates();
    }

    @Override public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("Recipe: " + name + " using " + machine + " at " + recipesPerMinute + " recipes per minute\n");
        for (String resource : ratesPerMinute.keySet()) {
            sb.append("  " + resource + ": " + ratesPerMinute.get(resource) + "\n");
        }

        return sb.toString();
    }
}
