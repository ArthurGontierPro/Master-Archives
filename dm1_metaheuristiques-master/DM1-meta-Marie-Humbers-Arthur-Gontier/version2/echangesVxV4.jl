
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
	voisin = copy(sol)
	ZActu = copy(Z)
	for i in 1:size(sol,1)
		#println(sol[i] == 0," ",testContr(nouC,voisin))
		if sol[i] == 0 
			voisin[i] = 1
			if testContr(nouC,voisin)
				sol = copy(voisin)
				ZActu = Z + C[i]
			end
			voisin[i] = 0
		end
	end
	return sol,ZActu
end


function ech1_1(C,nouV,nouC,sol,Z,i)
	ZActu = copy(Z)
	solActu = copy(sol)
	if sol[i] == 0 
		#dejafait = zeros(Int,size(sol,1))
		for k in nouV[i]
			for kk in nouC[k]
				#println(i," ",k," ",kk)
				if sol[kk] == 1 && i != kk #dejafait[kk] == 0 &&
					sol[i],sol[kk] = 1,0
					if Z + C[i] - C[kk] > ZActu && testContr(nouC,sol)
						#println("1-1 IN")
						ZActu = Z + C[i] - C[kk]
						solActu = copy(sol)
					end
					sol[i],sol[kk] = 0,1
				end
				#dejafait[kk] = 1
			end
		end
	end
	return solActu,ZActu
end

function ech2_1(C,nouV,nouC,sol,Z,i)
	ZActu = copy(Z)
	solActu = copy(sol)
	if sol[i] == 0
		#dejafait = zeros(Int,size(sol,1))
		for k in nouV[i]
			for kk in nouC[k]
				if sol[kk] == 1 && kk != i #dejafait[nouC[k][kk]] == 0 &&
					for kkk in nouC[k]
						#println(i," ",kk," ",kkk)
						if sol[kkk] == 1 && kkk != i && kk != kkk
							sol[i],sol[kk],sol[kkk] = 1,0,0
							if Z + C[i] - C[kk] - C[kkk]> ZActu && testContr(nouC,sol)
								#println("2-1 IN")
								ZActu = Z + C[kk] - C[kkk]
								solActu = copy(sol)
							end
							sol[i],sol[kk],sol[kkk] = 0,1,1
						end

					end
				end
				#dejafait[kk] = 1
			end
		end
	end
	return solActu,ZActu
end


# Fonction de plus profonde descente
function profondeDescente2(C,nouV,nouC,sol)
	# Initialisation
	Z = dot(C,sol)
	# Processus itératif recherchant un meilleur voisin
	for i in 1:size(sol,1)
		sol,Z = ech2_1(C,nouV,nouC,sol,Z,i)
	end
	#println(sol," ",Z)
	for i in 1:size(sol,1)
		sol,Z = ech1_1(C,nouV,nouC,sol,Z,i)
	end
	#println(sol," ",Z)
	sol,Z = ech0_1(C,nouV,nouC,sol,Z)
	#println(sol," ",Z)
	return sol,Z
end

include("loadSPP2.jl")
name_file = "data/pb_2000rnd0700.dat" #"data/didactic.dat" #"data/pb_1000rnd0700.dat"
C,A,nouC,nouV = loadSPP2(name_file)


include("gloutonVxV2.jl")
println("Solution kp-echange avec vecteur de vecteurs :")

#=
#gl1 = @time echangesVxV_Tri3(C,nouV,nouC,solInit) 
#println(gl1)
#println(" z = ",dot(gl1,C))
gl1 = @time gloutonVxV2(C,nouV,nouC)
println(" z glouton = ",dot(gl1,C))
gl2,z = @time profondeDescente2(C,nouV,nouC,gl1)
#println(gl2)
println(" z = ",z)
=#

gl1 = @time gloutonVxV2(C,nouV,nouC)
println(" z Init = ",dot(gl1,C))
gl2,z = @time profondeDescente2(C,nouV,nouC,gl1)
#println(gl2)
println(" z = ",z)



