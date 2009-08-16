
package ppmc.api;

import java.io.IOException;

/**
 *
 */
public class ContextoKZero extends ContextoK {

    public ContextoKZero(int maiorSimbolo) {
        super(maiorSimbolo);
    }
    
    @Override
    protected void addAoModelo(String contexto, int simbolo, boolean[] nosAnteriores) throws IOException {
    	contexto = " ";
    	super.addAoModelo(contexto, simbolo, nosAnteriores);
    }
    
    @Override
    protected double getInfo(String contexto, int simbolo, boolean[] nosAnteriores) throws IOException {
    	contexto = " ";
    	return super.getInfo(contexto, simbolo, nosAnteriores);
    }
    

    @Override
    public void codifica(String contexto, int simbolo) throws IOException {
        contexto = " "; // para nao da erro com o contexto.substring(1);
        super.codifica(contexto, simbolo);
    }

    @Override
    public void codifica(String contexto, int simbolo, boolean nosAnteriores[]) throws IOException {
        contexto = " "; // para nao da erro com o contexto.substring(1);
        super.codifica(contexto, simbolo, nosAnteriores);
    }

    @Override
    public int getSimbolo(String contexto) throws IOException {
        contexto = " "; // para nao da erro com o contexto.substring(1);
        return getSimbolo(contexto, new boolean[maxSimbolos+2]);
    }

    @Override
    public int getSimbolo(String contexto, boolean nosAnteriores[]) throws IOException {
        contexto = " "; // para nao da erro com o contexto.substring(1);
        return super.getSimbolo(contexto, nosAnteriores);
    }

}
