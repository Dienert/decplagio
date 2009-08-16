
package ppmc.encoder;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

import ppmc.api.ContextoK;
import ppmc.api.ContextoKMenosUm;
import ppmc.api.ContextoKZero;
import ppmc.api.DesvioPadrao;
import ppmc.codificador.ArithEncoder;
import ppmc.io.BitInputStream;

/**
 *
 */
public class Encoder {

    ContextoK contextosK[];

    public Encoder(int nBitsPorSimbolo, int maiorContexto, String input, String output) throws IOException{
    	this(nBitsPorSimbolo, maiorContexto, input, output, null, null);
    }
    
    public Encoder(int nBitsPorSimbolo, int maiorContexto, String input, String output, String modelo, String novoModelo) throws IOException {
        
    	int maiorSimbolo = (int)Math.pow(2, nBitsPorSimbolo), lido = 0;
        
        ContextoK.setArithEncoder(new ArithEncoder(new FileOutputStream(output)));
        
        initContextosK(maiorContexto, maiorSimbolo);
        
        readContextosK(modelo);
        
        BitInputStream bis = new BitInputStream(input, false);
        
        String contexto = "";
        
        try{
            for(int i = 1; i < maiorContexto+1; i++){
                lido = bis.nextBits(nBitsPorSimbolo);                
                contextosK[i].codifica(contexto, lido);
                contexto += (char)lido;
            }
            while(lido < maiorSimbolo + 1){
                lido = bis.nextBits(nBitsPorSimbolo);
                contextosK[maiorContexto+1].codifica(contexto, lido);
                contexto = contexto.substring(1) + (char)lido;
            }
        } catch(IOException ex){
            ContextoK.getArithEncoder().close();
        }
        
        saveContextosK(maiorContexto, novoModelo);
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
