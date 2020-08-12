
Multicriteria Simplex
Université de Nantes - Master 1 ORO - Année 2019.
 * Stagiaires : 
    - Arthur GONTIER
    - Sanjy ANDRIAMISEZA
 * Encadrants :
    - Xavier GANDIBLEUX
    - Anthony PRZYBLYSKY

* Lien vers le rapport final [overleaf](https://fr.overleaf.com/read/tbrrfjkzbsdb)  
* Package julia à utiliser :
```
using JuMP, MathOptInterface, LinearAlgebra, Gurobi
```


Résumé : Ce projet consiste en l'implémentation julia d'un simplexe multicritère avec l'aide de la forme révisée du simplexe et la décompusition LU. L'algorithme utilisé est tiré du chapitre 7 du livre de Matthias Ehrgott à quelques choix d'implémentation près. Une énumération plus efficace est aussi proposé. L'algorithme est décomposé en trois phases p1.jl p2.jl et p3.jl, les fichiers p3sorted.jl et p3test.jl sont respectivement des implémentations avec les bases triées et la matrice inverse de la phase 3.

Le générator.jl génère des instances aléatoires et le parser.jl peut lire des instances au format .mop

Le prétraitement.jl est utilisé pour retirer les variables et contraintes redondantes du problème.

Ce travail a été réalisé dans le cadre d'un stage encadré de recherche au L2SN mais il reste améliorable.