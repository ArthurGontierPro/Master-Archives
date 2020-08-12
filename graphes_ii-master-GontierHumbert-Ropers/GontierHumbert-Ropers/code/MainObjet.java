import java.util.*;
import java.io.*;

public class MainObjet {
    private String verbose;

    public MainObjet(String v){this.verbose = v;}

    public int[][] main_objets(float[][] table){

            int v = 0;
            int[][] sol = new int[table.length][table[0].length] ;
            boolean marche = true;
            while (marche && v < table.length){
                    Graphes G2 = new Graphes(table);
                    if (this.verbose.equals("verbose")){
                    System.out.println();
                    System.out.println();
                    System.out.println("Nouveau Lancé de préflot");
                    System.out.println("Valeur de v : "+ v);
                    System.out.println("Construction du Graphe et essais selon la valeur v donnée");
                    System.out.println("ConstructionEtape4 Done!");
		                    System.out.println();
	                    for (int k = 0; k < G2.getNN().length;k++){
		                    System.out.print("Successeur(s) de "+k+" : ");
	                        for (int i = 0; i < G2.getNd(k).getL().length;i++){
                                if (G2.getNd(k).getListe(i) == 1){
		                            System.out.print(i + " ");
                                }
                            }
		                    System.out.println();
                        }
                    }


                        G2.ConstructionEtape3(v);

                    if (this.verbose.equals("verbose")){
		                System.out.println();
                        System.out.println("ConstructionEtape3 Done!");
                        System.out.println("Les demandes des noeuds sont : ");
		                        System.out.println();
                        for (int k = 0; k < G2.getNN().length;k++){
	                        System.out.print(G2.getNd(k).getD() + " ");
                            if ( k == 0 || k == table[0].length -1 || k == G2.getNN().length-2){
	                            System.out.println();
                            }
                        }
	                    System.out.println();
                    }

                    G2.ConstructionEtape2();

                    if (this.verbose.equals("verbose")){
		                System.out.println();
                        System.out.println("ConstructionEtape2 Done!");
		                System.out.println();
	                    for (int k = 0; k < G2.getNN().length;k++){
		                    System.out.print("Successeur(s) de "+k+" : ");
	                        for (int i = 0; i < G2.getNd(k).getL().length;i++){
                                if (G2.getNd(k).getListe(i) == 1){
		                            System.out.print(i + " ");
                                }
                            }
		                    System.out.println();
                    }
                    }

                   G2.ConstructionEtape1();

                    if (this.verbose.equals("verbose")){
		                System.out.println();
                        System.out.println("ConstructionEtape1 Done!");
		                System.out.println();
	                    for (int k = 0; k < G2.getNN().length;k++){
		                    System.out.print("Successeur(s) de "+k+" (capacités): ");
	                        for (int i = 0; i < G2.getNd(k).getL().length;i++){
                                if (G2.getNd(k).getListe(i) == 1){
		                            System.out.print(i + " (" + G2.getNd(k).getC(i) + ") ");
                                }
                            }
		                    System.out.println();
                        }
                    }

	                G2.EleverVersLAvant();

                    if (this.verbose.equals("verbose")){
		                System.out.println();
                        System.out.println("Préflot");

	                    for (int k = 0; k < G2.getNN().length;k++){
		                    System.out.print("Successeur(s) de "+k+" (Flots/capacités): ");
	                        for (int i = 0; i < G2.getNd(k).getL().length;i++){
                                if (G2.getNd(k).getListe(i) == 1){
		                            System.out.print(i + " ("+G2.getNd(k).getC(i)+ "/" + G2.getNd(k).getC(i) + ") ");
                                }
                            }
		                    System.out.println();
                        }
                    }


                    //System.out.println("Préflot Done!");
                        int[][] Tab = G2.GetResultats(table);
                        marche = verifResultats(Tab,table);
                        System.out.println("En contraignant la capacité de l'arc d'une valeur de v égal à : "+v +", a-t'on un résultat correct : " + marche);
                        if (marche){sol = Tab.clone();
                                if (this.verbose.equals("verbose")){
                                    System.out.println("Résultat est correct au niveau des sommes pour une valeur de v de : "+v);
                                    System.out.println("Tableau initial");

                                int nbcol = table[0].length;
                                int nbligne = table.length;
                                for (int j=0; j < nbligne;j++){
                                    for (int k = 0; k < nbcol; k++){
                                        System.out.print(table[j][k] + " ");
                                    }
                                    System.out.println();
                                }
                                    System.out.println();
                                    System.out.println("Tableau des Résultats");

                                    System.out.println();
                                for (int j=0; j < nbligne;j++){
                                    for (int k = 0; k < nbcol; k++){
                                            System.out.print(Tab[j][k] + " ");
                                    }
                                    System.out.println();
                                }
                                    System.out.println();   
                               }
                        }

                        v = v + 1;
                }
                        v = v - 2;
        System.out.println();
        System.out.println("Il a été nécessaire de contraindre le flot en enlevant à la capacité de l'arc entre la nouvelle source et l'ancienne source la valeur de v suivante : "+v);
        return sol;
        }


    public boolean verifResultats(int[][] Tab,float[][] M){
        boolean marche = true;
        int col = 0;
        int ligne = 0;
        for (int j = 0; j < Tab.length -1; j++){
                if (Tab[j][Tab[0].length-1] < (int)M[j][Tab[0].length-1]){
                    marche = false;
                }
                col = col + Tab[j][Tab[0].length-1] ;


        }
        for (int j = 0; j < Tab[0].length -1; j++){
                if (Tab[Tab.length-1][j] < (int)M[Tab.length-1][j]){
                    marche = false;;
                }
                ligne = ligne + Tab[Tab.length-1][j] ;
        }

        if (col != ligne){ marche = false; }
        return marche;
    }


}







