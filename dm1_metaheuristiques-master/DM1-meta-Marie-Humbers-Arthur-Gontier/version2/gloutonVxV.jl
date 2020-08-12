# =========================================================================== #

include("loadSPP2.jl")

# =========================================================================== #

function recherche(V::Vector{Int},ind::Int,res::Int)
	n = div(size(V,1),2)
	if ind <= V[size(V,1)] && ind > 0
		if size(V,1) == 1 && V[1] == ind
			trouve = 1 + res 
		elseif size(V,1) == 1 && V[1] != ind
			trouve = -1
		elseif V[n] == ind 
			trouve = n + res	
		elseif V[n] < ind
			trouve = recherche(V[(n+1):size(V,1)],ind,res+n)
		elseif V[n] > ind
			trouve = recherche(V[1:n],ind,res)
		end
	else
		trouve = -1
	end
	return trouve
end


function tripoids(C,nouV,resteV,resteC)
	nb_app = zeros(Float64,size(C,1))
	for k in resteV
		sum = 0
		for kk in nouV[k]
			if recherche(resteC,kk,0) != -1
				sum = sum + 1
			end
		end
		if sum != 0
			nb_app[k] = C[k]/sum 
		end 
	end

	indicemax = 1
	for k in resteV
		if nb_app[k] > nb_app[indicemax]
			indicemax = k
		end
	end

	return indicemax
end


function gloutonVxV(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}})
	nb_contr = size(nouC,1)
	nb_var = size(nouV,1)
	sol = (-1)*ones(Int,nb_var)
	resteV = Vector{Int}(1:nb_var)
	resteC = Vector{Int}(1:nb_contr)
	while size(resteV,1) != 0 
		poids = tripoids(C,nouV,resteV,resteC)
		sol[poids] = 1
		ind = recherche(resteV,poids,0)
		deleteat!(resteV,ind)
		for k in nouV[poids]
			for kk in nouC[k]
				if kk != poids && size(resteV,1) != 0
					ind = recherche(resteV,kk,0)
					if ind != -1
						sol[kk] = 0
						deleteat!(resteV,ind)
					end
				end
			end
			ind = recherche(resteC,k,0)
			deleteat!(resteC,ind)
		end
	end
	return sol
end

#name_file = "didactic.dat"
#C,A, nouC, nouV = loadSPP2(name_file)
#sol = @time glouton(C, nouV, nouC)
















