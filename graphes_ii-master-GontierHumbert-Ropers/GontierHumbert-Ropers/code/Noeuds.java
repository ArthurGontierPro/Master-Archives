import java.util.*;
import java.io.*;

public class Noeuds{
    private int e;
    private int h;
    private int d;
    private int[] c;
    private int[] min;
    private int[] f;
    private int[] liste; 

    // Constructeurs
    public Noeuds(int e,int h,int d,int[] c,int[] min,int[] f,int[] liste){
        this.e = e;
        this.h = h;
        this.d = d;
        this.c = c;
        this.min = min;
        this.f = f;
        this.liste = liste;
    }

    public Noeuds(int[] c,int[] min, int[] liste){
        this(0,0,0,c,min,new int[c.length],liste);        
    }

    public Noeuds(int d,int[] c,int[] liste){
        this(0,0,d,c,new int[c.length],new int[c.length],liste);        
    }

    public Noeuds(int[] c, int[] liste){
        this(0,0,0,c,new int[c.length],new int[c.length],liste);        
    }

    // Getters
    public int getE(){return this.e;}
    public int getH(){return this.h;}
    public int getD(){return this.d;}
    public int getC(int i){return this.c[i];}
    public int getMin(int i){return this.min[i];}
    public int getF(int i){return this.f[i];}
    public int[] getL(){return this.liste;}
    public int getListe(int i){return this.liste[i];}

    // Setters
    public void setE(int j){this.e = j;}
    public void setH(int j){this.h = j;}
    public void setD(int j){this.d = j;}
    public void setC(int i,int j){this.c[i] = j;}
    public void setCc(int[] j){this.c = j;}
    public void setM(int[] j){this.min = j;}
    public void setMin(int i,int j){this.min[i] = j;}
    public void setF(int i,int j){this.f[i] = j;}
    public void setN(int[] n){this.liste = n;}
    public void setNoeud(int i,int n){this.liste[i] = n;}


}
