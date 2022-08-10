public class Main {

    public static void main(String[] args) {

        double orig = 458;

        double cur = orig;
        double delta = 0.0;
        double counter = 0.0;
        double deepen = 1.0;

        for (double pot = 1; pot > 0.000000001; pot /= 10) {
            delta += 1.0 * pot * deepen;

            while (true) {
                System.out.println("Cur before subtraction : " + cur + " delta: " + delta + " counter: " + counter + " pot: " + pot);
                cur -= delta;
                if (cur < 0) {
                    cur += delta;
                    delta -= 1.0 * pot * deepen;
                    delta /= 10;
                    deepen /= 10;
                    break;
                }

                counter += 1.0 * pot;
                delta += 2.0 * pot * deepen;
            }
        }
        System.out.println("counter: " + counter);
        System.out.println("real: " + Math.sqrt(orig));
    }

}