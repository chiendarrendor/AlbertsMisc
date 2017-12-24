import java.util.Random;

// a singleton wrapper around the Random object

class MyRand
{
  static Random s_random;

  static void Init()
  {
    s_random = new Random();
  }

  static int nextInt(int i_int)
  {
    return s_random.nextInt(i_int);
  }

  static Random GetRandom()
  {
    return s_random;
  }
}
