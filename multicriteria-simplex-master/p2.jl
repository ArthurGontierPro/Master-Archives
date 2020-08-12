
# PL dual qui, si il est optimal, nous donne les poids pour la première somme pondérée
function dualBenson(solverSelected, C::Vector{Float64}, A::Array{Int,2},nb::Int,nbw::Int,nbc::Int)
	md = Model(with_optimizer(solverSelected, OutputFlag=0,GUROBI_ENV))
	
	@variable(md,x[1:nb] >= 0)
	# les variables w qui nous donneront les poids de la première somme pondéré doivent être >1
	for i in (nb-nbw+1):nb
		JuMP.set_lower_bound(x[i],1)
	end
	@objective(md,Min,sum(x[i]*C[i] for i in 1:nb))
	@constraint(md,ctr[ictr = 1:nbc], sum(x[ivar]*A[ictr,ivar] for ivar in 1:nb) >= 0)
	return md
end

#PL ayant pour fonction objectif la somme pondéré (obtenue avec le dual de benson) pour avoir la première base
function resolB(solverSelected, C::Vector{Float64}, A::Array{Int,2}, b::Vector{Int}, eq::Vector{Int})
	mB = Model(with_optimizer(solverSelected, OutputFlag=0,GUROBI_ENV))
	
	@variable(mB,x[1:nbvar] >= 0)
 
	@objective(mB,Min,sum(x[i]*C[i] for i in 1:nbvar))

	@constraint(mB,lc[ictr = 1:nbctr; eq[ictr]==1],sum(x[ivar]*A[ictr,ivar] for ivar in 1:nbvar) <= b[ictr])
	@constraint(mB,uc[ictr = 1:nbctr; eq[ictr]==-1],sum(x[ivar]*A[ictr,ivar] for ivar in 1:nbvar) >= b[ictr])
	@constraint(mB,ec[ictr = 1:nbctr; eq[ictr]==0],sum(x[ivar]*A[ictr,ivar] for ivar in 1:nbvar) == b[ictr])
	return mB
end

function p2(C,A,b,eq,x0,solver)
	# Construction de la matrice du dual
	I,O = completion(eq)

	Ad = hcat((hcat(A,I))',(hcat(C,O))')
	Cd = vcat(b,(hcat(C,O))*x0) # ici on utilise la solution trouvée lors de la phase 1

	nb = size(Cd,1) # nb de variables duales
	nbw = length(Cd)-length(b) # nb de variables w qui seront les poids de la somme pondéré
	nbc = size(Ad,1) # nb de contraintes duales

	md = dualBenson(solver,Cd,Ad,nb,nbw,nbc)

	optimize!(md)#, suppress_warnings = true)

	if termination_status(md) == MOI.OPTIMAL
		# si le dual est optimal, on récupère les poids w
		sol = value.(md[:x])
		w = sol[(nb-nbw)+1:end]
		println("u = ",sol[1:nb-nbw]," w = ",w)

		# Somme pondérée des fonction objectifs
		Cw = (w'C)'

		# modélisation et résolution de la première somme pondérée
		mB =  resolB(solver,Cw,A,b,eq)	
		optimize!(mB)

		if termination_status(mB) == MOI.OPTIMAL

			sol1 = value.(mB[:x])
			ineq = findall(isodd,eq)
			neq = eq[ineq]#;println(neq)
	
			for i in 1:size(neq,1)#;println(i)
				if neq[i] == 1
					if MOI.BASIC == MOI.get(mB,MOI.ConstraintBasisStatus(),mB[:lc][i])
						neq[i] = 1
					else 
						neq[i] = 0
					end
				else
					if MOI.BASIC == MOI.get(mB,MOI.ConstraintBasisStatus(),mB[:uc][i])
						neq[i] = -1
					else 
						neq[i] = 0
					end
				end
			end
			#sol2 = b[ineq] - A[ineq,:]*sol1
			sol = vcat(sol1[1:nbvar],neq)
			B1 =  findall(x -> x != 0,sol)
		end
	else
		B1 = "Xe = ens vide"
	end
	return B1
end


