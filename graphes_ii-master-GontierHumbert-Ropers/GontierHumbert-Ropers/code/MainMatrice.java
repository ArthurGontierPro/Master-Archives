import java.util.*;
import java.io.*;

public class MainMatrice {
    private String verbose;

    public MainMatrice(String v){this.verbose = v;}

    public void main_matrice(float[][] table) {


	    System.out.println("");
            System.out.println("Etapes");
	    System.out.println("");

	int[][] G4 = ConstructionReseau(table);

        System.out.println("ConstructionEtape4");
	    printTabEt4(G4);

	int[] d = ConstructionEtape3(G4);
	
        System.out.println("ConstructionEtape3");
	    printTabEt3(G4,d);

	int[][] G2 = ConstructionEtape2(G4,d);

        System.out.println("ConstructionEtape2");
	    printTabEt2(G2);

	int[][] G0 = Preflot(G2);
	
	boolean demande = ConstructionEtape1(G0,d);

    if (this.verbose.equals("verbose")){
        System.out.println("Tableau initial");
	    printTab(table);
    }
	int[][] G = remplissageSum(constructSol(G0,G4));
    System.out.println();
    System.out.println("Résultats du Préflot");
	printTab(G);

	System.out.println("Demandes satisfaites ? "+demande);
	System.out.println("Sommes correctes ? "+verifSum(G));

    }
    public static int[][] constructSol(int[][] G, int[][] tab){
	int cc = tab.length;
	int ll = tab[0].length;
	int[][] sol = new int[cc][ll];
	for (int k = 0; k < cc-1; k++){
            for (int j = 0; j < ll-1; j++){
		if(G[k][j]>0){
		    sol[k][j] = tab[k][j]+1;
		}else{
		    sol[k][j] = tab[k][j];
		}
	    }
	}
	return sol;
    }
    public static boolean verifSum(int[][] Tab){
	boolean flag = true;
        for (int k = 0; k < Tab.length-1; k++){ // nb lignes
            int sum = 0;
            for (int j = 0; j < Tab[0].length-1; j++){ // nb colonnes
                    sum = sum + Tab[k][j];
            }
            flag = flag && Tab[k][Tab[0].length-1] == sum;//System.out.println(flag);
	    
        }

        for (int j = 0; j < Tab[0].length-1; j++){ // nb colonnes
            int sum = 0;
            for (int k = 0; k < Tab.length-1; k++){ // nb lignes
                    sum = sum + Tab[k][j];
            }
            flag = flag && Tab[Tab.length-1][j] == sum;//System.out.println(flag);
        }
	return flag;
    }
    public static void printTab(float[][] tab){
	for (int k = 0; k < tab.length; k++){ // nb lignes
	    String s = "";
            for (int j = 0; j < tab[0].length; j++){ // nb colonnes
		s += " "+tab[k][j];
	    }
	    System.out.println(s);
	}
	System.out.println("");
    }
    public static void printTab(int[][] tab){
	for (int k = 0; k < tab.length; k++){ // nb lignes
	    String s = "";
            for (int j = 0; j < tab[0].length; j++){ // nb colonnes
		s += " "+tab[k][j];
	    }
	    System.out.println(s);
	}
	System.out.println("");
    }
    public static void printTabEt4(int[][] tab){
	for (int k = 0; k < tab.length; k++){ // nb lignes
	    String s = "";
            for (int j = 0; j < tab[0].length; j++){ // nb colonnes
		s += " ["+tab[k][j] + ";" + (tab[k][j]+1) + "]";
	    }
	    System.out.println(s);
	}
	System.out.println("");
    }
    public static void printTabEt3(int[][] tab,int[] d){
	for (int k = 0; k < tab.length; k++){ // nb lignes
	    String s = "";
            for (int j = 0; j < tab[0].length; j++){ // nb colonnes
		s += "1 ";
	    }
	    System.out.println(s);
	}
	String s = "";
	for(int k = 0; k < d.length; k++){
	    s+= " " + d[k];
	}
	System.out.println("demandes : " + s);
	System.out.println("");
    }
    public static void printTabEt2(int[][] tab){
	for (int k = 0; k < tab.length; k++){ // nb lignes
	    String s = "";
            for (int j = 0; j < tab[0].length; j++){ // nb colonnes
		s += " "+tab[k][j];
	    }
	    System.out.println(s);
	}
	System.out.println("");
    }
        
    public static Patate InitPreflot(Patate p){
	int cc = p.G2.length;
	int ll = p.G2[0].length;
	for (int k = 0; k < p.h.length; k++){
	    p.h[k] = 0;
	    p.e[k] = 0;
	}
	for (int i = 0; i < cc; i++){ // nb lignes
            for (int j = 0; j < ll; j++){ // nb colonnes
		p.G[i][j] = 0;
	    }
	}

	for (int i=0; i < ll-1; i++){
	    p.G[cc-1][i] = p.G2[cc-1][i];
	    p.e[i] = p.G2[cc-1][i];
	}
	return p;
    }
    
    public static Patate Elever(int u,Patate p){
	int cc = p.G.length;
	int ll = p.G[0].length;
	int min = 999999;
	if (u < ll-1){
	    for (int i = 0; i < cc-1; i ++){
		if (p.G[i][u] < p.G2[i][u]){
		    min = Math.min(min, p.h[i+ll-1]);
		}
	    }
	    min = Math.min(min, p.h.length+2);
	} else {
	    for (int i = 0; i < ll-1; i ++){
		if (p.G[u-ll+1][i] > 0){
		    min = Math.min(min, p.h[i]);
		}
	    }
	    if (p.G2[u-ll+1][ll-1] - p.G[u-ll+1][ll-1] > 0){
		min = 0;
	    }
	}
	p.h[u] = min + 1;
	return p;
    }

    public static Patate Avancer(int u,int v, Patate p,boolean rev){
	int cc = p.G.length;
	int ll = p.G[0].length;
	int d;
	
	if (u < ll-1){
	    if(rev){d = Math.min(p.e[u],p.G[v][u]);}else{d = Math.min(p.e[u],p.G2[v][u]-p.G[v][u]);}
	    if(rev){p.G[v][u] -= d;}else{p.G[v][u] += d;}
	    if (v!=cc-1){p.e[v+ll-1] += d;}
	}else{
	    if(rev){d = Math.min(p.e[u],p.G[u-ll+1][v]);}else{d = Math.min(p.e[u],p.G2[u-ll+1][v]-p.G[u-ll+1][v]);}
	    if(rev){p.G[u-ll+1][v] -= d;}else{p.G[u-ll+1][v] += d;}
	    if (v!=ll-1){p.e[v] += d;}
	}
	p.e[u] -= d;
	return p;
    }

    public Patate Decharger(int u, Patate p){
	int cc = p.G.length;
	int ll = p.G[0].length;
	int i = 0;
	while (p.e[u] > 0){
	    if (u < ll-1){
		if (i < cc-1){
		    if (p.G2[i][u]-p.G[i][u]>0 && p.h[u] == p.h[i+ll-1]+1){
			p = Avancer(u,i,p,false);if (this.verbose.equals("verbose")){System.out.println("VERS LES L");p.PrintPatate();}
		    }
		    i++;
		}else{
		    if (p.h[u] > p.h.length && p.G[i][u] > 0){
			p = Avancer(u,i,p,true);

                   if (this.verbose.equals("verbose")){System.out.println("RETOUR VERS LA SOURCE");p.PrintPatate();}
		    }else{
			p = Elever(u,p);
			i = 0;
		    }
		}
	    } else {
		if (i < ll-1){
		    if (p.G[u-ll+1][i] > 0 && p.h[u] == p.h[i]+1){
			p = Avancer(u,i,p,true);if (this.verbose.equals("verbose")){System.out.println("RETOUR AUX C");p.PrintPatate();}
		    }
		    i++;
		}else{
		    if (p.G2[u-ll+1][i]-p.G[u-ll+1][i] > 0 && p.h[u] > 0){
			p = Avancer(u,i,p,false);if (this.verbose.equals("verbose")){System.out.println("VERS LE PUITS");p.PrintPatate();}
		    }else{
			p = Elever(u,p);
			i = 0;
		    }
		}		  	
	    }
	}
	return p;
    }

    public int[][] Preflot(int[][] G2){
	int cc = G2.length;
	int ll = G2[0].length;
	int[] h = new int[cc+ll-2];
	int[] e = new int[cc+ll-2];
	int[][] G = new int[cc][ll];
	Patate p = new Patate(h,e,G,G2);

	p = InitPreflot(p);

    if (this.verbose.equals("verbose")){p.PrintPatate();}

	int somme = 0;
	for(int b = 0; b < p.e.length;b++){
	    somme += e[b];
	}   
	int u = 0;
	while (somme > 0){
	    if (p.L[u] == 1){
		int tmp = p.h[u];
		p = Decharger(u,p);
		if (tmp == p.h[u]){
		    //p.L[u] = 0;
		}
		somme = 0;
		for(int b = 0; b < p.e.length;b++){
		    somme += e[b];
		}
		u++;
		if (u >= p.L.length){
		    u = 0;
		}
	    }
	}
	return p.G;
    }

    public static boolean ConstructionEtape1(int[][] G,int[] d){
	boolean flag = true;
	int j = 0;
	for (int i = G.length-1; i < d.length; i++){
	    flag = flag && (d[i] <= G[G.length-1][j]);
	    j++;
	}
	return flag;
    }

    public static int[][] ConstructionEtape2(int[][] G3,int[] d){
	int[][] G2 = new int[G3.length][G3[0].length];
	for (int i = 0; i < G3.length-1; i++){ // nb lignes
            for (int j = 0; j < G3[0].length-1; j++){ // nb colonnes
		G2[i][j] = 1;
	    }
	}
	int k = 0;
	for (int i = 0; i < G3.length-1; i++){
	    G2[i][G3[0].length-1] = 1 - d[k];k++;
	}
	for (int j = 0; j < G3[0].length-1; j++){
	    G2[G3.length-1][j] = 1 + d[k];k++;
	}
	G2[G3.length-1][G3[0].length-1] = 0;
	return G2;
    }

    public static int[] ConstructionEtape3(int[][] G4){
	int[] d = new int[G4.length + G4[0].length-2];
	int k = 0;
	for (int i = 0; i < G4.length -1; i++){//calcul des demandes des noeuds colonnes
	    int s = 0;
	    for (int j = 0; j < G4[0].length -1; j++){
		s+=G4[i][j];
	    }
	    d[k] = s - G4[i][G4[0].length-1];
	    k++;
	}
	for (int j = 0; j < G4[0].length -1; j++){//calcul des demandes des noeuds lignes
	    int s = 0;
	    for (int i = 0; i < G4.length -1; i++){
		s-=G4[i][j];
	    }
	    d[k] = s + G4[G4.length-1][j];
	    k++;
	}
	return d;
    }

    public static int[][] ConstructionReseau(float[][] tab){
	int[][] G4 = new int[tab.length][tab[0].length];
	for (int k = 0; k < tab.length; k++){ // nb lignes
            for (int j = 0; j < tab[0].length; j++){ // nb colonnes
		G4[k][j] =(int) tab[k][j];
	    }
	}
	return G4;
    }



    public static int[][] remplissageSum(int[][] Tab){
        for (int k = 0; k < Tab.length-1; k++){ // nb lignes
            int sum = 0;
            for (int j = 0; j < Tab[0].length-1; j++){ // nb colonnes
                    sum = sum + Tab[k][j];
            }
            Tab[k][Tab[0].length-1] = sum ;
        }

        for (int j = 0; j < Tab[0].length-1; j++){ // nb colonnes
            int sum = 0;
            for (int k = 0; k < Tab.length-1; k++){ // nb lignes
                    sum = sum + Tab[k][j];
            }
            Tab[Tab.length-1][j] = sum;
        }
        return Tab;
    }


}







