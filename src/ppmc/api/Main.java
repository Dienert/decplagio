
package ppmc.api;

import ppmc.decoder.Decoder;
import ppmc.encoder.Encoder;
import java.io.IOException;

/**
 *
 */
public class Main {

    public static void main(String[] args) throws IOException {

//        Contexto.debug = true;
        long time = System.currentTimeMillis();
        String aCompactar = "files/scriTabelasReduzidoPostgres.sql";
        String comprimido = "files/comp2.ppm";
        String descompactado = "files/sTRP.sql";
        String modelo = "files/modelo.txt";
        
        ContextoK.modificarModelo = true;
//        
        new Encoder(8, 6, aCompactar, comprimido, null, modelo);
        new Decoder(8, 6, comprimido,descompactado, null, null);
//        new Encoder(8, 6, aCompactar, comprimido, modelo, null);
//        new Decoder(8, 6, comprimido,descompactado, modelo, null);
   
        System.out.println(System.currentTimeMillis() - time+"ns");
        
    }

}
