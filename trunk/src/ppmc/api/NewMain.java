package ppmc.api;

import java.io.File;
import java.io.IOException;
import java.util.LinkedList;

public class NewMain {

	public static void main(String[] args) throws IOException {

       long time = System.currentTimeMillis();
       
       String aCompactar = "files/scriTabelasReduzidoPostgres.sql";
//       String comprimido = "files/comp2.ppm";
//       String descompactado = "files/sTRP.html";
//       String path = "teste";
       String modelo = "modelo.txt";
       File dir = new File("machado_de_assis_mod");
       
       PPMC ppm = new PPMC(8, 3);
       
       ppm.modificaModelo(dir+"/"+dir.list()[1], null, modelo);       
       
       for(int i = 2; i < dir.list().length && i < 4; i++){
    	   ppm.modificaModelo(dir+"/"+dir.list()[i], modelo, modelo);
       }
//       LinkedList<Double> lista = new LinkedList<Double>();
//       lista = ppm.getListaDeInfos(dir+"/"+dir.list()[1], modelo);
//
//       for(int i = 2; i < dir.list().length && i < 4; i++){
//    	   lista.addAll(ppm.getListaDeInfos(dir+"/"+dir.list()[i], modelo));
//       }
//       
//       DesvioPadrao desvioPadrao = new DesvioPadrao(lista);
//       ppm.encontraPlagio(dir+"/"+dir.list()[1], dir.list()[1], null, modelo, desvioPadrao);
//       ppm.encontraPlagio(aCompactar, "sqrt.txt", null, modelo, desvioPadrao);
//  
       System.out.println(System.currentTimeMillis() - time+"ns");
       
   }
}
