import java.net.*;
import java.io.*;

public class URLPrintHtml {
    public static void main(String[] args) throws Exception{
        URL holwebseite = new URL("https://zaprosen.github.io/einfache.html");
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(holwebseite.openStream()));

            String inputLine;
            while ((inputLine = in.readLine()) !=null)
                System.out.println(inputLine);
            in.close();
    }
}
