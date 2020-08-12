
public class Patate {
	public int[] h;
	public int[] e;
	public int[][] G;//graphe du flot
	public int[][] G2;//graphe des capacités
	public int[] L;//tableau des présences dans la liste

	public Patate(int[] h,int[] e,int[][] G,int[][] G2){
		this.h = h;
		this.e = e;
		this.G = G;
		this.G2 = G2;
		this.L = new int[this.h.length];
		for (int m = 0; m < this.h.length;m++){
			this.L[m] = 1;
		}
	}

	public void PrintPatate(){
	String s1 = "h : ";
	String s2 = "e : ";
		for(int k = 0; k < this.h.length; k++){
			s1 += this.h[k] + " ";
			s2 += this.e[k] + " ";
		}
		s1 = s1 + "\n" + s2 + "\nFlot : \n";
		s2 = "Capacités : \n";
		for (int i = 0; i < this.G.length; i++){ // nb lignes
			s1+="    ";s2+="    ";
			for (int j = 0; j < this.G[0].length; j++){ // nb colonnes
				s1 += this.G[i][j] + " ";
				s2 += this.G2[i][j] + " ";
			}
			s1+="\n";
			s2+="\n";
		}
		s1+=s2;
/*
		s2 = "\nList : ";
		for(int k = 0; k < this.L.length; k++){
			s2 += this.L[k] + " ";
		}
		s1+=s2;
*/
		System.out.println(s1);
	}
}
