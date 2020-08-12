import java.util.*;
import java.io.*;

public class GrandMain {
    public static void main(String[] args) {
        // arguments possibles :  numéro version utilisées (1 ou 2) ; nom du fichier à utiliser ; verbose ("verbose" ou "autre")
         String version = args[0];
         String fichier = args[1];
         String verbose = args[2];
        System.out.println("Projet de Graphes II et Réseaux");
        if (version.equals("0")){
            System.out.println("version : matrice");
        }else{System.out.println("version : Graphes(Tableau de Noeuds)");}
        System.out.println("fichier : "+ fichier);
        if (version.equals("verbose")){
           System.out.println("verbose : true");
        }else{           System.out.println("verbose : false");}
        System.out.println();

        System.out.println("Initialisation des données");
        float[][] tab = readScanner("jeu_donnees/" + fichier);
        float[][] table = remplissageSum(tab);
        affichageTab(table);


        if (version.equals("0")){
              MainMatrice general = new MainMatrice(verbose);
              general.main_matrice(table);
        }else{
              MainObjet general = new MainObjet(verbose);
              int[][] sol = general.main_objets(table);
               System.out.println();
             System.out.println("Résultat final : ");
             affichageTab(sol);
        }


    }


    public static float[][] readScanner(String filePath){
        try (Scanner scanner = new Scanner(new File(filePath))){
            int maxi = scanner.nextInt();
            int maxj = scanner.nextInt();
            float[][] tab = new float[maxi+1][maxj+1];
            int lon = 0;
            int lar = 0;      
            while (!(scanner.hasNext("."))){
                    String input = scanner.next();
                    String nombre = input.split(",")[0] + "." + input.split(",")[1];
                    tab[lon][lar] = Float.valueOf(nombre);
                    lar++;
                    if ((lar % maxj) == 0){
                        lon = lon + 1;
                        lar = 0;
                    }
            }
        return tab;
        } catch (Exception e){
                e.printStackTrace();
                System.out.println("Problème de format de fichier !");
                float[][] tab = new float[0][0];
                return tab;
            }
        }

    public static void affichageTab(float[][] Tab){
        for (int k = 0; k < Tab.length; k++){ // nb lignes
            for (int j = 0; j < Tab[0].length; j++){ // nb colonnes
                System.out.print(Tab[k][j] + " ");
            }
                System.out.println();
        }
    }

    public static void affichageTab(int[][] Tab){
        for (int k = 0; k < Tab.length; k++){ // nb lignes
            for (int j = 0; j < Tab[0].length; j++){ // nb colonnes
                System.out.print(Tab[k][j] + " ");
            }
                System.out.println();
        }
    }


    public static float[][] remplissageSum(float[][] Tab){
        for (int k = 0; k < Tab.length-1; k++){ // nb lignes
            float sum = 0;
            for (int j = 0; j < Tab[0].length-1; j++){ // nb colonnes
                    sum = sum + Tab[k][j];
            }
            Tab[k][Tab[0].length-1] = sum ;
        }

        for (int j = 0; j < Tab[0].length-1; j++){ // nb colonnes
            float sum = 0;
            for (int k = 0; k < Tab.length-1; k++){ // nb lignes
                    sum = sum + Tab[k][j];
            }
            Tab[Tab.length-1][j] = sum;
        }
        return Tab;
    }



}



