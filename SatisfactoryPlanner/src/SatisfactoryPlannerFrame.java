import grid.spring.SinglePanelFrame;

public class SatisfactoryPlannerFrame extends SinglePanelFrame {

    public SatisfactoryPlannerFrame(ResourceManager manager) {
        super("Satisfactory Factory Planner", new SatisfactoryPanel(manager));
    }

}
