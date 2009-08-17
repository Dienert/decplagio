package ppmc.api;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.StringTokenizer;

public class PreProcessamento {
	static BufferedReader original;
	static BufferedWriter modificado;
	public static void main (String[] args) {
		if (args.length != 1) {
			System.err.println("� preciso passar o nome do arquivo de texto a ser processado.");
			System.exit(0);
		}

		try {
			original = new BufferedReader(new FileReader(args[0]));
			String nomeSaida = (args[0].lastIndexOf('.') != -1) ? args[0].substring(0,args[0].lastIndexOf('.'))
					+ "mod.txt" : args[0] + "mod.txt";

			modificado = new BufferedWriter(new FileWriter(nomeSaida));
		} catch (FileNotFoundException e) {
			System.err.println("Arquivo nao encontrado.");
			System.exit(0);
		} catch (IOException e) {
			System.err.println("Problema na criacao dos arquivos.");
			System.exit(0);
		}

		char[] buffer = new char[1024];
		int numLidos;
		String lido;
		try {
			while ((numLidos = original.read(buffer)) != -1) {
				lido = String.valueOf(buffer, 0, numLidos);
				lido = lido.toLowerCase();
				lido = processa(lido);
				modificado.write(lido);
			}
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

	public static String processa (String s) {
		
		StringTokenizer token = new StringTokenizer(s, " \n\t", false);
		s = "";
		while (token.hasMoreElements()) s += token.nextElement();

		s = s.replace('�', 'a');
		s = s.replace('�', 'a');
		s = s.replace('�', 'a');
		s = s.replace('�', 'a');
		s = s.replace('�', 'a');
		
		s = s.replace('�', 'e');
		s = s.replace('�', 'e');
		s = s.replace('�', 'e');
		s = s.replace('�', 'e');
		
		s = s.replace('�', 'i');
		s = s.replace('�', 'i');
		s = s.replace('�', 'i');
		s = s.replace('�', 'i');
		
		s = s.replace('�', 'o');
		s = s.replace('�', 'o');
		s = s.replace('�', 'o');
		s = s.replace('�', 'o');
		s = s.replace('�', 'o');

		s = s.replace('�', 'u');
		s = s.replace('�', 'u');
		s = s.replace('�', 'u');
		s = s.replace('�', 'u');

		s = s.replace('�', 'c');

		s = s.replace('�', 'n');
		
		return s;
	}
}
