
import com.sun.j3d.utils.geometry.Sphere;
import com.sun.j3d.utils.universe.SimpleUniverse;
import com.sun.j3d.utils.geometry.ColorCube;

import javax.media.j3d.*;
import javax.vecmath.Color3f;
import javax.vecmath.Point3d;
import javax.vecmath.Vector3f;


public class SchematicSurvey
{
    public SchematicSurvey()
    {
        SimpleUniverse universe = new SimpleUniverse();
        BranchGroup group = new BranchGroup();
        group.addChild(new ColorCube(0.05f));

        ColorCube cc2 = new ColorCube(.10f);
        TransformGroup tg = new TransformGroup();
        Transform3D xform = new Transform3D();
        Vector3f vector = new Vector3f(.5f,.5f,.0f);
        xform.setTranslation(vector);
        tg.setTransform(xform);
        tg.addChild(cc2);
        group.addChild(tg);

        Sphere sphere = new Sphere(.5f);
        TransformGroup tg2 = new TransformGroup();
        Transform3D xform2 = new Transform3D();
        Vector3f vector2 = new Vector3f(0.5f,-0.7f,0f);
        xform2.setTranslation(vector2);
        tg2.setTransform(xform2);
        tg2.addChild(sphere);
        group.addChild(tg2);


        //Color3f light1Color = new Color3f(1.8f, 0.1f, 0.1f);
        //Color3f light1Color = new Color3f(1.0f,1.0f,1.0f);
        Color3f light1Color = new Color3f(0.1f,1.0f,0.1f);

        BoundingSphere bounds = new BoundingSphere(new Point3d(0.0,0.0,0.0), 100.0);
        Vector3f light1Direction = new Vector3f(4.0f, -7.0f, -12.0f);
        DirectionalLight light1 = new DirectionalLight(light1Color, light1Direction);
        light1.setInfluencingBounds(bounds);
        group.addChild(light1);


        universe.getViewingPlatform().setNominalViewingTransform();
        universe.addBranchGraph(group);
    }


    public static void main(String[] args)
    {
	    System.setProperty("sun.awt.noerasebackground","true");
	    new SchematicSurvey();
    }
}
