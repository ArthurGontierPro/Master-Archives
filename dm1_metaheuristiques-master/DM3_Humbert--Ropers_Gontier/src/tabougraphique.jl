
using PyPlot

function tabougraphique(C::Vector{Int},nouC::Vector{Vector{Int}},nouV::Vector{Vector{Int}},timelim::Int,TL::Int)
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
	n = 1
	nbIter = timelim*50
  	zcour = zeros(Int64,nbIter)
  	zbest = zeros(Int64,nbIter)

	while (n <= nbIter)
		sol,t1,t2 = echangeprofondtabou(nouV,nouC,copy(C),sol,TM)

		zsol = dot(C,sol)
		zcour[n] = copy(zsol)
		if zmax < zsol
			solmax = copy(sol)
			zmax = copy(zsol)
		end
		zbest[n] = copy(zmax)
		
		TM[nt][1] = t1
		TM[nt][2] = t2
		if nt < TL
			nt = nt + 1
		else
			nt = 1
		end
		n = n + 1
		#println(TM)
	end
	return zcour, zbest , init,zmax
end


# --------------------------------------------------------------------------- #
# Perform a numerical experiment (with a fake version of GRASP-SPP)

function plotRunTabou(iname,zcour, zbest)
	figure("Examen du $(iname) run",figsize=(6,6)) # Create a new figure
	title("TS-SPP | zCour/zBest | "iname)
	xlabel("Itérations")
	ylabel("valeurs de z(x)")
	ylim(minimum(zcour)-2, maximum(zbest)+2)

	nPoint = length(zcour)
	x=collect(1:nPoint)
	xticks([1,convert(Int64,ceil(nPoint/4)),convert(Int64,ceil(nPoint/2)), convert(Int64,ceil(nPoint/4*3)),nPoint])
	plot(x,zbest, linewidth=2.0, color="green", label="meilleures solutions")
	plot(x,zcour,ls="",marker="^",ms=2,color="red",label="solutions courantes")
	legend(loc=4, fontsize ="small")
end







