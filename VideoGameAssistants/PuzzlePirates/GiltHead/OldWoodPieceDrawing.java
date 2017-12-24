
    /* this code is for putting piece data on the pieces

    String colstring;
    
    switch(GetColor())
    {
    case RED: i_g.setColor( new Color(0xff,0x00,0x00)); colstring = "red"; break; 
    case ORANGE: i_g.setColor( new Color(0xff,0x99,0x00)); colstring = "orange"; break; 
    case YELLOW: i_g.setColor( new Color(0xff,0xff,0x00)); colstring = "yellow"; break; 
    case GREEN: i_g.setColor( new Color(0x00,0xff,0x00)); colstring = "green"; break; 
    case CYAN: i_g.setColor( new Color(0x00,0xff,0xff)); colstring = "cyan"; break;
    case BLUE: i_g.setColor( new Color(0x00,0x00,0xff)); colstring = "blue"; break;
    case MAGENTA: i_g.setColor( new Color(0xff,0x00,0xff)); colstring = "magenta"; break; 
    case PURPLE: i_g.setColor( new Color(0x99,0x00,0xff)); colstring = "purple"; break; 
    case CEDAR_COLOR: i_g.setColor(new Color(0xff,0xcc,0x00)); colstring = "cedar"; break;
    default: i_g.setColor(Color.black); colstring = "?" + GetColor(); break;
    }

    String shapestring;

    switch(GetShape())
    {
    case THIN_INNIE: shapestring = ")("; break;
    case THIN_STRAIGHT: shapestring = "||"; break;
    case THIN_OUTIE: shapestring = "()"; break;
    case MEDIUM_INNIE: shapestring = ")--("; break;
    case MEDIUM_STRAIGHT: shapestring = "|--|"; break;
    case MEDIUM_OUTIE: shapestring = "(--)"; break;
    case THICK_INNIE: shapestring = ")----("; break;
    case THICK_STRAIGHT: shapestring = "|----|"; break;
    case THICK_OUTIE: shapestring = "(----)"; break;
    case CEDAR_SHAPE: shapestring = "raar!"; break;
    default: shapestring = "???"; break;
    }

    String kstring;
    if (GetStrength() == 0)
    {
      kstring = "knot";
    }
    else
    {
      kstring = "" + GetStrength();
    }
    
    i_g.fillRect(i_x,i_y,GiltHeadConstants.PIECE_WIDTH,GiltHeadConstants.PIECE_HEIGHT);

    */

    if (m_image != null)
    {
      i_g.drawImage(m_image,i_x,i_y,null);
    }


    /*
    i_g.setColor(new Color(255 - i_g.getColor().getRed(),
                           255 - i_g.getColor().getGreen(),
                           255 - i_g.getColor().getBlue()));


    i_g.setFont(i_g.getFont().deriveFont((float)12));
    i_g.drawString(colstring,i_x+2,i_y+15);
    i_g.drawString(shapestring,i_x+2,i_y+30);
    i_g.drawString(kstring,i_x+2,i_y+45);
    */
  }
