import java.awt.Panel;
import javax.swing.BoxLayout;
import java.awt.Label;
import java.awt.Choice;
import java.awt.Checkbox;
import java.awt.Button;
import java.awt.CardLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class WoodPieceMenu extends Panel implements ActionListener,WoodPieceChanger
{
  Panel m_mainpanel;
  GiltHeadEngine m_ghe;

  Choice m_colors;
  Choice m_shapes;
  Checkbox m_knotty;
  Button m_gobutton;

  WoodPiece m_woodpiece;

  public WoodPieceMenu(Panel i_mainpanel)
  {
    m_mainpanel = i_mainpanel;
    m_woodpiece = null;
    m_ghe = null;

    setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
    add(new Label("Piece Color:"));
    m_colors = new Choice();
    m_colors.add("Red");
    m_colors.add("Orange");
    m_colors.add("Yellow");
    m_colors.add("Green");
    m_colors.add("Cyan");
    m_colors.add("Blue");
    m_colors.add("Purple");
    m_colors.add("Magenta");
    m_colors.add("Cedar Lion");
    m_colors.add("Iron Fish");
    add(m_colors);
    add(new Label("Piece Shape:"));
    m_shapes = new Choice();
    m_shapes.add("Thin Concave )(");
    m_shapes.add("Thin Straight ||");
    m_shapes.add("Thin Convex ()");
    m_shapes.add("Medium Concave )-(");
    m_shapes.add("Medium Straight |-|");
    m_shapes.add("Medium Convex (-)");
    m_shapes.add("Thick Concave )--(");
    m_shapes.add("Thick Straight |--|");
    m_shapes.add("Thick Convex (--)");
    m_shapes.add("Cedar Lion");
    m_shapes.add("Iron Fish");
    add(m_shapes);
    
    m_knotty = new Checkbox("Knotted?");
    add(m_knotty);

    m_gobutton = new Button("Alter Piece");
    add(m_gobutton);

    m_gobutton.setEnabled(false);
    m_gobutton.addActionListener(this);
  }

  public void SetGiltHeadEngine(GiltHeadEngine i_ghe)
  {
    m_ghe = i_ghe;
  }


  public void ChangeWoodPiece(WoodPiece i_woodpiece)
  {
    m_woodpiece = i_woodpiece;

    m_colors.select(m_woodpiece.GetColor());
    m_shapes.select(m_woodpiece.GetShape());
    m_knotty.setState(m_woodpiece.IsKnotted());

    m_ghe.pause();
    m_gobutton.setEnabled(true);
    CardLayout clayout = (CardLayout)m_mainpanel.getLayout();
    clayout.show(m_mainpanel,"Wood Piece Panel");
  }

  public void actionPerformed(ActionEvent e)
  {
    CardLayout clayout = (CardLayout)m_mainpanel.getLayout();
    WoodPiece newpiece;

    if (m_colors.getSelectedIndex() == WoodPiece.CEDAR_COLOR ||
        m_shapes.getSelectedIndex() == WoodPiece.CEDAR_SHAPE)
    {
      newpiece = WoodPieceFactory.GetCedarWoodPiece(m_knotty.getState());
    }
    else if (m_colors.getSelectedIndex() == WoodPiece.FISH_COLOR ||
             m_shapes.getSelectedIndex() == WoodPiece.FISH_SHAPE)
    {
      newpiece = WoodPieceFactory.GetFishWoodPiece(m_knotty.getState());
    }
    else
    {
      newpiece = WoodPieceFactory.GetWoodPiece(m_shapes.getSelectedIndex(),
                                               m_colors.getSelectedIndex(),
                                               m_knotty.getState());
    }

    m_woodpiece.Assign(newpiece);
    m_woodpiece = null;
    m_gobutton.setEnabled(false);
    m_shapes.select(0);
    m_colors.select(0);
    m_knotty.setState(false);
    clayout.show(m_mainpanel,"MainPanel");
    m_ghe.unpause();
  }
}

    
    
  
