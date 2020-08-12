

function reactiveGrasp(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}},nalpha::Int,timelim::Int,Valpha::Vector{Float64})
	m = size(Valpha,1)

	temps = time()
	sol = zeros(Int,size(C,1))
	zavg = zeros(Float64,m)
	zbest,zworst = 0,realmax(Float64)
	q = zeros(Float64,m)
	p = 1/m*ones(Float64,m)
	pcum = zeros(Float64,m)
	nba = zeros(Int,m)
	
	while (time() < temps + timelim)
		s2 = 0
		for k in 1:m
			s2 = s2 + p[k]
			pcum[k] = s2
		end
		pcum[m] = 1.0
		for i in 1:nalpha
			beta = rand(Float64)
			ialpha = find(x->x>=beta,pcum)[1]		  
			gl = gloutonrandom(C, nouV, nouC, Valpha[ialpha])
			recette = echangeprofond3(nouV,nouC,copy(C),copy(gl))
			z = dot(recette,C)
			if z >= zbest
				#println("best : ",zbest)
				sol = recette
				zbest = z
			end
			if z <= zworst
				#println("worst : ",zworst)
				zworst = z
			end
			zavg[ialpha] = (nba[ialpha] * zavg[ialpha] + z)/(nba[ialpha] + 1)
			nba[ialpha] = nba[ialpha] + 1
		end
		for k in 1:m
			q[k] = (zavg[k] - zworst)/(zbest - zworst)
		end
		s = sum(q)
		p = q/s
	end
	return [sol]#,zbest
end


















