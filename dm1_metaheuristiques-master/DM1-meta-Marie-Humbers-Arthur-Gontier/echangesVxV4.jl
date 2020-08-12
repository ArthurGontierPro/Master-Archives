
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

# Fonction donnant l'indice de la variable la plus intéressante à ajouter à la solution
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

# 0-1 échange
function ech0_1(C,nouV,nouC,sol,Z)
	voisin = copy(sol)
	ZActu = copy(Z)
	S = Benef(C,nouV,sol)
	for i in S
		if sol[i] == 0 
			voisin[i] = 1
			if testContr(nouC,voisin)
print("x")
				sol = copy(voisin)
				ZActu = Z + C[i]
			end
			voisin[i] = 0
		end
	end
	return sol,ZActu
end

# 1-1 échange
function ech1_1(C,nouV,nouC,sol,Z,i)
	ZActu = copy(Z)
	solActu = copy(sol)
	if sol[i] == 0 
		for k in nouV[i]
			for kk in nouC[k]
				if sol[kk] == 1 && i != kk
					sol[i],sol[kk] = 1,0
					if Z + C[i] - C[kk] > ZActu && testContr(nouC,sol)
print("x")
						ZActu = Z + C[i] - C[kk]
						solActu = copy(sol)
					end
					sol[i],sol[kk] = 0,1
				end
			end
		end
	end
	return solActu,ZActu
end

# 2-1 échange
function ech2_1(C,nouV,nouC,sol,Z,i)
	ZActu = copy(Z)
	solActu = copy(sol)
	if sol[i] == 0
		for k in nouV[i]
			for kk in nouC[k]
				if sol[kk] == 1 && kk != i
					for kkk in nouC[k]
						if sol[kkk] == 1 && kkk != i && kk != kkk
							sol[i],sol[kk],sol[kkk] = 1,0,0
							if Z + C[i] - C[kk] - C[kkk]> ZActu && testContr(nouC,sol)
print("x")
								ZActu = Z + C[kk] - C[kkk]
								solActu = copy(sol)
							end
							sol[i],sol[kk],sol[kkk] = 0,1,1
						end

					end
				end
			end
		end
	end
	return solActu,ZActu
end


# Fonction de plus profonde descente
function profondeDescente2(C,nouV,nouC,sol)
	Z = dot(C,sol)
	print("2-1 : ")
	for i in 1:size(sol,1)
		sol,Z = ech2_1(C,nouV,nouC,sol,Z,i)
	end
	println("")
	print("1-1 : ")
	for i in 1:size(sol,1)
		sol,Z = ech1_1(C,nouV,nouC,sol,Z,i)
	end
	println("")
	print("0-1 : ")
	sol,Z = ech0_1(C,nouV,nouC,sol,Z)
	println("")
	return sol,Z
end

