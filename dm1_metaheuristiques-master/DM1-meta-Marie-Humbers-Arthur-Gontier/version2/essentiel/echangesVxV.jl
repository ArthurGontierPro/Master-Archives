
# =========================================================================== #

# Simple Descente : Amélioration de la solution avec de la recherche locale sur 2 voisinages (kp echange) et avec un choix judicieux de variables à ajouter à la solution

# =========================================================================== #

# Fonction testant si la solution valide toutes les contraintes
function testContr(nouC,sol)
	admis = true
	c = 1
	while admis == true && c <= size(nouC,1)
		sum = 0
		for i in nouC[c]
			sum = sum + sol[i]
		end
		if sum > 1
			admis = false
		end
		c = c + 1
	end
	return admis
end


# Fonction évaluant si la fonction objectif est amélioré avec le voisin
function testObjectif(C,voisin,sol)
	return dot(C,voisin) > dot(C,sol)
end


# Fonction rendant le vecteur des indices des variables dans l'ordre suivant: le plus intéressant à ajouter en premier
function Benef(C,nouV,sol)
	V = zeros(Float64,size(C,1))
	for i in 1:size(C,1)
		if size(nouV[i],1) != 0
			V[i] = C[i] / sum(nouV[i])
		else 
			V[i] = realmax(Float16)
		end
	end	
	V = V.*sol
	triV = sort!(copy(V),rev = true)
	k,prec = 1,-1
	Res = Vector{Int}(0)
	while k <= size(sol,1) && triV[k] != 0.0
		n = find(x->x==triV[k],V)
		if prec != triV[k]
			for i in 1:size(n,1)
				prec = triV[k]
				push!(Res,n[i])
				k = k + 1
			end
		else 
			k = k + 1
		end
	end
	return Res
end

# Fonction prenant le vecteur opposé à la solution 
function contraire(sol)
	sol1 = copy(sol)
	for i in 1:size(sol,1)
		if sol1[i] == 0
			sol1[i] = 1
		elseif sol1[i] == 1
			sol1[i] = 0
		end
	end
	return sol1
end


# Fonction renversant l'ordre des élèments de la matrice
function reverse(V)
	VV = Vector{Int}(0)
	for i in 1:size(V,1)
		push!(VV,V[size(V,1)-i+1])
	end
	return VV
end

# Version du 2-1 du kp echange
function echange2_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	ameliore = false
	#println("Kgoingdown ",Kgoingdown)
	#println("Pgoingup ",Pgoingup)
	l = 1
	while ameliore == false && l <= size(Pgoingup,1)
		i = 1
		while ameliore == false && i <= size(Kgoingdown,1)
			k = i + 1
			while ameliore == false && k <= size(Kgoingdown,1)
				voisin = copy(sol)
				voisin[Pgoingup[l]] = 1
				voisin[Kgoingdown[i]] = 0
				voisin[Kgoingdown[k]] = 0
				if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
					ameliore = true
					sol = voisin
				end
				k = k + 1
			end
			i = i + 1
		end
		l = l + 1
	end
	return sol
end

# Version du 1-1 du kp echange
function echange1_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	ameliore = false
	l = 1
	while ameliore == false && l <= size(Pgoingup,1)
		i = 1
		while ameliore == false && i <= size(Kgoingdown,1)
			voisin = copy(sol)
			voisin[Pgoingup[l]] = 1
			voisin[Kgoingdown[i]] = 0
			if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
				ameliore = true	
				sol = voisin
			end
			i = i + 1
		end
		l = l + 1
	end
	return sol
end

# Version du 0-1 du kp echange
function echange0_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	ameliore = false
	l = 1
	while ameliore == false && l <= size(Pgoingup,1)
		voisin = copy(sol)
		voisin[Pgoingup[l]] = 1
		if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
			sol = voisin
		end
		l = l + 1
	end
	return sol
end


# Fonction faisant le choix du voisinage à aller voir
function echangesVxV_Tri(C,nouV,nouC,sol) 
	Kgoingdown = reverse(Benef(C,nouV,sol)) # Ceux à 1
	voisin = copy(sol)
	Pgoingup = Benef(C,nouV,contraire(sol)) # Ceux à 0

	# Faire 2-1 échange
	if size(Kgoingdown,1) >= 2
		#println("2_1 echange")
		sol = echange2_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	# Faire 1-1 échange
	elseif size(Kgoingdown,1) >= 1
		#println("1_1 echange")
		sol = echange1_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	else
	# Faire 0-1 échange
		#println("0_1 echange")
		sol = echange0_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	end
	return sol
end


# Fonction de Simple Descente
function simpleDescente(C,nouV,nouC,sol)
	ameliore = true

	# Test si la solution donnée est valide
	if !testContr(nouC,sol)
		ameliore = false
		println("Solution d'entrée invalide")
	end

	# Toutes les variables présentes dans aucune contraintes sont mises à 1
	Pgoingup = Benef(C,nouV,contraire(sol))

	k = 1
	while size(nouV[Pgoingup[k]],1) == 0
		sol[Pgoingup[k]] = 1 
	end

	# Processus itératif recherchant un meilleur voisin
	while ameliore == true
		voisin = echangesVxV_Tri(C,nouV,nouC,sol)
		if dot(C,sol) >= dot(C,voisin)
			ameliore = false
		else 
			sol = voisin
		end
	end
	return sol
end


#=
name_file = "didactic.dat"
C,A,nouC,nouV = loadSPP2(name_file)

solInit = [0,1,0,1,0,0,0,0,0]
println("Solution kp-echange avec vecteur de vecteurs :")

gl1 = @time echangesVxV_Tri1(C,nouV,nouC,solInit) 
println(gl1)
println(" z = ",dot(gl1,C))
gl2 = @time simpleDescente(C,nouV,nouC,solInit)
println(gl2)
println(" z = ",dot(gl2,C))

=#
