DM1 Métaheuristiques -- Gontier ; Humbert--Ropers

# Fichier principal
	main.jl -> Changer target pour trouver les instances
			Seulement les heuristiques sont lancées, la résolution exacte est en commentaire

# Fichiers de prétraitements :
	loadSPP2.jl
	getfname.jl
	pretraitement.jl
	
# Fichiers avec différents gloutons
	glouton.jl (glouton le plus basique)
	glouton2.jl (glouton tri des poids)
	gloutonM.jl (Suppression dans la matrice)
	gloutonM2.jl (Manipulation matrice)
	gloutonVxV2.jl -> Le plus rapide (Manipulation de vecteur de vecturs avec tri)

# Fichiers avec les descentes
	echangesimple.jl (simple descente)
	echangesVxV4.jl (plus profonde decente)
	echangeprofond3.jl -> Le plus efficace (plus profond descente et économe)
	
# Fichier résolution exacte :
	exact.jl

# Dossier avec les instances :
	data/

# Rapport 
	Gontier_Humbert_DM1.pdf

# Fichiers de résultats
	ResultatsToutesinstances.txt
	Resultats10instances.txt
