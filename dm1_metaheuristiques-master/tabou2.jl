

function tabou2(C::Vector{Int},nouC::Vector{Vector{Int}},nouV::Vector{Vector{Int}},timelim::Int,TL::Int)
	nb = size(C,1)
	n = 1
	sol = echangeprofond3(nouV,nouC,copy(C),gloutonVxV2(C, nouV, nouC))
	solmax = copy(sol)
	init = copy(solmax)
	zmax = dot(C,solmax)
	zsol = copy(zmax)
	TM = zeros(Int,nb)

	temps = time()


	while (time() < temps + timelim)
		nouvZ = 0
		nouI = -1
		for i in 1:nb
			if sol[i] == 0
				sol[i] = 1
				if nouvZ <= zsol + C[i] && admis(sol,nouV,nouC,i)
					nouvZ = zsol + C[i]
					nouI = i
				end
				sol[i] = 0
			else
				sol[i] = 0
				if nouvZ <= zsol - C[i]
					nouvZ = zsol - C[i]
					nouI = i
				end
				sol[i] = 1
			end
		end

		if sol[nouI] == 0
			sol[nouI] = 1
			zsol = nouvZ + C[nouI]
		else
			sol[nouI] = 0
			zsol = nouvZ - C[nouI]
		end

		if zmax < nouvZ
			solmax = copy(sol)
			zmax = nouvZ
		end

		TM[nouI] = n + TL
		n = n + 1
	end
	return init,solmax,zmax
end


