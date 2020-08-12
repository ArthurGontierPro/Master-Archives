# =========================================================================== #

# Glouton : utilisation de la matrice avec suppression de lignes et colonnes

# =========================================================================== #

# Fonction qui tri les indices selon les coûts
function triCout(C,newA,varia)
	indicemax, Cout, ind = 0 , 0 , 0
	for k in 1:size(varia,1)
		nv = C[varia[k]] / (sum(newA[:,k]))
		if nv > Cout
			Cout = nv
			indicemax = varia[k]
			ind = k
		end
	end
	return indicemax,ind
end

# Fonction qui supprime une colonne de la matrice
function enleveColonneV(A,V,varia)
	M = Array{Int,2}(size(A,1),size(A,2)-size(V,1))
	Va = Vector{Int}(0)
	k,i = 1,1
	while i <= (size(A,2))
		if k <= size(V,1)
			if i != V[k]
				M[:,(i-k+1)] = A[:,i]
				push!(Va,varia[i])
			elseif i == V[k]
				k = k + 1
			end
		else 
			M[:,(i-(size(V,1)))] = A[:,i]
			push!(Va,varia[i])
		end
		i = i + 1
	end
	return M,Va
end

# Fonction qui enlève une ligne de la matrice
function enleveLigneV(A,V)
	M = Array{Int,2}((size(A,1)-size(V,1)),size(A,2))
	k,i = 1,1
	while i <= (size(A,1))
		if k <= size(V,1)
			if i == V[k]
				k = k + 1
			elseif i != V[k]
				M[(i-k+1),:] = A[i,:]
			end
		elseif k > size(V,1)
			M[(i-(size(V,1))),:] = A[i,:]
		end
		i = i + 1
	end
	return M
end

# Fonction qui enlève les contraintes redondantes
function enleverRedondance(A)
	V = Vector{Int}(0)

	for k in 1:size(A,1)
		if sum(A[k,:]) == 0
			 push!(V,k)	
		end
	end
	M = enleveLigneV(A,V)

	return M
end

# Fonction principale du glouton 
function gloutonM(C::Vector{Int}, A::Array{Int64,2})
	nb_var = size(A,2)
	sol = (-1)*ones(Int,nb_var)
	varia = Vector{Int}(1:nb_var)
	newA = copy(A)

	#les variables qui n'apparaissent dans aucune contraintes sont supprimées sinon elle font boucler le glouton#newA[:,3] = 0
	ivarlibres = find(x -> x==0,sum(newA,1)[1,:])
	sol[ivarlibres] = 1
	newA,varia = enleveColonneV(newA,ivarlibres,varia)

	while size(newA,1) != 0
		indicemax,ind = triCout(C,newA,varia)
		k = 1
		Lig = Vector{Int}(0)
		Col = Vector{Int}(0)
		while k <= size(newA,1)
			if newA[k,ind] == 1
				push!(Lig,k)
				kkl = 1
				while kkl <= size(newA,2)
					if newA[k,kkl] == 1 && sol[varia[kkl]] == -1
						if varia[kkl] == indicemax
							sol[indicemax] = 1
						else 
							sol[varia[kkl]] = 0
						end
						push!(Col,kkl)
					end
					kkl = kkl + 1
				end
			end
			k =  k + 1 
		end
		newA,varia = enleveColonneV(newA,sort!(Col),varia)
		newA = enleveLigneV(newA,Lig)
		newA = enleverRedondance(newA)
	end
	return sol
end

