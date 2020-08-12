# Métaheuristique Multiobjectif  
Université de Nantes - Master 2 ORO - Année 2019/2020.

An integer linear programming approach and a hybrid variable neightborhood search for the car sequencing problem.  

* Lien vers l'[overleaf](https://www.overleaf.com/6913242165pqwzfxsgtvkf)  
* Lien vers les ressources de la [ROADEF](http://www.roadef.org/challenge/2005/fr/) et les [Instances](http://www.roadef.org/challenge/2005/fr/sujet.php)
* Package julia à installer :
```
using DataFrames,CSV,DelimitedFiles,JuMP
```

## Structure générale du dossier
```
main.jl - Méthode d'appel principale pour la résolution du problème de SPCar.
\Data   - Contient les instances du problème
    type A : instances de base pour le développement de l'algorithme
    type B : instances pour affiner l'algorithme
    type X : instances finales de test
\Doc    - Contient les documents tels que le sujet ou le manuel d'analyse des instances
\Src  
    include.jl       - fichier permettant de regrouper les différents includes aux méthodes (eg parseur)
    parseur.jl       - A partir d'une instance lue dans le répertoire Data, retourne une structure de données pour notre problème
    epsconstraint.jl - Fichier qui contient la méthode de résolution bi objective epsilon contrainte
    KetS.jl          - Fichier qui contient la méthode de résolution tri objective de Kirlik et Sayin
    model.jl         - Fichier qui contient tous les modèles utilisé dans ce projet
    structures.jl    - Fichier qui contient les structures
    tools.jl         - Fichier qui contient tous les outils utilisé dans les diférentes méthodes
```

**Remarques**
- Les includes et autres appels à des packages sont déclarés dans fichier [Src/include.jl](Src/include.jl)
- Les instances sont présentes dans le répertoire Data et sont présentées de la manière suivante :  
  * **optimization_objectives.txt :** Ce fichier donne l’ordre entre les différents objectifs d’optimisation, de l’objectif le plus prioritaire vers le moins prioritaire. Dans la suite du projet, on notera :
    * *HPRC* : high_priority_level_and_easy_to_satisfy_ratio_constraints
    * *PBC* : paint_color_batches
    * *LPRC* : low_priority_level_ratio_constraints
  * **paint_batch_limit.txt :** Ce fichier contient un entier représentant la longueur maximale acceptée pour les rafales de peinture.
  * **ratio.txt :** Ce fichier définit les contraintes de ratio prioritaires et non prioritaires. Sont définis dans le fichier suivant :
    * le ratio N/P
    * le flag de priorité (1=prioritaire, 0=non prioritaire)
    * l'identifiant
  * **vehicles.txt :** Un dataset de véhicules contenant les informations suivantes
    * **SeqRank :** le rang du véhicule dans la journée. Il s’agit du rang calculé par l’application opérationnelle de RENAULT. La numérotation commence à 1.
    * **Ident :** identifiant du véhicule.
    * **Paint Color :** code couleur du véhicule, pour la problématique des rafales de teinte.
    * **HPRCi :** 1 si le véhicule matche le ratio prioritaire RPi, 0 sinon. Nombre de champs   
    RPi = nombre de ratios prioritaires.
    * **LPRCi :** idem que HPRCi pour les ratios non prioritaires.

    *Note :* Les données HPRCi et LPRCi sont à mettre en relation avec les données présentent dans le fichier *ratio.txt*

