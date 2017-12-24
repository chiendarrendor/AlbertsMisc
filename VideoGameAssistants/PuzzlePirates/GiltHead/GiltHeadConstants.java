public class GiltHeadConstants
{
  // global constants
  public static final int SCREEN_WIDTH = 450;
  public static final int SCREEN_HEIGHT = 600;

  public static final int SUSHI_BAR_HEIGHT = 70;
  public static final int BALANCE_BEAM_HEIGHT = 60;
  public static final int WORK_BENCH_HEIGHT = 70;
  public static final int WORK_AREA_HEIGHT = SCREEN_HEIGHT - BALANCE_BEAM_HEIGHT;
  public static final int BLUEPRINT_HEIGHT = WORK_AREA_HEIGHT - WORK_BENCH_HEIGHT - SUSHI_BAR_HEIGHT;
  public static final int WORK_BENCH_Y_LOCATION = BLUEPRINT_HEIGHT;
  public static final int SUSHI_BAR_Y_LOCATION = BLUEPRINT_HEIGHT + WORK_BENCH_HEIGHT; 

  public static final int PIECE_HEIGHT = 55;
  public static final int PIECE_WIDTH = 55;

  // Balance Beam Constants
  public static final int BALANCE_BEAM_WIDTH = 450;
  public static final int BALANCE_BEAM_FULCRUM_HEIGHT = 20;
  public static final int BALANCE_BEAM_FULCRUM_WIDTH = 20;

  public static final int BALANCE_BEAM_BEAM_LENGTH = 400;
  public static final int BALANCE_BEAM_BEAM_THICKNESS = 7;
 
  public static final int BALANCE_BEAM_WEIGHT_INSET = 10;
  public static final int BALANCE_BEAM_STANDARD_WEIGHT_SIZE = 5;
  public static final int BALANCE_BEAM_TEST_WEIGHT_SIZE = 5;

  public static final int BALANCE_BEAM_BOB_RATE = 200;
  public static final int BALANCE_BEAM_BOB_MAX_OFFSET = 2;
 
  public static final int BALANCE_BEAM_CYCLE_TIME = 20;
  public static final int BALANCE_BEAM_ANGULAR_VELOCITY = 1;

  // work area constants
  public static final int WORK_BENCH_COUNT = 6;
  
  public static final int WORK_AREA_CYCLE_TIME = 20;

  // blueprint constants
  public static final int BLUEPRINT_BOTTOM_UPSET = 5;
  public static final int BLUEPRINT_VERTICAL_SEPARATION = 2;
  public static final int BLUEPRINT_COLUMN1_INSET = 30;
  public static final int BLUEPRINT_COLUMN2_INSET = 20;
  
  public static final int BLUEPRINT_NUM_COLUMNS = 4;
  public static final int BLUEPRINT_MAX_HEIGHT = 6;

  public static final int COMPLETED_BOTTOM_UPSET = 30;
  public static final int COMPLETED_X = SCREEN_WIDTH/2;
  public static final int COMPLETED_WIDTH=40;
  public static final int COMPLETED_HEIGHT=32;
  public static final int COMPLETED_SEP = 5;

  public static final int STATUS_START_OFFSET = 50;
  public static final int STATUS_END_OFFSET = 300;
  public static final int STATUS_VELOCITY = 4;

  public static final int MOUSE_X1 = 0;
  public static final int MOUSE_Y1 = BLUEPRINT_HEIGHT;

  public static final int MOUSE_X2 = SCREEN_WIDTH;
  public static final int MOUSE_Y2 = BLUEPRINT_HEIGHT;

  public static final int MOUSE_X3 = SCREEN_WIDTH/2 - 20;
  public static final int MOUSE_Y3 = BLUEPRINT_HEIGHT;
  
  public static final int MOUSE_CYCLE_TIME = 100;

  public static final int MOUSE_LEFT_WIGGLE_TIME = 50;
  public static final int MOUSE_RIGHT_WIGGLE_TIME = 75;
  public static final int MOUSE_BOTTOM_WIGGLE_TIME = 60;
  public static final int MOUSE_EAT_WIGGLE_TIME = 60;

  public static final int MOUSE_WIGGLE_AMPLITUDE = 4;

  public static final int MOUSESIDE_WIDTH=132;

  public static final int MOUSEBUTT_WIDTH = 100;
  public static final int MOUSEBUTT_HEIGHT = 100;
  public static final int MOUSEBUTT_NOSE_OFFSET_X = 52;
  public static final int MOUSEBUTT_NOSE_OFFSET_Y = 52;

  public static final int TABLETOP_WIDTH = 430;
  public static final int TABLETOP_HEIGHT_1 = 15;
  public static final int TABLETOP_HEIGHT_2 = 30;
  public static final int TABLETOP_HEIGHT_3 = 45;

  public static final int TABLE_TOP_VELOCITY = 2;

  // constants for the Sushi Bar
  public static final int SUSHI_SEPARATION = 30;

  public static final int SUSHI_BAR_HEIGHT_VARIATION = 3;
  public static final int SUSHI_BAR_BOB_AMPLITUDE = 3;
  public static final int SUSHI_BAR_BOB_FREQUENCY = 6; // # of cycles in a screen width

  public static final int SUSHI_BAR_CYCLE_TIME = 20;
}
