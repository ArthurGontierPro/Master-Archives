# =========================================================================== #

# Recherche Locale en simple descente se basant sur les vecteurs de vecteurs 

# =========================================================================== #

# Fonction déterminant l'admissibilité de la solution donnée en entrée
function admis(sol,nouV,nouC,i)
	flag = true
	for ic in 1:size(nouV[i],1)
		if sum(sol[nouC[nouV[i][ic]]]) > 1
			flag = false
		end
	end
	return flag		
end

# 2-1 echange
function exch2_1(curry,nouV,nouC,C,sol,i,z)
	if sol[curry[i]] == 0
		nb = size(C,1)
		k = i+1
		pasmieux = true
		while k < nb && pasmieux
			if sol[curry[k]] == 1
				kk = k+1
				while kk <= nb && pasmieux
					if sol[curry[kk]] == 1	
						sol[curry[i]] = 1
						sol[curry[k]] = 0
						sol[curry[kk]] = 0
						zn = dot(C,sol)
						if admis(sol,nouV,nouC,curry[i]) && z < zn
							pasmieux = false
							z = zn
print("x")
						else
							sol[curry[i]] = 0
							sol[curry[k]] = 1
							sol[curry[kk]] = 1
						end
					end
					kk = kk+1
				end
			end
			k = k+1
		end
	end
	return sol,z
end

# 1-1 echange
function exch1_1(curry,nouV,nouC,C,sol,i,z)
	if sol[curry[i]] == 0
		nb = size(C,1)
		k = i+1
		pasmieux = true
		while k < nb && pasmieux
			if sol[curry[k]] == 1
				sol[curry[i]] = 1
				sol[curry[k]] = 0
				zn = dot(C,sol)
				if admis(sol,nouV,nouC,curry[i]) && z < zn
					pasmieux = false
					z = zn
print("x")
				else 
					sol[curry[i]] = 0
					sol[curry[k]] = 1
				end
			end
			k = k+1
		end
	end
	return sol,z
end

# 0-1 echange
function exch0_1(curry,nouV,nouC,C,sol,i)
	if sol[curry[i]] == 0
		sol[curry[i]] = 1
		if admis(sol,nouV,nouC,curry[i])
print("x")
		else
			sol[curry[i]] = 0
		end
	end
	return sol
end

# Fonction de simple descente
function echangesimple(curry,nouV,nouC,C,sol)
	z = dot(C,sol)
	print("2-1 : ")
	for i in 1:size(C,1)-2
		sol,z = exch2_1(curry,nouV,nouC,C,sol,i,z)
	end
	println("")
	print("1-1 : ")
	for i in 1:size(C,1)-1
		sol,z = exch1_1(curry,nouV,nouC,C,sol,i,z)
	end
	println("")
	print("0-1 : ")
	for i in 1:size(C,1)
		sol = exch0_1(curry,nouV,nouC,C,sol,i)
	end
	println("")
	return sol
end

