# =========================================================================== #

# Glouton : utilisation de la matrice avec changements dans la matrice sans suppression

# =========================================================================== #

function gloutonM2(C::Vector{Int}, A::Array{Int,2})
	M = copy(A)
	D = copy(C)
	# Initialisation du vecteur solution
	solution = (-1)*ones(Int,1,size(C,1))[1,:]

	#les variables qui n'apparaissent dans aucune contraintes prennent comme coup D 0 sinon elle font boucler le glouton
	ivarlibres = find(x -> x==0,sum(M,1)[1,:])
	solution[ivarlibres] = 1
	D = D .* map(x -> if x!=0 1 else 0 end,sum(M,1)[1,:])

	while sum(D) != 0
		imax = indmax(D./sum(M,1)[1,:])
		for j in 1:size(M,1)
			if M[j,imax] == 1
				unused = find(isodd,M[j,:])
				solution[unused] = 0
				D[unused] = 0
				M[j,unused] = 0
			end
		end
		solution[imax] = 1	
	end
	return solution
end

