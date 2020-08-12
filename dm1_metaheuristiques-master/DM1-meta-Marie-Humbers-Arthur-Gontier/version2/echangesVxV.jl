
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
	return map(x -> if x == 1 0 else 1 end, sol)
end

function reverse(V)
	VV = copy(V)
	for i in 1:div(size(V,1),2)
		VV[i],VV[size(V,1)-i+1] = VV[size(V,1)-i+1],VV[i]
	end
	return VV
end


# Version du 2-1 du kp echange
function echange2_1(C,nouC,sol,Kgoingdown,ind)
	ameliore = false
	i = 1
	S = copy(sol)
	while ameliore == false && i <= size(Kgoingdown,1)
		k = i + 1
		while ameliore == false && k <= size(Kgoingdown,1)
			voisin = copy(sol)
			voisin[ind] = 1
			voisin[Kgoingdown[i]] = 0
			voisin[Kgoingdown[k]] = 0
			if testObjectif(C,voisin,sol) && testContr(nouC,voisin)
				ameliore = true
				S = voisin
			end
			k = k + 1
		end
		i = i + 1
	end
	return S
end

# Version du 1-1 du kp echange
function echange1_1(C,nouC,sol,Kgoingdown,ind)
	i = 1
	S = copy(sol)
	ameliore = false
	while ameliore == false && i <= size(Kgoingdown,1)
		voisin = copy(sol)
		voisin[ind] = 1
		voisin[Kgoingdown[i]] = 0
		if testObjectif(C,voisin,sol) && testContr(nouC,voisin)
			ameliore = true	
			S = voisin
		end
		i = i + 1
	end
	return S
end

# Version du 0-1 du kp echange
function echange0_1(C,nouC,sol,ind)
	S = copy(sol)
	voisin = copy(sol)
	voisin[ind] = 1
	if testObjectif(C,voisin,sol) && testContr(nouC,voisin)
		S = voisin
	else 
		S = sol
	end
	return S
end

function echangesVxV_Tri2(C,nouV,nouC,sol) 
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


#Fonction de Simple Descente
function simpleDescente(C,nouV,nouC,sol)

	# Test si la solution donnée est valide
	if !testContr(nouC,sol)
		ameliore = false
		println("Solution d'entrée invalide")
	end


	# Toutes les variables présentes dans aucune contrainte sont mises à 1
	Pgoingup = Benef(C,nouV,contraire(sol))
	k = 1
	while size(nouV[Pgoingup[k]],1) == 0
		sol[Pgoingup[k]] = 1 
	end

	# Processus itératif recherchant un meilleur voisin
	ameliore = true
	while ameliore == true
		voisin = echangesVxV_Tri2(C,nouV,nouC,sol)
		if dot(C,sol) >= dot(C,voisin)
			ameliore = false
		else 
			sol = voisin
		end
	end
	return sol
end

#=
include("loadSPP2.jl")
name_file = "data/pb_1000rnd0700.dat" #"data/didactic.dat" #"data/pb_1000rnd0700.dat"
C,A,nouC,nouV = loadSPP2(name_file)


include("gloutonVxV2.jl")
println("Solution kp-echange avec vecteur de vecteurs vxv1:")


gl1 = @time gloutonVxV2(C,nouV,nouC)
#println(" z Init = ",dot(gl1,C))
gl2 = @time simpleDescente(C,nouV,nouC,gl1)
#println(gl2)
println(" z = ",dot(C,gl2))
=#
