
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

function tabou3(C::Vector{Int},nouC::Vector{Vector{Int}},nouV::Vector{Vector{Int}},timelim::Int,TL::Int)
	nb = size(C,1)
	nt = 1
	sol = echangeprofond3(nouV,nouC,copy(C),gloutonVxV2(C, nouV, nouC))
	solmax = copy(sol)
	init = copy(solmax)
	zmax = dot(C,solmax)
	zsol = zmax

	TM = Vector{Vector{Int}}(TL)
	for i in 1:TL 
		TM[i] = [0,0]
	end

	temps = time()

	while (time() < temps + timelim)
		sol,t1,t2 = echangeprofondtabou(nouV,nouC,copy(C),sol,TM)

		zsol = dot(C,sol)
		if zmax < zsol
			solmax = copy(sol)
			zmax = zsol
		end

		TM[nt][1] = t1
		TM[nt][2] = t2
		if nt < TL
			nt = nt + 1
		else
			nt = 1
		end
		#println(TM)
	end
	

	return init,solmax,zmax
end


