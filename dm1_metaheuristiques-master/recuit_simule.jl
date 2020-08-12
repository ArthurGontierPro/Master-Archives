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

function randomSwap(sol,nouC,nouV,z,C)
	nonadmis = true
	stop = 1
	rng = MersenneTwister(1234)
	while nonadmis && stop <= size(C,1)
		k = rand(find(!isodd, sol)) # 0
		l = rand(find(isodd, sol)) # 1
		r = rand(rng)
		if r < 0.1
			sol[k] = 1
			if admis(sol,nouV,nouC,k)
				nonadmis = false
				z = z + C[k]
			else
				sol[k] = 0
			end
		elseif r < 0.9
			sol[k] = 1
			sol[l] = 0
			if admis(sol,nouV,nouC,k)
				nonadmis = false
				z = z - C[l] + C[k]
			else
				sol[k] = 0
				sol[l] = 1
			end
		else
			nonadmis = false
			sol[l] = 0
			z = z - C[l]
		end
		stop = stop + 1
	end
	return sol,z
end


function recuit_simule(C::Vector{Int},nouC::Vector{Vector{Int}},nouV::Vector{Vector{Int}},timelim::Int, L::Int, Tzero::Float64, alpha::Float64)
	nb = size(C,1)
	sol = echangeprofond3(nouV,nouC,copy(C),gloutonVxV2(C, nouV, nouC))
	solmax = copy(sol)
	init = copy(solmax)
	zsol = dot(C,solmax)
	zmax = zsol

	    TT = Tzero
	    l = 1

	temps = time()
	while (time() < temps + timelim)
		# choix zcur et solcur 
		solcur,zcur = randomSwap(copy(sol), nouC, nouV, copy(zsol), C)

		delta = zcur - zsol
		p = rand()

		# boucle principale
		if (delta >= 0) || ( p < exp( delta / TT) )
		    sol = solcur
		    zsol = zcur 
		    if zmax < zcur  
		        solmax = solcur
		        zmax = zcur
		    end
		end

		# mise à jour de T
		if l == L
		    TT = alpha * TT
		    l = 1
		end
		l = l + 1
	end
	return init,solmax,zmax
end


