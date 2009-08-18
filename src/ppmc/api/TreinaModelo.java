package ppmc.api;

import java.io.File;
import java.io.IOException;
import java.util.LinkedList;

public class TreinaModelo {

	public static void main(String[] args) {

		long time = System.currentTimeMillis();

		String aCompactar = "files/scriTabelasReduzidoPostgres.sql";
		String modelo = "modelo.txt";
		File dir = new File("machado_de_assis_mod");

		try {
			PPMC ppm = new PPMC(8, 3);
//			ppm.modificaModelo(dir + "/" + dir.list()[1], null, modelo);
//			for (int i = 2; i < dir.list().length; i++) {
//				ppm.modificaModelo(dir + "/" + dir.list()[i], modelo, modelo);
//			}
			LinkedList<Double> lista = new LinkedList<Double>();
			lista = ppm.getListaDeInfos(dir + "/" + dir.list()[1], modelo);
//			for (int i = 2; i < dir.list().length; i++) {
//				lista.addAll(ppm.getListaDeInfos(dir + "/" + dir.list()[i],	modelo));
//			}
			DesvioPadrao desvioPadrao = new DesvioPadrao(lista);
			String nomeSaida = dir+"/"+dir.list()[1]+".teste";
			File output = new File(nomeSaida);
			output.createNewFile();
			ppm.encontraPlagio(dir + "/" + dir.list()[1], nomeSaida, null, modelo, desvioPadrao);
//			ppm.encontraPlagio(aCompactar, "files/sqrt.txt", null, modelo, desvioPadrao);
		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println(System.currentTimeMillis() - time + "ns");

	}

}
