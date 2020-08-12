# Déclaration de la structure de données RawData (CF README).
# Données brute sans pré-traitement issues des instances
mutable struct RawData
	#Attribut(s) paint_batch_limit
	limitation::Int
	#Attribut(s) optimization_objectives
	nbObj::Int
	sortedObj::Vector{String}
	#Attribut(s) ratio
	ratioString::Vector{String}
	N::Vector{Int}
	P::Vector{Int}
	prio::Vector{Int}
	#Attribut(s) vehicles
	colorJ0::Vector{Int}
	matriceHLJ0::Matrix{Int}
	colorJ1::Vector{Int}
	matriceHLJ1::Matrix{Int}
end
#############################################################
# Déclaration de la structure de données Instance (CF README).
# A partir des données brutes, calculs des différents composants entrant dans la définition du modèles
mutable struct Instance
	nbObj::Int			#Attribut(s) optimization_objectives
	sObj::Vector{String}
	nbPos::Int			# Nombre de voitures à produire (mickaels?)
	s::Int 				# paint bash limit (longueur maximale de rafale de peinture)
	nbCmF::Int 			# Nombre de composants excluant les peintures
	nbC::Int 			# Nombre composants totaux (incluant les peintures)
	nbK::Int 			# Nombre de konfigurations différentes
	#
	delta::Vector{Int} 	# Nombre de voiture pour chaque configuration k
	d::Vector{Int} 		# Demande en composant c pour chaque composant c
	#
	a::Matrix{Int} # matrice décomposant l'appartenance des composant aux konfiguration journée J1
	#
	l::Vector{Int} # équilvalent au N du ratio : quota à respecter pour le composant c
	m::Vector{Int} # équilvalent au P du ratio : taille de la fenêtre glissante pour le composant c
	h::Vector{Int} # vecteur traduisant les priorités 1 si prio High 0 sinon
	#
	e::Matrix{Int} # matrice décomposant l'appartenance des composant aux konfiguration journée J0
	ml::Int
	mc::Vector{Int}
end
