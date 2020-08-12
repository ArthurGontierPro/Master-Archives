
using PyPlot

function reactiveGraspgraphique(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}},nalpha::Int,nbIter::Int,Valpha::Vector{Float64})
	m = size(Valpha,1)

	zconstruction = zeros(Int64,nbIter)
	zamelioration = zeros(Int64,nbIter)
	zbestt = zeros(Int64,nbIter)

	sol = zeros(Int,size(C,1))
	zavg = zeros(Float64,m)
	zbest,zworst = 0,realmax(Float64)
	q = zeros(Float64,m)
	p = 1/m*ones(Float64,m)
	pcum = zeros(Float64,m)
	nba = zeros(Int,m)
	it = 1
	while it <= nbIter
		s2 = 0
		for k in 1:m
			s2 = s2 + p[k]
			pcum[k] = s2
		end
		for i in 1:nalpha
			beta = rand(Float64)
			ialpha = find(x->x>beta,pcum)[1]		  
			gl = gloutonrandom(C, nouV, nouC, Valpha[ialpha])
			zconstruction[it] = dot(gl,C)
			recette = echangeprofond3(nouV,nouC,copy(C),copy(gl))
			z = dot(recette,C)
			zamelioration[it] = z
			if it>1
				zbestt[it] = zbestt[it-1]
			end
			if z >= zbest
				#println("best : ",zbest)
				sol = recette
				zbest = z
				zbestt[it] = z
			end
			if z <= zworst
				#println("worst : ",zworst)
				zworst = z
			end
			zavg[ialpha] = (nba[ialpha] * zavg[ialpha] + z)/(nba[ialpha] + 1)
			nba[ialpha] = nba[ialpha] + 1
			it = it+1
		end
		for k in 1:m
			q[k] = (zavg[k] - zworst)/(zbest - zworst)
		end
		s = sum(q)
		p = q/s
	end

	return zconstruction, zamelioration, zbestt, p, zbest
end


# --------------------------------------------------------------------------- #
# Perform a numerical experiment (with a fake version of GRASP-SPP)

function plotRunGrasp(iname,zinit, zls, zbest)
	figure("Examen du $(iname) run",figsize=(6,6)) # Create a new figure
	title("GRASP-SPP | zConst/zLS/zBest | "iname)
	xlabel("Itérations")
	ylabel("valeurs de z(x)")
	ylim(minimum(zinit)-2, maximum(zbest)+2)

	nPoint = length(zinit)
	x=collect(1:nPoint)
	xticks([1,convert(Int64,ceil(nPoint/4)),convert(Int64,ceil(nPoint/2)), convert(Int64,ceil(nPoint/4*3)),nPoint])
	plot(x,zbest, linewidth=2.0, color="green", label="meilleures solutions")
	plot(x,zls,ls="",marker="^",ms=2,color="green",label="toutes solutions améliorées")
	plot(x,zinit,ls="",marker=".",ms=2,color="red",label="toutes solutions construites")
	vlines(x, zinit, zls, linewidth=0.5)
	legend(loc=4, fontsize ="small")
end

function plotpalpha(Valpha,palpha)
	figure("Alphas de la run",figsize=(6,6)) # Create a new figure
	title("alphas")
	xlabel("Alphas")
	ylabel("proba")
	ylim(0,0.5)

	plot(Valpha,palpha, linewidth=1.0, color="green", label="probas des alpha")

end

function plotAnalyseGrasp(iname, x, zmoy, zmin, zmax)
	figure("bilan tous runs",figsize=(6,6)) # Create a new figure
	title("GRASP-SPP | zMin/zMoy/zMax | "iname)
	xlabel("Itérations (pour nbRunGrasp)")
	ylabel("valeurs de z(x)")
	ylim(0, zmax[end]+2)

	nPoint = length(x)
	intervalle = [reshape(zmoy,(1,nPoint)) - reshape(zmin,(1,nPoint)) ; reshape(zmax,(1, nPoint))-reshape(zmoy,(1,nPoint))]
	xticks(x)
	errorbar(x,zmoy,intervalle,lw=1, color="black", label="zMin zMax")
	plot(x,zmoy,linestyle="-", marker="o", ms=4, color="green", label="zMoy")
	legend(loc=4, fontsize ="small")
end

function plotCPUt(allfinstance, tmoy)
	figure("bilan CPUt tous runs",figsize=(6,6)) # Create a new figure
	title("GRASP-SPP | tMoy")
	ylabel("CPUt moyen (s)")

	xticks(collect(1:length(allfinstance)), allfinstance, rotation=60, ha="right")
	margins(0.15)
	subplots_adjust(bottom=0.15,left=0.21)
	plot(collect(1:length(allfinstance)),tmoy,linestyle="--", lw=0.5, marker="o", ms=4, color="blue", label="tMoy")
	legend(loc=4, fontsize ="small")
end


fnames = [["pb_1000rnd0300.dat", 661],["pb_1000rnd0700.dat", 2260],["pb_100rnd0500.dat", 639],
	["pb_2000rnd0700.dat", 1811],["pb_200rnd0100.dat", 416],["pb_200rnd0300.dat", 731],
	["pb_200rnd0700.dat", 1004],["pb_200rnd0900.dat", 1324],["pb_500rnd0700.dat",1141],
	["pb_500rnd0900.dat", 2236]]



#=fnames      =  [["pb_100rnd0100.dat", 372],["pb_100rnd0200.dat", 34],["pb_100rnd0300.dat", 203],
		["pb_100rnd0400.dat", 16],["pb_100rnd0500.dat", 639],["pb_100rnd0600.dat", 64],
		["pb_100rnd0700.dat", 503],["pb_100rnd0800.dat", 39],["pb_100rnd0900.dat", 463],
		["pb_100rnd1000.dat", 40],["pb_100rnd1100.dat", 306],["pb_100rnd1200.dat", 23],
		["pb_200rnd0100.dat", 416],["pb_200rnd0200.dat", 32],["pb_200rnd0300.dat", 731],
		["pb_200rnd0400.dat", 64],["pb_200rnd0500.dat", 184],["pb_200rnd0600.dat", 14],
		["pb_200rnd0700.dat", 1004],["pb_200rnd0800.dat", 83],["pb_200rnd0900.dat", 1324],
		["pb_200rnd1000.dat", 118],["pb_200rnd1100.dat", 545],["pb_200rnd1200.dat", 43],
		["pb_200rnd1300.dat", 571],["pb_200rnd1400.dat", 45],["pb_200rnd1500.dat", 926],
		["pb_200rnd1600.dat", 79],["pb_200rnd1700.dat", 255],["pb_200rnd1800.dat", 19],
		["pb_500rnd0100.dat", 323],["pb_500rnd0200.dat", 25],["pb_500rnd0300.dat", 776],
		["pb_500rnd0400.dat", 62],["pb_500rnd0500.dat", 122],["pb_500rnd0600.dat", 8],
		["pb_500rnd0700.dat", 1141],["pb_500rnd0800.dat", 89],["pb_500rnd0900.dat", 2236],
		["pb_500rnd1000.dat", 179],["pb_500rnd1100.dat", 424],["pb_500rnd1200.dat", 33],
		["pb_500rnd1300.dat", 474],["pb_500rnd1400.dat", 38],["pb_500rnd1500.dat", 1196],
		["pb_500rnd1600.dat", 88],["pb_500rnd1700.dat", 192],["pb_500rnd1800.dat", 13],
		["pb_1000rnd0100.dat", 67],["pb_1000rnd0200.dat", 4],["pb_1000rnd0300.dat", 661],
		["pb_1000rnd0400.dat", 48],["pb_1000rnd0500.dat", 222],["pb_1000rnd0600.dat", 15],
		["pb_1000rnd0700.dat", 2260],["pb_1000rnd0800.dat", 175],["pb_2000rnd0100.dat", 40],
		["pb_2000rnd0200.dat", 2],["pb_2000rnd0300.dat", 478],["pb_2000rnd0400.dat", 32],
		["pb_2000rnd0500.dat", 140],["pb_2000rnd0600.dat", 9],["pb_2000rnd0700.dat", 1811],
		["pb_2000rnd0800.dat", 135]]=#

#=
function reactivegrasp_graphique(nalpha::Int,nbiter::Int,Valpha::Vector{Float64})

	for i in 1:size(fnames,1)
		name_file = string("data/",fnames[i][1])

		println("")
		println("  ",name_file)
		println("")

		C,A,nouillescontr,nouillesvar = loadSPP2(name_file)
			zinit,zls,zbest=reactiveGraspgraphique(copy(C),copy(nouillesvar),copy(nouillescontr),nalpha,nbiter,Valpha)
		plotRunGrasp(fnames[i][1], zinit, zls, zbest)
	end
end

reactivegrasp_graphique(10,30,[0.55,0.65,0.75,0.85,0.95])
=#

















