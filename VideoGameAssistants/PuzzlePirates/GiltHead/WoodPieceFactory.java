import java.awt.Image;


class WoodPieceFactory
{
  private static int[] s_strengthOfShape = { 2,3,4,4,5,6,6,7,8,1,10 };
  private static String[] s_colorWords = {"Red","Orange","Yellow","Green","Cyan","Blue","Purple","Magenta"};
  private static String[] s_shapeWords = {"Thin_Concave",
                                          "Thin_Straight",
                                          "Thin_Convex",
                                          "Medium_Concave",
                                          "Medium_Straight",
                                          "Medium_Convex",
                                          "Thick_Concave",
                                          "Thick_Straight",
                                          "Thick_Convex"};

  private static String GetWoodPieceName(int i_color,int i_shape,boolean i_isknotted)
  {
    String fname;

    if (i_color == WoodPiece.CEDAR_COLOR &&
        i_shape == WoodPiece.CEDAR_SHAPE)
    {
      fname = "Cedar_Lion";
    }
    else if (i_color == WoodPiece.FISH_COLOR &&
        i_shape == WoodPiece.FISH_SHAPE)
    {
      fname = "Iron_Fish";
    }
    else
    {
      if (i_color >= s_colorWords.length) return null;
      if (i_shape >= s_shapeWords.length) return null;

      fname = s_colorWords[i_color] + "_" + s_shapeWords[i_shape];
    }

    if (i_isknotted)
    {
      fname += "_Knot";
    }

    fname += ".png";

    return fname;
  }

  private static void InitializeWoodPiece(int i_color,int i_shape,boolean i_isknotted)
  {
    ImageManager.addStaticImage(GetWoodPieceName(i_color,i_shape,i_isknotted));
  }

  public static void Initialize()
  {
    int sidx;
    int cidx;

    for (cidx = WoodPiece.RED ; cidx <= WoodPiece.MAGENTA ; ++cidx)
    {
      for (sidx = WoodPiece.THIN_INNIE ; sidx <= WoodPiece.THICK_OUTIE ; ++sidx)
      {
        InitializeWoodPiece(cidx,sidx,false);
        InitializeWoodPiece(cidx,sidx,true);
      }
    }

    // silhouettes
    for (sidx = WoodPiece.THIN_INNIE ; sidx <= WoodPiece.THICK_OUTIE ; ++sidx)
    {
      ImageManager.addStaticImage("Silhouette_" + s_shapeWords[sidx] + ".png");
    }

    // make sure to call the ImageManager.add for the cedar piece.
    InitializeWoodPiece(WoodPiece.CEDAR_COLOR,WoodPiece.CEDAR_SHAPE,true);
    InitializeWoodPiece(WoodPiece.CEDAR_COLOR,WoodPiece.CEDAR_SHAPE,false);
    InitializeWoodPiece(WoodPiece.FISH_COLOR,WoodPiece.FISH_SHAPE,true);
    InitializeWoodPiece(WoodPiece.FISH_COLOR,WoodPiece.FISH_SHAPE,false);
  }

  public static WoodPiece GetWoodPiece(int i_shape,int i_color,boolean i_isKnotted)
  {
    int weight = s_strengthOfShape[i_shape];
    if (i_isKnotted) weight = -weight;
    String imname = GetWoodPieceName(i_color,i_shape,i_isKnotted);
    Image im = ImageManager.getImage(imname);

    return new WoodPiece(i_color,i_shape,weight,i_isKnotted,im);
  }

  public static WoodPiece GetCedarWoodPiece(boolean i_isKnotted)
  {
    return GetWoodPiece(WoodPiece.CEDAR_SHAPE,WoodPiece.CEDAR_COLOR,i_isKnotted);
  }

  public static WoodPiece GetFishWoodPiece(boolean i_isKnotted)
  {
    return GetWoodPiece(WoodPiece.FISH_SHAPE,WoodPiece.FISH_COLOR,i_isKnotted);
  }
}
