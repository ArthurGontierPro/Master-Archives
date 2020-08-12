
function admis(sol,nouV,nouC,i)
	flag = true
	ic = 1
	while ic <= size(nouV[i],1) && flag
		if sum(sol[nouC[nouV[i][ic]]]) > 1
			flag = false
		end
		ic = ic+1
	end
	return flag		
end

function tabou(C::Vector{Int},nouC::Vector{Vector{Int}},nouV::Vector{Vector{Int}},timelim::Int,TL::Int)
	nb = size(C,1)
	n = 1
	sol = echangeprofond3(nouV,nouC,copy(C),gloutonVxV2(C, nouV, nouC))
	solmax = copy(sol)
	init = copy(solmax)
	zmax = dot(C,solmax)
	zsol = zmax
	TM = zeros(Int,nb,nb)

	temps = time()


	while (time() < temps + timelim)
		nouvZ = 0
		nouJ = -1
		nouJJ = -1
		for j in 1:nb
			if sol[j] == 0
				for kc in nouV[j]
				for kv in nouC[kc]
					if sol[kv]==1 && TM[j,kv] < n && j!=kv
						sol[j] = 1
						sol[kv] = 0
						if nouvZ <= zsol + C[j] - C[kv] && admis(sol,nouV,nouC,j)
							nouvZ = zsol + C[j] - C[kv]
							nouJ = j
							nouJJ = kv
						end
						sol[j] = 0
						sol[kv] = 1
					end
				end
				end
			end
		end
		n = n + 1

		if nouJ != -1 && nouJJ != -1
			sol[nouJ] = 1
			sol[nouJJ] = 0
			zsol = nouvZ
			TM[nouJ,nouJJ] = TM[nouJJ,nouJ] = n + TL

			for contr in nouV[nouJ]
				for var in nouC[contr]
					if var != nouJ && sol[var] == 0
						sol[var] = 1
						if admis(sol,nouV,nouC,var)
							zsol = zsol + C[var]
print("dddddd")
						else
							sol[var] = 0
						end

					end
				end
			end


			if zmax < nouvZ
				solmax = copy(sol)
				zmax = nouvZ
			end

		end
	end
	return init,solmax,zmax
end


