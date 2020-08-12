Afin de lancer les algorithmes, il est VITALE d'entrer d'abord la commande suivante, UNE seule fois dans le REPL:

julia> include("structure.jl")

ensuite, lancer dans le même REPL

julia> include("main.jl")

La fonction qui donne accès à toutes les versions et différentes résolutions est la suivante, (les valeurs données sont celles par défaut):

julia> main(<num>,<versionV=1>,<versionN=1>,<p=5>,<comparaison=false>,<station = false>)


Détails des arguments de la fonction :
- num : permet de choisir entre un branch & bound simple (2) ou un branch & bound avec choix heuristiques (1) 

Uniquement pour le branch & bound à choix heuristiques:
- versionV = 1 -> choix de la variable la plus proche d'un entier
- versionV = 2 -> choix de la première variable qui n'est pas entière

- versionN = 1 -> choix du noeud avec la solution duale actuelle
- versionN = 2 -> choix du noeud avec la solution duale actuelle ou bien choix du noeud actuelle avec le hot start de JuMP

- p appartient à [0;100] : pourcentage qui permet de plus(100%) ou moins(0%) privilégier le hot start avec le fils du noeud actuel (au détriment du noeud contenant la solution duale) 

Pour les deux versions il est possible d'injecter comme solution primale la solution du MIP
-comparaison = true -> permet de partir comme solution primale de base avec la solution du solver MIP de GLPK
-comparaison = false -> permet de partir comme solution primale égale à l'infini


Toutes les données de départ sont dans le fichier data.jl, il est possible d'en modifier certaines directelnt dans le fichier : la capacité des rames (caprames), les fréquences (Fee et freqmax), et les coûts des train (Coutdist et Coutfixe)

Pour les stations de la ligne tram-cargo, la résolution se lance avec le dernier argument :
- station = true -> lance la résolution et rend les stations retenues


Exemple de lancements possibles :
main(2)
main(1,1,1)
main(1,2,2,5)
main(1,2,2,5,false,true)





