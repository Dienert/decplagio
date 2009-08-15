
package ppmc.decoder;

import ppmc.api.ContextoK;
import ppmc.api.ContextoKMenosUm;
import ppmc.api.ContextoKZero;
import ppmc.codificador.ArithDecoder;
import ppmc.io.BitOutputStream;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class Decoder {

    ContextoK contextosK[];

    public Decoder(int nBitsPorSimbolo, int maiorContexto, String input, String output, String modelo, String novoModelo) throws IOException {
        int maiorSimbolo = (int)Math.pow(2, nBitsPorSimbolo);
        ContextoK.setArithDecoder(new ArithDecoder(new FileInputStream(input)));
        BitOutputStream bos = new BitOutputStream(output);
        
        initContextosK(maiorContexto, maiorSimbolo);
        
        readContextosK(modelo);
        
        try{
            int lido;
            String contexto = "";
            lido =  contextosK[1].getSimbolo(contexto);
            contexto += (char)lido;
            bos.print(lido, nBitsPorSimbolo);
            for(int i = 2; i < maiorContexto + 1; i++) {
                lido =  contextosK[i].getSimbolo(contexto);
                contexto += (char)lido;
                bos.print(lido, nBitsPorSimbolo);
            }
            while(true) {
                lido =  contextosK[maiorContexto+1].getSimbolo(contexto);
                contexto = contexto.substring(1) + (char)lido;
                bos.print(lido, nBitsPorSimbolo);
            }
        }catch (IOException ex){
            bos.close();            
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
        	} catch (Exception e) {
        		e.printStackTrace();
        	}
        }
    }
}
