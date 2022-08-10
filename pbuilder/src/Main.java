import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;

public class Main {

    public static void main(String[] args) {
        ProcessBuilder pbuilder = new ProcessBuilder("D:/MinGW/msys/1.0/bin/grep","foo");
        Process p = null;
        try {
            p = pbuilder.start();

            PrintStream input = new PrintStream(p.getOutputStream());
            BufferedReader output = new BufferedReader(new InputStreamReader(p.getInputStream(),"UTF-8"));

            System.out.println("Before input");
            input.println("Is this foo?");
            System.out.println("input sent");
            System.out.println("From output: " + output.readLine());
            System.out.println("Output gotten");
          





        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (p != null) {
                p.destroy();
                System.out.println("Process destroyed");
            }
        }
        // write your code here
    }
}
