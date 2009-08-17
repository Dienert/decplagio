package tratamento;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.Normalizer;

public class Tratar {
	
	public void format(String inputFile) {
		try {
			FileReader fr = new FileReader(inputFile);
			String outputFile = "";
			String dir = "";
			if (inputFile.contains("/")) {
				int last = inputFile.lastIndexOf("/");
				outputFile = inputFile.substring(last+1);
				dir = inputFile.substring(0, last+1);
			}
			FileWriter fw = new FileWriter(dir+"tratado."+outputFile);
			char[] buffer = new char[1024];
			char[] bufferTratado = new char[1024];
			while (fr.read(buffer) != -1) {
				for (int i = 0; i < buffer.length; i++) {
					String aux = Normalizer.normalize(buffer[i]+"", 
													 Normalizer.Form.NFD).
											replaceAll("[^\\p{ASCII}]", "");
					if (aux.equals("\n"))
						aux = " ";
					if (!aux.equals("")) {
						bufferTratado[i] = aux.toLowerCase().charAt(0);
					}
				}
				fw.write(bufferTratado);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		
		Tratar t = new Tratar();
		t.format("machado de assis/a_mao_e_a_luva.txt");
		
	}

}
