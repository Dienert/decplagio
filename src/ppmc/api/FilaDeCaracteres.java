package ppmc.api;

import java.io.FileWriter;
import java.io.IOException;

public class FilaDeCaracteres {

	private int[] simbolos;
	private boolean[] previsto;
	private int head, tail, cont, limite;
	private FileWriter fileWriter;
	
	public FilaDeCaracteres(FileWriter fileWriter, int tamanho, int limite) throws IOException{
		simbolos = new int[tamanho];
		previsto = new boolean[tamanho];
		head = 0;
		tail = 0;
		this.limite = limite;
		this.fileWriter = fileWriter;
	}
	
	/**
	 * 
	 * @param simbolo
	 * @param isPrevisto
	 * @return true caso a regiao seja suspeita, false caso contrario
	 * @throws IOException
	 */
	public boolean add(int simbolo, boolean isPrevisto) throws IOException{
		if(headIsBeforeTail()){
			if(previsto[tail] == false)
				cont--;
			fileWriter.write(simbolos[tail]);
			incTail();
		}
		simbolos[head] = simbolo;
		previsto[head] = isPrevisto;
		if(!isPrevisto)
			cont++;
		incHead();
		return (cont >= limite);
	}

	public void close() throws IOException{
		while(tail != head){
			fileWriter.write(simbolos[tail]);
			if(previsto[tail] == true){
				cont--;
				if(cont == limite){
					fileWriter.write("</u>");					
				}
			}
			incTail();
		}
		fileWriter.close();
	}
	
	private boolean headIsBeforeTail(){
		return (head+1)%simbolos.length == tail;
	}
	
	private void incHead() {
		head = (head+1)%simbolos.length;
	}

	private void incTail() {
		tail = (tail+1)%simbolos.length;;
	}
	
	
	
}
