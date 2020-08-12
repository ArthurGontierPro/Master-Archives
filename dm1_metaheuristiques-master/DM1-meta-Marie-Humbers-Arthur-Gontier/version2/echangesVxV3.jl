
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

function echangesT(C,nouV,nouC,sol,Z)
	for i in resteV0
		if Z + C[i] > ZActu && testContr()

		else 
			for k in nouC[nouV[i]]
				


			
			end
		end
	return sol,Z
end



function echangesTous(C,nouV,nouC,bestSol,Z)
	voisin = copy(bestSol)
	solActu = copy(voisin)
	ZActu = copy(Z)
	for i in 1:size(bestSol,1)
		#println(solActu," ",ZActu)
		#println(i," ",voisin)
		#println(bestSol[i] == 0," ",Z + C[i] ," ",ZActu," ", Z + C[i] > ZActu ," ", testContr(nouC,voisin))

		if bestSol[i] == 0
			voisin[i] = 1
			if testContr(nouC,voisin) # Z + C[i] > ZActu &&
				solActu = copy(voisin) 
				ZActu = Z + C[i] 
			else
				for k in 1:size(bestSol,1)
					if i != k && bestSol[k] == 1
						#println(i," ",k," ",voisin)
						voisin[k] = 0
						if Z + C[i] - C[k] > ZActu && testContr(nouC,voisin)
							solActu = copy(voisin) 
							ZActu = Z + C[i] - C[k]
						else

							for l in 1:size(bestSol,1)
								if i != l && k != l && bestSol[l] == 1 
									voisin[l] = 0
									#println(i," ",k, " ",l," ",voisin)
									#println(bestSol[i] == 0," ", bestSol[k] == 1 ," ", bestSol[l] == 1 ," ", Z + C[i] - C[k] - C[l] > ZActu ," ", testContr(nouC,voisin))
									if Z + C[i] - C[k] - C[l] > ZActu && testContr(nouC,voisin)
										solActu = copy(voisin) 
										ZACtu = Z + C[i] - C[k] - C[l]
									end
									voisin[l] = 1
								end
							end
						end
						voisin[k] = 1
					end
				end
			end
			voisin[i] = 0
		end
	end
	return solActu,ZActu
end


# Fonction de plus profonde descente
function profondeDescente(C,nouV,nouC,sol)
	# Initialisation
	bestZ = dot(C,sol)
	bestSol = sol
	ameliore = true

#=
	# Test si la solution donnée est valide
	if !testContr(nouC,sol)
		ameliore = false
		println("Solution d'entrée invalide")
	end


	for i in 1:size(sol,1)
		if size(nouV[i],1) == 0
			bestSol[i] = 1 
		end
	end
=#

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



