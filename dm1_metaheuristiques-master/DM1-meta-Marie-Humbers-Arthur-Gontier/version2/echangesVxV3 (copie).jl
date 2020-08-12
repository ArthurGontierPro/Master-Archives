
# =========================================================================== #

# Plus profonde Descente : Amélioration de la solution avec de la recherche locale sur 2 voisinages (kp echange)

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



function ech0_1(C,nouV,nouC,sol,Z)
	for i in size(sol,1)
		if sol[i] == 0 && testContr(nouc,sol)
			sol[i] = 1
			Z = Z + C[i]
		end
	end
	return sol,Z
end


function ech1_1(C,nouV,nouC,sol,Z)
	voisin = copy(sol)
	ZActu = copy(Z)
	solActu = copy(sol)
	for i in size(sol,1)
		if sol[i] == 0
			voisin[i] = 1 
			dejafait = ones(Int,size(sol,1))
			for k in nouV[i]
				for kk in nouC[k]
					if dejafait[kk] == 0 && sol[kk] == 1
						voisin[kk] = 0
						if Z + C[i] - C[kk] > ZActu && testContr(nouC,voisin)
							ZActu = Z + C[i] - C[kk]
							solActu = copy(voisin)
						end
						voisin[kk] = 1
					end
					dejafait[kk] = 1
				end
			end
			voisin[i] = 0
		end
	end
	return sol
end

function ech1_1(C,nouV,nouC,sol,Z)
	voisin = copy(sol)
	ZActu = copy(Z)
	solActu = copy(sol)
	for i in size(sol,1)
		if sol[i] == 0
			voisin[i] = 1 
			dejafait = ones(Int,size(sol,1))
			for k in nouV[i]
				for kk in 1:size(nouC[k],1)
					if dejafait[nouC[k][kk]] == 0 && sol[kk] == 1
						voisin[nouC[k][kk]] = 0
						for kk in 1:size(nouC[k],1)

							if Z + C[i] - C[nouC[k][kk]] > ZActu && testContr(nouC,voisin)
								ZActu = Z + C[i] - C[kk]
								solActu = copy(voisin)
							end

						end
						voisin[kk] = 1
					end
					dejafait[kk] = 1
				end
			end
			voisin[i] = 0
		end
	end
	return sol
end


# Fonction de plus profonde descente
function profondeDescente(C,nouV,nouC,sol)
	# Initialisation
	bestZ = dot(C,sol)
	bestSol = sol
	ameliore = true


	# Processus itératif recherchant un meilleur voisin
	while ameliore == true
		voisin,Z = echangesTous(C,nouV,nouC,bestSol,bestZ)
		if bestZ < Z
			bestSol = voisin
			bestZ = Z
		else 
			ameliore = false
		end
		#println(bestSol," ",ameliore," ",bestZ)
	end
	return bestSol,bestZ
end

include("loadSPP2.jl")
name_file = "data/pb_1000rnd0700.dat"
C,A,nouC,nouV = loadSPP2(name_file)


include("gloutonVxV2.jl")
println("Solution kp-echange avec vecteur de vecteurs :")

#gl1 = @time echangesVxV_Tri3(C,nouV,nouC,solInit) 
#println(gl1)
#println(" z = ",dot(gl1,C))
gl2,z = @time profondeDescente(C,nouV,nouC,gloutonVxV2(C,nouV,nouC))
println(gl2)
println(" z = ",dot(gl2,C))



