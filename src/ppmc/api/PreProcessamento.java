package ppmc.api;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.StringTokenizer;

public class PreProcessamento {
	static BufferedReader original;
	static BufferedWriter modificado;
	public static void main (String[] args) {
//		if (args.length != 1) {
//			System.err.println("É preciso passar o nome do arquivo de texto a ser processado.");
//			System.exit(0);
//		}

		File diretorioComArquivosOriginais = new File("machado_de_assis");
		File diretorioComArquivosTratados = new File("machado_de_assis_mod");
		
		for (String fileName : diretorioComArquivosOriginais.list()) {
			String input = diretorioComArquivosOriginais+"\\"+fileName;
			String nomeSaida = fileName+".tratado.txt";
			String output = diretorioComArquivosTratados+"\\"+nomeSaida;
			if (!fileName.equals(".svn")) {
				try {
					original = new BufferedReader(new FileReader(input));
				} catch (FileNotFoundException e) {
					System.err.println("Arquivo nao encontrado: "+input);
					System.exit(0);
				}
				try {
					File file = new File(output);
					file.createNewFile();
					modificado = new BufferedWriter(new FileWriter(file));
				} catch (IOException e) {
					System.err.println("Não foi possível escrever no arquivo: "+output);
					System.exit(0);
				}
				char[] buffer = new char[64000];
				int numLidos;
				String lido;
				try {
					numLidos = original.read(buffer);
					lido = String.valueOf(buffer, 0, numLidos);
					lido = lido.toLowerCase();
					lido = processa(lido);
					modificado.write(lido);
				} catch (IOException e1) {
					System.err.println("Problema na leitura e escrita dos arquivos.");
					System.exit(0);
				}
				
				try {
					original.close();
					modificado.close();
				} catch (IOException e) {
					System.err.println("Erro no fechamento das streams.");
					System.exit(0);
				}
			}
		}
	}

	public static String processa (String s) {
		
		//StringTokenizer token = new StringTokenizer(s, "\n\t", false);
		//s = "";
		//while (token.hasMoreElements()) s += token.nextElement();

		s = s.replace('â', 'a');
		s = s.replace('ä', 'a');
		s = s.replace('à', 'a');
		s = s.replace('ã', 'a');
		s = s.replace('á', 'a');
		
		s = s.replace('ê', 'e');
		s = s.replace('é', 'e');
		s = s.replace('è', 'e');
		s = s.replace('ë', 'e');
		
		s = s.replace('í', 'i');
		s = s.replace('ï', 'i');
		s = s.replace('ì', 'i');
		s = s.replace('î', 'i');
		
		s = s.replace('õ', 'o');
		s = s.replace('ó', 'o');
		s = s.replace('ö', 'o');
		s = s.replace('ò', 'o');
		s = s.replace('ô', 'o');

		s = s.replace('ú', 'u');
		s = s.replace('û', 'u');
		s = s.replace('ù', 'u');
		s = s.replace('ü', 'u');

		s = s.replace('ç', 'c');

		s = s.replace('ñ', 'n');
		
		return s;
	}
}
