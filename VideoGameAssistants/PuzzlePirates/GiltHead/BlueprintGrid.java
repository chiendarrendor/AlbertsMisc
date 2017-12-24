import java.util.Vector;


public class BlueprintGrid
{
  private Vector<Vector<WoodPiece> > m_pieces;

  public BlueprintGrid()
  {
    m_pieces = new Vector<Vector<WoodPiece> >();
    m_pieces.setSize(GiltHeadConstants.BLUEPRINT_NUM_COLUMNS);

    int i;
    for (i = 0 ; i < m_pieces.size() ; ++i)
    {
      m_pieces.set(i,new Vector<WoodPiece>());
      m_pieces.get(i).setSize(GiltHeadConstants.BLUEPRINT_MAX_HEIGHT);
    }
  }

  public void ClearGrid()
  {
    int i,j;
    for (i = 0 ; i < GiltHeadConstants.BLUEPRINT_NUM_COLUMNS ; ++i)
    {
      for (j = 0 ; j < GiltHeadConstants.BLUEPRINT_MAX_HEIGHT ; ++j)
      {
        m_pieces.get(i).set(j,null);
      }
    }
  }

  public WoodPiece GetPiece(int i_column,int i_row)
  {
    return m_pieces.get(i_column).get(i_row);
  }

  public void SetPieceInColumn(int i_column,WoodPiece i_wp)
  {
    int i;
    for (i = 0 ; i < m_pieces.get(i_column).size() ; ++i)
    {
      if (m_pieces.get(i_column).get(i) == null)
      {
        m_pieces.get(i_column).set(i,i_wp);
        break;
      }
    }
  }

  public void SetPiece(int i_column,int i_row, WoodPiece i_wp)
  {
    m_pieces.get(i_column).set(i_row,i_wp);
  }


  public int GetColumnHeight(int i_column)
  {
    int i;
    for (i = 0 ; i < m_pieces.get(i_column).size() ; ++i)
    {
      if (m_pieces.get(i_column).get(i) == null) break;
    }
    return i;
  }
}
