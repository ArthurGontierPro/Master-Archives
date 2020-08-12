# =========================================================================== #

# Glouton Intelligent : Tri des variables les plus utiles, avec une structure de vecteur de vecteurs

# =========================================================================== #

# Fonction évaluant la variable la plus intéressante à ajouter dans la solution selon les variables déjà présentes dans cette même solution
function BenefIndice(C,nouV,rV,rC)
	# Calcul des Couts / nombre d'apparitions dans les contraintes
	V = zeros(Float64,size(C,1))
	for i in 1:size(C,1)
		S = 0
		for j in 1:size(nouV[i],1)
			S = S + rC[nouV[i][j]]
		end
		if S != 0
			V[i] = C[i] / S
		end
	end

	# Recherche de l'indice de la variable la plus intéressante à ajouter dans la solution à partir du calcul précédents
	max,indicemax = 0,0
	for k in 1:size(rV,1)
		if V[k]*rV[k] > max
			indicemax = k
			max = V[k]
		end
	end
	return indicemax
end


# Fonction 
function gloutonVxV(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}})

	# Initialisation des vecteurs utiles
	nb_var = size(nouV,1)
	sol = (-1)*ones(Int,size(nouV,1))
	resteV = ones(Int,size(nouV,1)) # 0 -> vue
	resteC = ones(Int,size(nouC,1)) # 0 -> utilisée

	# Recherche de variables à ajouter à la solution tant que chaque variable n'a pas été "vue"
	while sum(resteV) != 0
	
		# Calcul élèment intéressant à ajouter
		poids = BenefIndice(C,nouV,resteV,resteC)

		# Si cet élèment n'est dans aucune contrainte
		if poids == 0
			n = find(x->x==1,resteV)
			for k in n
				sol[k] = 1
				resteV[k] = 0 
			end

		# Si cet élèment est présent dans au moins une contrainte, l'ajouter à la solution et mise des autres variables dans la condition à 0
		else
			sol[poids] = 1
			resteV[poids] = 0 
			for i in nouV[poids]
				if resteC[i] != 0
					for k in nouC[i]
						if k != poids && resteV[k] == 1
							sol[k] = 0
							resteV[k] = 0 
						end
					end
					resteC[i] = 0
				end
			end
		end
	end
	return sol
end

















