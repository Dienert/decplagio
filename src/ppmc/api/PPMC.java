package ppmc.api;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.Scanner;

import ppmc.io.BitInputStream;

public class PPMC {

	private int nBitsPorSimbolo;
	private int maiorContexto;
	private int maiorSimbolo;	
	ContextoK contextosK[];
	
	
	
	public PPMC(int nBitsPorSimbolo, int maiorContexto) {
		super();
		this.nBitsPorSimbolo = nBitsPorSimbolo;
		this.maiorContexto = maiorContexto;
		maiorSimbolo = (int)Math.pow(2, nBitsPorSimbolo);
	}


	public void modificaModelo(String input, String modeloBase, String modeloModificado) throws IOException{

		int lido = 0;
		initContextosK(maiorContexto, maiorSimbolo);
        readContextosK(modeloBase);        
        BitInputStream bis = new BitInputStream(input, false);        
        String contexto = "";
        
        try{
            for(int i = 1; i < maiorContexto+1; i++){
                lido = bis.nextBits(nBitsPorSimbolo);                
                contextosK[i].addAoModelo(contexto, lido);
                contexto += (char)lido;
            }
            while(lido < maiorSimbolo + 1){
                lido = bis.nextBits(nBitsPorSimbolo);
                contextosK[maiorContexto+1].addAoModelo(contexto, lido);
                contexto = contexto.substring(1) + (char)lido;
            }
        } catch(IOException ex){}
        
        saveContextosK(maiorContexto, modeloModificado);
    }
    
    
    public LinkedList<Double> getListaDeInfos(String input, String modeloBase) throws IOException{

    	int simbolo = 0;
    	initContextosK(maiorContexto, maiorSimbolo);
        readContextosK(modeloBase);        
        BitInputStream bis = new BitInputStream(input, false);        
        String contexto = "";
        LinkedList<Double> lista = new LinkedList<Double>();
        
        try{
            for(int i = 1; i < maiorContexto+1; i++){
                simbolo = bis.nextBits(nBitsPorSimbolo);                
                lista.add(contextosK[i].getInfo(contexto, simbolo));
                contexto += (char)simbolo;
            }
            while(simbolo < maiorSimbolo + 1){
                simbolo = bis.nextBits(nBitsPorSimbolo);
                lista.add(contextosK[maiorContexto+1].getInfo(contexto, simbolo));
                contexto = contexto.substring(1) + (char)simbolo;
            }
        } catch(IOException ex){}
        
        return lista;
    }
    
    private int X = 100;
    private double Y = 0.50;
    
    public void encontraPlagio(String input, String output, String regex, String modeloBase, DesvioPadrao desvio) throws IOException{
    	
    	int limite = (int)(X*Y);
    	int simbolo = 0;
    	double info = 0;
    	boolean anterior, atual = false;
    	FileWriter fileWriter = new FileWriter(output);
    	FilaDeCaracteres fila = new FilaDeCaracteres(fileWriter, X, limite);
    	initContextosK(maiorContexto, maiorSimbolo);
        readContextosK(modeloBase);        
        BitInputStream bis = new BitInputStream(input, false);        
        String contexto = "";
        
        try{
            for(int i = 1; i < maiorContexto+1; i++){
                simbolo = bis.nextBits(nBitsPorSimbolo);
                info = contextosK[i].getInfo(contexto, simbolo);
//                System.out.println("info = " + info);
                fila.add(simbolo, desvio.dentroDoDesvio(info));
                contexto += (char)simbolo;
            }
            while(simbolo < maiorSimbolo + 1){
                simbolo = bis.nextBits(nBitsPorSimbolo);
                info = contextosK[maiorContexto+1].getInfo(contexto, simbolo);
//                System.out.println("info = " + info);
                anterior = atual;
                atual = fila.add(simbolo, desvio.dentroDoDesvio(info));
                if(anterior == false && atual == true){
                	fileWriter.write("<b>");
                } else if(anterior == true && atual == false){
                	fileWriter.write("</b>");
                }
                contexto = contexto.substring(1) + (char)simbolo;
            }
        } catch(IOException ex){}
        fila.close();
    }

    private void initContextosK(int maiorK, int maiorSimbolo){
    	contextosK = new ContextoK[maiorK+2];
        contextosK[0] = new ContextoKMenosUm(maiorSimbolo);
        contextosK[1] = new ContextoKZero(maiorSimbolo);
        contextosK[1].setProximoContexto(contextosK[0]);
        for(int i = 2; i < maiorK + 2; i++){
            contextosK[i] = new ContextoK(maiorSimbolo);
            contextosK[i].setProximoContexto(contextosK[i-1]);
        }        
    }
    
    private void readContextosK(String modelo){
    	if(modelo != null){
        	try {        		
        		Scanner scanner = new Scanner(new File(modelo));
        		for(int i = 0; i < contextosK.length; i++){
        			contextosK[i].fromScanner(scanner);
        		}        		
        	} catch (Exception e) {
        		e.printStackTrace();
        	}
        }
    }
    
    private void saveContextosK(int maiorK, String modelo){
    	if(modelo != null){
        	try {        		
        		FileWriter fileWriter = new FileWriter(modelo);
        		for(int i = 0; i < contextosK.length; i++){
        			fileWriter.write(contextosK[i].toString());
        		}
        		fileWriter.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}
        }
    }
	
}
