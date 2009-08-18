package ppmc.api;

import java.io.FileNotFoundException;
import java.util.LinkedList;

public class DesvioPadrao {

	private double valorMedio;
	private double valorDesvio;
	private static double log10_2;
	
	static {
		 log10_2 = Math.log10(2);
	}
	
	public DesvioPadrao(LinkedList<Double> infos) throws FileNotFoundException {
				
		valorMedio = 0;
		valorDesvio = 0;
				
		for(double d : infos){
			valorMedio += d;
		}
		valorMedio /= infos.size();
		
		for(double d : infos){
			valorDesvio += (d-valorMedio)*(d-valorMedio);
		}
		valorDesvio /= infos.size()-1;
	}

	public boolean dentroDoDesvio(double info){
		return (info < valorMedio+(valorDesvio/5) && info > valorMedio-(valorDesvio/5));
	}
	
	public double getValorMedio() {
		return valorMedio;
	}

	public double getValorDesvio() {
		return valorDesvio;
	}
	
	public static double log2(double n) {
		return Math.log10(n)/log10_2;
	}
}
