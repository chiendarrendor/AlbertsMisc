import java.util.Collection;
import java.util.Iterator;
import java.applet.AudioClip;
import java.applet.Applet;
import java.util.HashMap;

// singleton wrapper class around the Applet getAudioClip
// method.



public class SoundManager
{
  private class ClipWrapper
  {
    public String name;
    public boolean loaded;
    public AudioClip clip;
  }

  private Applet m_applet;
  private HashMap<String,ClipWrapper> m_Sounds;
  private static SoundManager s_TheOne;

  private class ClipLoader implements Runnable
  {
    private ClipWrapper m_mywrapper;
    public ClipLoader(ClipWrapper i_mywrapper)
    {
      m_mywrapper = i_mywrapper;
    }

    public void run()
    {
      AudioClip ac = m_applet.getAudioClip(m_applet.getDocumentBase(),m_mywrapper.name);
      synchronized(m_Sounds)
      {
        m_mywrapper.loaded = true;
        m_mywrapper.clip = ac;
      }
    }
  }

  public SoundManager(Applet i_applet)
  {
    m_applet = i_applet;
    m_Sounds = new HashMap<String,ClipWrapper>();
    s_TheOne = this;
  }

  public void addSound(String i_soundName)
  {
    ClipWrapper ncw = new ClipWrapper();
    ncw.name = i_soundName;
    ncw.loaded = false;
    ncw.clip = null;
    synchronized(m_Sounds)
    {
      m_Sounds.put(i_soundName,ncw);
    }
    Thread th = new Thread(new ClipLoader(ncw));
    th.run();
  }

  public boolean allSoundsLoaded()
  {
    synchronized(m_Sounds)
    {
      Collection<String> keys = m_Sounds.keySet();
      Iterator<String> keyit = keys.iterator();
      while(keyit.hasNext())
      {
        String key = keyit.next();
        if (m_Sounds.get(key).loaded == false) return false;
      }
      return true;
    }
  }

  private void playOneSound(String i_soundName)
  {
    synchronized(m_Sounds)
    {
      m_Sounds.get(i_soundName).clip.play();
    }
  }

  public static void playSound(String i_soundName)
  {
    s_TheOne.playOneSound(i_soundName);
  }
}


