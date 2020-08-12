# =========================================================================== #

# Glouton Intelligent : choisissant une variable avec un cout intéressant

# =========================================================================== #

function BenefIndice(C,nouV,rV,rC)
	V = zeros(Float64,size(C,1))
	for i in 1:size(C,1)
		S = 0
		for j in 1:size(nouV[i],1)
			S = S + rC[nouV[i][j]]
		end
		#S = sum(rC[nouV[i][j]] for j in 1:size(nouV[i],1))
		if S != 0
			V[i] = C[i] / S
		end
	end
	max,indicemax = 0,0
	for k in 1:size(rV,1)
		if V[k]*rV[k] > max
			indicemax = k
			max = V[k]
		end
	end
	return indicemax
end


function gloutonVxV2(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}})
	nb_var = size(nouV,1)
	sol = (-1)*ones(Int,size(nouV,1))
	resteV = ones(Int,size(nouV,1)) # 0 -> vue
	resteC = ones(Int,size(nouC,1)) # 0 -> utilisée
	while sum(resteV) != 0
		poids = BenefIndice(C,nouV,resteV,resteC)
		#println(poids, " ",resteV," ",resteC)
		if poids == 0
			n = find(x->x==1,resteV)
			for k in n
				sol[k] = 1
				resteV[k] = 0 
			end
		else
			sol[poids] = 1
			resteV[poids] = 0 
			for i in nouV[poids]
				if resteC[i] != 0
					for k in nouC[i]
						if k != poids && resteV[k] == 1
							sol[k] = 0
							resteV[k] = 0 
						end
					end
					resteC[i] = 0
				end
			end
		end
	end
	return sol
end

#name_file = "didactic.dat"
#name_file = "data/pb_100rnd0800.dat"
#C,A, nouC, nouV = loadSPP2(name_file)
#sol = @time gloutonVxV2(C, nouV, nouC)
















