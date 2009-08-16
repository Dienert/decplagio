
package ppmc.api;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Scanner;

import ppmc.codificador.ArithDecoder;
import ppmc.codificador.ArithEncoder;


public class ContextoK {

    protected HashMap<String, HashMap<Integer, Integer>> map;
    protected ContextoK proximo;
    protected int maxSimbolos;
    protected static boolean debug, modificarModelo;
    protected static ArithEncoder arithEncoder;
    protected static ArithDecoder arithDecoder;
    protected static FileWriter fileWriter;
    
//    static {
//    	try {
//			fileWriter = new FileWriter("files/chars.inf");
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//    }

    public ContextoK(int maiorSimbolo){
        map = new HashMap<String, HashMap<Integer, Integer>>();
        this.maxSimbolos = maiorSimbolo;
    }
    
    public void addAoModelo(String contexto, int simbolo) throws IOException {
    	addAoModelo(contexto, simbolo, new boolean[maxSimbolos + 2]);
    }
    
    protected void addAoModelo(String contexto, int simbolo, boolean nosAnteriores[]) throws IOException {
    	
        
        int escape = maxSimbolos;
        HashMap<Integer, Integer> freqs = map.get(contexto);
        
        if(freqs == null){
            proximo.addAoModelo(contexto.substring(1), simbolo, nosAnteriores);
            inserirContexto(contexto, simbolo, escape);
        } else {
            if(freqs.get(simbolo) == null){
                proximo.addAoModelo(contexto.substring(1), simbolo, nosAnteriores);
               	incContadorDoSimbolo(freqs, escape);
            }
            incContadorDoSimbolo(freqs, simbolo);            
            map.put(contexto, freqs);
        }                
    }

    public double getInfo(String contexto, int simbolo) throws IOException {
    	return getInfo(contexto, simbolo, new boolean[maxSimbolos + 2]);
    }

    protected double getInfo(String contexto, int simbolo, boolean nosAnteriores[]) throws IOException {
    	
        int aCodificar = simbolo, total = 0, escape = maxSimbolos;
        HashMap<Integer, Integer> freqs = map.get(contexto);
        
        if(freqs == null){
            return proximo.getInfo(contexto.substring(1), simbolo, nosAnteriores);
        } else {
        	
        	for(int i = 0; i < escape+2; i++){
        		if(freqs.get(i) != null && !nosAnteriores[i]){
        			total += freqs.get(i);
        		}
        	}
        	
            if(freqs.get(simbolo) == null)                
            	return DesvioPadrao.log2(((double)total)/freqs.get(escape)) + proximo.getInfo(contexto.substring(1), simbolo, nosAnteriores);
                        
            return DesvioPadrao.log2(((double)total)/freqs.get(aCodificar));            
        }
    }
    

    public void setProximoContexto(ContextoK proximo){
        this.proximo = proximo;
    }

    public void inserirContexto(String contexto, int simbolo, int escape){        
    	HashMap<Integer, Integer> freqs = new HashMap<Integer, Integer>();
        freqs.put(simbolo, 1);
        freqs.put(escape, 1);
        map.put(contexto, freqs);
    }

    public void incContadorDoSimbolo(HashMap<Integer, Integer> freqs, int simbolo){
        int contador = (freqs.get(simbolo) != null)? freqs.get(simbolo)+1 : 1;
        freqs.put(simbolo, contador);
    }

    public void codifica(String contexto, int simbolo) throws IOException {
        codifica(contexto, simbolo, new boolean[maxSimbolos + 2]);
    }

    public void codifica(String contexto, int simbolo, boolean nosAnteriores[]) throws IOException {
        
        int aCodificar = simbolo, low = 0, high = 0, total = 0, escape = maxSimbolos;
        HashMap<Integer, Integer> freqs = map.get(contexto);
        
        if(freqs == null){
            proximo.codifica(contexto.substring(1), simbolo, nosAnteriores);
            inserirContexto(contexto, simbolo, escape);
        } else {
            if(freqs.get(simbolo) == null)                
                aCodificar = escape;
            
            for(int i = 0; i < aCodificar; i++){
                if(freqs.get(i) != null && !nosAnteriores[i]){
                    low += freqs.get(i);
                    nosAnteriores[i] = true;
                }
            }
            
            high = low + freqs.get(aCodificar);
            total = low;

            

            for(int i = aCodificar; i < escape+2; i++){
                if(freqs.get(i) != null && !nosAnteriores[i]){
                    total += freqs.get(i);
                    nosAnteriores[i] = true;
                }
            }
            
            nosAnteriores[escape] = false;

//            fileWriter.write(freqs.get(aCodificar)+" "+total + " ");
            arithEncoder.encode(low, high, total);
            
            if(aCodificar == escape) {
                proximo.codifica(contexto.substring(1), simbolo, nosAnteriores);
                if(modificarModelo)
                	incContadorDoSimbolo(freqs, escape);
            }
            if(modificarModelo){
            	incContadorDoSimbolo(freqs, simbolo);
            	map.put(contexto, freqs);
            }
        }                
    }
    

    
    public int getSimbolo(String contexto) throws IOException {
        return getSimbolo(contexto, new boolean[maxSimbolos+2]);
    }

    public int getSimbolo(String contexto, boolean nosAnteriores[]) throws IOException {

        int simbolo = 0, escape = maxSimbolos;
        int low = 0, arith = 0, high = 0, total = 0;
        HashMap<Integer, Integer> freqs = map.get(contexto);
        
        if(freqs == null){
            simbolo = proximo.getSimbolo(contexto.substring(1), nosAnteriores);
            if(modificarModelo)
            	inserirContexto(contexto, simbolo, escape);
        } else {
            for(int i = 0; i < escape+2; i++)
                if(freqs.get(i) != null && !nosAnteriores[i])
                    total += freqs.get(i);
               
            arith = arithDecoder.getCurrentSymbolCount(total);

            while(nosAnteriores[simbolo] || freqs.get(simbolo) == null || low + freqs.get(simbolo) <= arith){
                if(nosAnteriores[simbolo])
                    simbolo++;
                else if(freqs.get(simbolo++) != null)
                    low += freqs.get(simbolo-1);
            }
            
            high = low + freqs.get(simbolo);
            
            arithDecoder.removeSymbolFromStream(low, high, total);
            
            if(modificarModelo)
            	incContadorDoSimbolo(freqs, simbolo);
            
            /* Debug */
            if(debug && simbolo == escape)
                System.out.printf("escape decodificado no contexto '%s' com low = %d arith = %d total = %d\n", contexto, low, arith, total);
            if(debug && simbolo != escape)
                System.out.printf("simbolo %c decodificado no contexto '%s' com low = %d arith = %d total = %d\n", simbolo, contexto, low, arith, total);
            /* Debug */

            if(simbolo == escape) {
                for(int i = 0; i < escape; i++)
                    if(freqs.get(i) != null)
                        nosAnteriores[i] = true;                
                
                simbolo = proximo.getSimbolo(contexto.substring(1), nosAnteriores);                
                if(modificarModelo)
                	incContadorDoSimbolo(freqs, simbolo);
            }
            if(modificarModelo)
            	map.put(contexto, freqs);
        }
        
        return simbolo;
    }

    public static ArithEncoder getArithEncoder() {
        return arithEncoder;
    }

    public static void setArithEncoder(ArithEncoder arithEncoder) {
        ContextoK.arithEncoder = arithEncoder;
    }

    public static ArithDecoder getArithDecoder() {
        return arithDecoder;
    }

    public static void setArithDecoder(ArithDecoder arithDecoder) {
        ContextoK.arithDecoder = arithDecoder;
    }

	public HashMap<String, HashMap<Integer, Integer>> getMap() {
		return map;
	}

	public void setMap(HashMap<String, HashMap<Integer, Integer>> map) {
		this.map = map;
	}    

	public void fromScanner(Scanner scanner){
		Scanner linha = null;
		String prefixo = "", contexto = "";
		HashMap<Integer, Integer> freqs = new HashMap<Integer, Integer>();
		if(scanner.hasNextLine()){
			linha = new Scanner(scanner.nextLine());
			if(linha.hasNext())
				prefixo = linha.next();
		}
		
		while(!prefixo.equals("new k") && scanner.hasNextLine()) {
			if(prefixo.equals("c=")){
				map.put(contexto, freqs);
				contexto = linha.nextLine();
				freqs = new HashMap<Integer, Integer>();
			} else if(prefixo.equals("o=")){
				int simb = linha.nextInt();
				int freq = linha.nextInt();
				freqs.put(simb, freq);
			}			
			linha = new Scanner(scanner.nextLine());
			if(!linha.hasNext())
				break;
			prefixo = linha.next();
		}	
	}
	
    public String toString() {
    	StringBuilder builder = new StringBuilder();
    	builder.append("new k\n");
    	for(String cont : map.keySet()){
    		builder.append("c= " +  cont + "\n");
    		for(int simb : map.get(cont).keySet()){
    			builder.append("o= " + simb + " " + map.get(cont).get(simb) + "\n");
    		}    		
    	}
    	return builder.toString();
    }
	
}

