# =========================================================================== #

# Fonctions de prétraitement ou réutilisées dans les gloutons

# =========================================================================== #

# Fonction rendant les indices des variables avec les plus grands coûts
function tripif(C::Vector{Int})
	res = Vector{Int}(size(C,1))
	D = copy(C)
	for i in 1:size(C,1)
		imax = indmax(D)
		res[i] = imax
		D[imax] = 0
	end
	return res
end

function tripiffloat(C::Vector{Float64})
	res = Vector{Int}(size(C,1))
	D = copy(C)
	for i in 1:size(C,1)
		imax = indmax(D)
		res[i] = imax
		D[imax] = 0
	end
	return res
end

# Fonction qui passe de la matrice au vecteur de vecteurs
function passoireanouilles(C,A)
	avect = Vector{Vector{Int}}(size(A,2))
	for i in 1:size(A,2)
		jj = 1
		V = Vector{Int}(sum(A[:,i]))
		for k in 1:size(A,1)
			if A[k,i]==1
				V[jj] = k
				jj = jj + 1
			end
		avect[i] = V
		end
	end 
	return avect
end

# Fonction construisant le vecteur de poids
function poulet(C,A)
	pcontr = sum(A,1)[1,:]
	currypatrie = C./pcontr
	return tripiffloat(currypatrie)
end


