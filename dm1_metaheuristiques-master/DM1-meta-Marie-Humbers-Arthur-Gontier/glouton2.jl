
# =========================================================================== #

# Glouton avec la matrice, utilisant le tri des indices

# =========================================================================== #


function glouton2(C::Vector{Int}, A::Array{Int,2})
	nb_contr = size(A,1)
	nb = size(C,1)

	# Initialisation du vecteur solution
	solution = (-1)*ones(Int,1,nb)[1,:]

	Ctri = tripif(C)

	i = 1
	while i <= nb
		if solution[Ctri[i]] == -1
			solution[Ctri[i]] = 1
			for icontr in 1:nb_contr
				if A[icontr,Ctri[i]] == 1
					for k in 1:nb 
						if A[icontr,k] == 1 && solution[k] == -1
							solution[k] = 0
						end
					end
				end
			end 
		end		
		i = i + 1
	end
	return solution
end
