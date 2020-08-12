
using PyPlot

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

function recuitgraphique(C::Vector{Int},nouC::Vector{Vector{Int}},nouV::Vector{Vector{Int}},timelim::Int, L::Int, Tzero::Float64, alpha::Float64)
	nb = size(C,1)
	sol = echangeprofond3(nouV,nouC,copy(C),gloutonVxV2(C, nouV, nouC))
	solmax = copy(sol)
	init = copy(solmax)
	zsol = dot(C,solmax)
	zmax = copy(zsol)

	TT = Tzero
	l = 1
	n = 1

	nbIter = timelim*1000
  	zrand = zeros(Int64,nbIter)
  	zcour = zeros(Int64,nbIter)
  	zbest = zeros(Int64,nbIter)


	while (n <= nbIter)
		solcur,zcur = randomSwap(copy(sol),nouC,nouV,copy(zsol),C)

		zrand[n] = zcur
		delta = zcur - zsol
		p = rand()

		if (delta >= 0) || ( p < exp( delta / TT))
		    sol = solcur
		    zsol = zcur
		    if zmax < zcur
		        solmax = solcur
		        zmax = zcur
		    end
		end
		zcour[n] = zsol
		zbest[n] = zmax
		if l == L
		    TT = alpha * TT
		    l = 1
		end
		l = l + 1
		n = n + 1
	end
	return init,solmax,zmax, zrand, zcour, zbest
end

function plotRunRecuit(iname,zinit, zls, zbest)
	figure("Recuit du $(iname) ",figsize=(6,6)) # Create a new figure
	title("SA-SPP | zrand/zcour/zBest | "iname)
	xlabel("Itérations")
	ylabel("valeurs de z(x)")
	ylim(minimum(zinit)-2, maximum(zbest)+2)

	nPoint = length(zinit)
	x=collect(1:nPoint)
	xticks([1,convert(Int64,ceil(nPoint/4)),convert(Int64,ceil(nPoint/2)), convert(Int64,ceil(nPoint/4*3)),nPoint])
	plot(x,zinit,ls="",marker=".",ms=2,color="red",label="toutes solutions random")
	plot(x,zls,ls="",marker="^",ms=2,color="blue",label="toutes solutions considérées")
	#vlines(x, zinit, zls, linewidth=0.5)
	plot(x,zbest, linewidth=2.0, color="green", label="meilleures solutions")
	legend(loc=4, fontsize ="small")
end







