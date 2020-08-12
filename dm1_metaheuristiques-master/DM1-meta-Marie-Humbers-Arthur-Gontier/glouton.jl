# =========================================================================== #

# Glouton avec la matrice,ajoutant les premières variables possibles

# =========================================================================== #

function glouton(C::Vector{Int}, A::Array{Int,2})
	nb_contr = size(A,1)
	nb = size(C,1)

	# Initialisation du vecteur solution
	solution = Vector{Int}(nb)
	for i in 1:nb
		solution[i] = -1
	end

	isol = 1
	while isol <= nb
		if solution[isol] == -1
			solution[isol] = 1
			for icontr in 1:nb_contr
				if A[icontr,isol] == 1
					for k in 1:nb 
						if A[icontr,k] == 1 && solution[k] == -1
							solution[k] = 0
						end
					end
				end
			end 
		end		
		isol = isol + 1
	end
	return solution
end

