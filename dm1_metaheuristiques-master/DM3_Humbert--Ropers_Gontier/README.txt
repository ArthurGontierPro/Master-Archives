DM1 Métaheuristiques -- Gontier ; Humbert--Ropers

Attention, adapter le chemin pour la lecture des fichiers

Pour constater les résultats, lancer julia 6 avec la commande suivante: julia -p 2

Pour observer les solutions, lancer dans julia : include("main.jl")
Pour obtenir la version graphique, décommenter les appels des fonctions avec le nom graphique dedans (recuit_graphique , par exemple )et décommenter les appels de plots

# Fichier principal
	main.jl -> Changer target pour trouver les instances
		
# Fichiers de prétraitements :
	loadSPP2.jl
	getfname.jl
	
# Fichiers avec heuristique de construction (glouton)
	gloutonrandom.jl -> glouton avec construction aléatoire
	gloutonVxV2.jl -> Le plus rapide (Manipulation de vecteur de vecturs avec tri)

# Fichiers avec les descentes
	echangeprofondtabou.jl -> plus profonde descente adaptée au tabou 
	echangeprofond3.jl -> Le plus efficace (plus profond descente et économe)
	
# Fichiers ReactiveGrasp
	pathrelinking.jl -> Path-Relinking
	reactiveGrasp.jl -> fonction principale du Grasp

# Fichiers Recuit Simulé
	recuit_simule.jl -> 
	recuit_graphique.jl -> 

# Fichiers Tabou
	tabou.jl -> Première version (1-1échange uniquement)
	tabou2.jl -> Deuxième ""
	tabou3.jl -> Meilleure version du Tabou (avec 2-1 échange)
	tabougraphique.jl ->

# Dossier avec les instances :
	data/

# Rapport 
	DM3_Humbert--Ropers_Gontier.pdf

# Fichiers de résultats
	resultats_battle3sec.txt (pas la dernière version)
	resultats_battle10sec.txt (pas la dernière version)
	resultats_tabou.txt
