import java.util.HashMap;
import java.applet.Applet;
import java.awt.Image;
import java.util.Collection;
import java.util.Iterator;
import java.awt.image.ImageObserver;

// a singleton wrapper class around the Applet's getImage method
// that keeps Image objects in memory keyed by their file name.

public class ImageManager
{
  private Applet m_applet;
  private HashMap<String,Image> m_Images;
  private static ImageManager s_TheOne;

  public ImageManager(Applet i_applet)
  {
    m_applet = i_applet;
    m_Images = new HashMap<String,Image>();
    s_TheOne = this;
  }

  public static void addStaticImage(String i_imageName)
  {
    s_TheOne.addImage(i_imageName);
  }


  public void addImage(String i_imageName)
  {
    Image im = m_applet.getImage(m_applet.getDocumentBase(),i_imageName);
    if (im == null)
    {
      System.out.println("Can't find image " + m_applet.getDocumentBase() + "/" + i_imageName);
    }
    m_Images.put(i_imageName,im);
    m_applet.prepareImage(im,m_applet);
  }

  public boolean allLoaded()
  {
    Collection<String> keys = m_Images.keySet();
    Iterator<String> keyit = keys.iterator();
    while(keyit.hasNext())
    {
      String key = keyit.next();
      Image im = m_Images.get(key);
      int status = m_applet.checkImage(im,m_applet);

      if ((status & ImageObserver.ERROR) == ImageObserver.ERROR)
      {
        System.out.println("Error Loading Image " + key);
        throw new RuntimeException("Can't load file " + key);
      }

      if ((status & ImageObserver.ALLBITS) != ImageObserver.ALLBITS)
      {
        return false;
      }
    }
    return true;
  }

  public static Image getImage(String i_imageName)
  {
    Image im = s_TheOne.m_Images.get(i_imageName);
    if (im == null)
    {
      throw new RuntimeException("No such image named " + i_imageName);
    }
    return im;
  }
}

    
