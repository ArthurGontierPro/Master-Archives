import java.util.*;
import java.io.*;

public class Graphes{
        private Noeuds[] Table;

	// Constructeur -> ConstructionEtape4
        public Graphes(float[][] M){this.Table = ConstructionEtape4(M);}
        

	//Getters
        public Noeuds[] getNN(){return this.Table;}
        public Noeuds getNd(int i){return this.Table[i];}


	//Setters
        public void setNN(Noeuds[] SS){this.Table = SS;}
        public void setNd(Noeuds SS, int i){this.Table[i] = SS;}

	//Construction par Etape
        public Noeuds[] ConstructionEtape4(float[][] M){

            int nbcol = M[0].length;
            int nbligne = M.length;

            // Construction de la liste de sommets
            Noeuds[] sommets = new Noeuds[nbcol+nbligne];
            int numero = sommets.length-1;

            // Construction du puits T
            //System.out.println("Puits T");
            Noeuds T = new Noeuds(new int[nbcol+nbligne],new int[nbcol+nbligne],new int[nbcol+nbligne]);
            sommets[numero] = T;
            numero = numero - 1;

            // Construction de la rangée de Noeud M[0]
            //System.out.println("Première Rangée de Noeud");
            int[] L = new int[nbcol+nbligne];
            L[sommets.length-1] = 1;
            int[] c = new int[nbcol+nbligne];
            int[] min = new int[nbcol+nbligne];
            for (int nb = 0; nb < nbligne-1; nb++){
                min[sommets.length-1] = (int)M[nb][nbcol-1];
                c[sommets.length-1] = (int)M[nb][nbcol-1] + 1;
                sommets[sommets.length-1].setNoeud(numero,2);
                sommets[nbcol+nb] = new Noeuds (c.clone(),min.clone(),L.clone());
                numero = numero - 1;
            }


            // Construction de la rangée de Noeud M
            //System.out.println("Deuxième Rangée de Noeud");
            int[] LL = new int[nbcol+nbligne];
            for (int sup= nbligne-1; sup < nbcol+nbligne-1;sup++){
                LL[sup] = 1 ;
            }
            int[] cc = new int[nbcol+nbligne];
            int[] min2 = new int[nbcol+nbligne];

            //System.out.println("Calcul");
            for (int j=0; j < nbcol-1;j++){
                for (int k = 0; k < nbligne-1; k++){
                     min2[k+nbcol] = (int)M[k][j];
                     cc[k+nbcol] = (int)M[k][j] + 1;
                     sommets[k+nbcol].setNoeud(j+1,2);
                }
                sommets[1+j] = new Noeuds(cc.clone(),min2.clone(),LL.clone());
                numero = numero - 1;
            }

            // Construction de la source S
            //System.out.println("Construction de la source S");
            int[] LLL = new int[nbcol+nbligne];
            int[] ccc = new int[nbcol+nbligne];
            int[] min3 = new int[nbcol+nbligne];
            for (int sup=0; sup < nbcol-1;sup++){
                 LLL[sup+1] = 1;
                 min3[sup+1] = (int)M[nbligne-1][sup];
                 ccc[sup+1] = (int)M[nbligne-1][sup] + 1;
                 sommets[sup+1].setNoeud(0,2);
            }
            sommets[0] = new Noeuds(ccc,min3,LLL);
            numero = numero - 1;

        return sommets;    
    }

// 1 -> le sommet est la source/donneur
// 2 -> le sommet est le receveur/puits


    public void ConstructionEtape3(int v){
    for (int k = 0 ; k < this.Table.length;k++){
            Noeuds N = this.Table[k];
            for (int i = 0; i <this.Table.length; i++){
                if (N.getListe(i) == 1) {
		            N.setC(i,N.getC(i)-N.getMin(i));
                    this.Table[i].setD(this.Table[i].getD() - N.getMin(i));
                    N.setD( N.getD() + N.getMin(i) );
		            N.setMin(i,0);
                 }
            }
        }
        int vv = 0; 
        for (int j = 0; j < this.Table.length;j++){
            if (this.Table[0].getListe(j) == 1){
                    vv = vv + this.Table[0].getC(j) ;
                }
            }
        int vvv = 0; 
        for (int j = 0; j < this.Table.length;j++){
            if (this.Table[j].getListe(this.Table.length-1) == 1){
                    vvv = vvv + this.Table[j].getC(this.Table.length-1) ;
                }
            }
        this.Table[0].setD(-vv+v); 
        this.Table[Table.length-1].setD(vvv);
    }


    public void ConstructionEtape2(){
        Noeuds[] Tableau = new Noeuds[this.Table.length + 3];
        Tableau[this.Table.length + 2] = new Noeuds(new int[this.Table.length + 3],new int[this.Table.length + 3]);
        Tableau[this.Table.length + 1] = new Noeuds(new int[this.Table.length + 3],new int[this.Table.length + 3]);
        Tableau[0] = new Noeuds(new int[this.Table.length + 3],new int[this.Table.length + 3]);

        for (int k = 0; k < this.Table.length;k++){
          Tableau[k+1] = new Noeuds(new int[this.Table.length + 3],new int[this.Table.length + 3]);
          for (int i = 0; i < this.Table.length ;i++){
                Tableau[k+1].setC(i+1,this.Table[k].getC(i));
                Tableau[k+1].setNoeud(i+1,this.Table[k].getListe(i)); 
          }
                if ( this.Table[k].getD() > 0 ){
                      Tableau[k+1].setC(this.Table.length + 1,this.Table[k].getD());
                      Tableau[k+1].setNoeud(this.Table.length + 1,1); 
                      Tableau[this.Table.length + 1].setNoeud(k+1,2);
                      Tableau[k+1].setD(0);
                }else{
                        if ( this.Table[k].getD() < 0 ){
                          Tableau[0].setC(k+1,-this.Table[k].getD());
                          Tableau[0].setNoeud(k+1,1); 
                          Tableau[k+1].setNoeud(0,2);
                          Tableau[k+1].setD(0);
                        }
                }

        }
        this.Table = Tableau;
    }


    public void ConstructionEtape1(){
        Noeuds T = this.Table[this.Table.length - 1];
        int sum = 0;
        for (int k = 0; k < this.Table.length -1; k++){
            if (this.Table[this.Table.length-2].getListe(k) == 2){
                sum = sum + this.Table[k].getC(this.Table.length-2);
            }
        } 
        this.Table[this.Table.length-2].setC(this.Table.length-1,sum);
        T.setNoeud(this.Table.length-2,2);
        this.Table[this.Table.length-2].setNoeud(this.Table.length-1,1);
    }


	// Préflots
	public void Elever(int k){
		int mini = 1000; //nb big 
		for (int j = 0; j < this.Table.length;j++){
			if ((this.Table[k].getListe(j) == 1 && this.Table[k].getC(j) > this.Table[k].getF(j)) || (this.Table[k].getListe(j) == 2 && this.Table[j].getF(k) > 0 ) ){
                if (this.Table[k].getH() < mini){
				    mini = this.Table[k].getH();
                }
			}
		}
		this.Table[k].setH(1+mini);
	}


	public void Avancer(int i, int j){
		int cf = 0;
		if (this.Table[i].getListe(j) == 1 && this.Table[i].getC(j) > this.Table[i].getF(j)){
			cf = this.Table[i].getC(j) - this.Table[i].getF(j) ;
		}else{
			if (this.Table[i].getListe(j) == 2 && this.Table[j].getF(i) > 0 ){
				cf = this.Table[j].getF(i) ;
		    }
		}
		int df = Math.min(this.Table[i].getE(),cf);
        if (this.Table[i].getListe(j) == 1){
		    this.Table[i].setF(j,this.Table[i].getF(j) + df); 
        }else{
               if (this.Table[i].getListe(j) == 2){
                    this.Table[j].setF(i,this.Table[j].getF(i) - df);
                }
        }
		this.Table[i].setE(this.Table[i].getE() - df); 
		this.Table[j].setE(this.Table[j].getE() + df);
   	}


	public void InitialiserPreflot(){
// Déjà initialisé d'après la structure du noeuds et graphes
 /*
		for (int k = 0; k < this.Table.length; k++){
			this.Table[k].setH(0);
			this.Table[k].setE(0);
			for (int i = 0; i < this.Table[k].length; i++){
				this.Table[k].setF(i,0);
			}
		}
*/
		this.Table[0].setH(this.Table.length);
		for (int k = 0; k < this.Table.length; k++){
            if (this.Table[0].getListe(k) == 1){
			  this.Table[0].setF(k,this.Table[0].getC(k)); 
 			  this.Table[k].setE(this.Table[0].getC(k));
			  this.Table[0].setE(this.Table[0].getE()-this.Table[0].getF(k));
            }
		}
     
	}



	public void Decharger(int i, int[][] courant, int[] current){
		while (this.Table[i].getE() > 0){
			int v = current[i-1];
            		int j = courant[i-1][v] ;
		if (courant[i-1][v] == -1){
			Elever(i);
			current[i-1] = 0; //prendre la tête de liste des voisins
			}else{

				// Calcul Cf    
				int cf = 0;
				if (this.Table[i].getListe(j) == 1 && this.Table[i].getC(j) > this.Table[i].getF(j)){
					    cf = this.Table[i].getC(j) - this.Table[i].getF(j) ;
					}else{
						if (this.Table[i].getListe(j) == 2 && this.Table[j].getF(i) > 0 ){
							cf = this.Table[j].getF(i) ;
						}
				}

				if ( cf > 0 && (this.Table[j].getH() + 1) == this.Table[i].getH() ){ 
					Avancer(i,j); 
				}

				current[i-1] = current[i-1] + 1;
		}							
		}
	}




	public void EleverVersLAvant(){
        InitialiserPreflot();
		LinkedList<Integer> L = new LinkedList<Integer>();
		for (int j = 1; j < this.Table.length-1;j++){
			L.add(j);
		}


		int[][] courant = new int[this.Table.length-2][this.Table.length];

        int num = this.Table.length-1;
        int nb = 0;
		for (int k = 0; k < this.Table.length-2;k++){
			for (int j = 0; j < this.Table.length;j++){
				if (this.Table[k+1].getListe(j) != 0){
                        courant[k][nb] = j; 
                        nb = nb + 1;
                        }else{
                        courant[k][num] = -1;
                        num = num - 1;
                    }
			}
            num = this.Table.length-1;
            nb = 0;
		}
		int[] current = new int[this.Table.length-2];
		int u = L.get(0);
		int iter = 0;
		int ancienneH = 0;
		while ( iter < L.size() ){ 
			u = L.get(iter);
			ancienneH = this.Table[u].getH();
			Decharger(u,courant,current);
			if (this.Table[u].getH() > ancienneH){
				L.remove(iter);
				L.addFirst(u);
				iter = 0;
			}
			iter = iter + 1;
		}
	}


    public void rempliSum(int[][] Tab){
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
}



	public int[][] GetResultats(float[][] M){

            int nbcol = M[0].length;
            int nbligne = M.length;
            int[][] Tab = new int[nbligne][nbcol]; 
            for (int j=0; j < nbligne;j++){
                for (int k = 0; k < nbcol; k++){
                     Tab[j][k] = (int)M[j][k];
                }
            }
            System.out.println();
            for (int j=2; j < nbcol+1;j++){
                for (int k = 1+nbcol; k < nbligne+nbcol; k++){
                        Tab[k-1-nbcol][j-2] = Tab[k-1-nbcol][j-2] + this.Table[j].getF(k);
                }
            }
		    rempliSum(Tab);
           return Tab;
    }


}








