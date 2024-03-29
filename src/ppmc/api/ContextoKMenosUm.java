
package ppmc.api;

import java.io.IOException;
import java.util.Scanner;

/**
 *
 */
public class ContextoKMenosUm extends ContextoK {

    int[] freqs;
    int total;

    public ContextoKMenosUm(int maiorSimbolo) {
        super(maiorSimbolo);
        freqs = new int[maiorSimbolo+1];
        total = maiorSimbolo + 1;
        for(int i = 0; i < maiorSimbolo+1; i++){
            freqs[i] = 1;
        }
    }

    @Override
    protected void addAoModelo(String contexto, int simbolo, boolean[] nosAnteriores) throws IOException {

        if(simbolo == freqs.length){
//        	fileWriter.close();
            throw new IOException("EOF");
        }
        
        freqs[simbolo] = 0;
        total--;
    }
    
    @Override
    protected double getInfo(String contexto, int simbolo, boolean[] nosAnteriores) throws IOException {
    	
        if(simbolo == freqs.length){
//        	fileWriter.close();
        	throw new IOException("EOF");
        }
        
        return DesvioPadrao.log2(((double)total)/freqs[simbolo]);        
    }
    
    @Override
    public void codifica(String contexto, int simbolo, boolean nosAnteriores[]) throws IOException {

        int low = 0, high;

        if(simbolo == freqs.length)
            simbolo = maxSimbolos;
        
        for(int i = 0; i < simbolo; i++)
            low += freqs[i];        

        high = low + freqs[simbolo];

        fileWriter.write(freqs[simbolo] + " " + total + " ");
        arithEncoder.encode(low, high, total);

        /* Debug */
        if(debug && simbolo == maxSimbolos)
            System.out.printf("Codificando EOF com low = %d high = %d total = %d\n", low, high, total);
        if(debug && simbolo != maxSimbolos)
            System.out.printf("Codificando %c no contexto -1 com low = %d high = %d total = %d\n", simbolo, low, high, total);
        /* Debug */
        
        if(simbolo == maxSimbolos){
        	fileWriter.close();
            throw new IOException("EOF");
        }
        
        if(modificarModelo){
        	freqs[simbolo] = 0;
        	total--;
        }
        
    }

    @Override
    public int getSimbolo(String contexto) throws IOException {
        return getSimbolo(contexto, null);
    }

    @Override
    public int getSimbolo(String contexto, boolean nosAnteriores[]) throws IOException {
        
        int simbolo = 0, low = 0, arithLow, high, eof = maxSimbolos;
        
        arithLow = arithDecoder.getCurrentSymbolCount(total);

        while(low < arithLow || freqs[simbolo] == 0)
            low += freqs[simbolo++];       
        
        high = low + freqs[simbolo];

        /* Debug */
        if(debug && simbolo == eof)
            System.out.printf("EOF decodificado com low = %d arith = %d total = %d\n", low, arithLow, total);
        if(debug && simbolo != eof)
            System.out.printf("%c decodificado no contexto -1 com low = %d arith = %d total = %d\n", simbolo, low, arithLow, total);
        /* Debug */
        
        if(simbolo == eof)
            throw new IOException("EOF");
        
        arithDecoder.removeSymbolFromStream(low, high, total);
        
        if(modificarModelo){
        	freqs[simbolo] = 0;
        	total--;
        }
        
        return simbolo;
    }

	@Override
	public void fromScanner(Scanner scanner) {
		Scanner linha;
		String prefixo = "";
		
		for(int i = 0; i < freqs.length; i++)
			freqs[i] = 0;
		
		scanner.nextLine();
		linha = new Scanner(scanner.nextLine());
		prefixo = linha.next();
		
		while(!prefixo.equals("new k") && scanner.hasNextLine()) {
			if(prefixo.equals("o=")){
				int simb = linha.nextInt();
				freqs[simb] = 1;
			}			
			linha = new Scanner(scanner.nextLine());
			if(!linha.hasNext())break;
			prefixo = linha.next();
		}	
		
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
    	builder.append("new k\n");
    	for(int simb = 0; simb < freqs.length; simb++){
    		if(freqs[simb] == 1)
    			builder.append("o= " + simb + "\n");
   		}    		
    	
    	return builder.toString();
	}


    
    

}
