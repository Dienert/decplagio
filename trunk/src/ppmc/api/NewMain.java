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
       File dir = new File("teste");
       
       PPMC ppm = new PPMC(8, 6);
       
//       ppm.modificaModelo(dir+"/"+dir.list()[0], null, modelo);       
       
//       for(int i = 1; i < dir.list().length; i++){
//    	   ppm.modificaModelo(dir+"/"+dir.list()[i], modelo, modelo);
//       }
       LinkedList<Double> lista = new LinkedList<Double>();
       lista = ppm.getListaDeInfos(dir+"/"+dir.list()[0], modelo);
//
//       for(int i = 1; i < dir.list().length; i++){
//    	   lista.addAll(ppm.getListaDeInfos(dir+"/"+dir.list()[i], modelo));
//       }
       
       DesvioPadrao desvioPadrao = new DesvioPadrao(lista);
       ppm.encontraPlagio(dir+"/"+dir.list()[0], dir.list()[0], null, modelo, desvioPadrao);
       ppm.encontraPlagio(aCompactar, "sqrt.txt", null, modelo, desvioPadrao);
  
       System.out.println(System.currentTimeMillis() - time+"ns");
       
   }
}
