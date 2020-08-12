# Pour faire juste la phase 1 du simplex classique, on donne le PL mais on met des coeficients nulls sur la fonction objectif
function p11(solverSelected, A::Array{Int,2}, b::Vector{Int}, eq::Vector{Int})
	m = Model(with_optimizer(solverSelected, OutputFlag=0,GUROBI_ENV))
	
	@variable(m,x[1:nbvar] >= 0)

	@objective(m,Min,sum(x[i]*0 for i in 1:nbvar))

	for ictr in 1:nbctr
		if eq[ictr] == 1
			@constraint(m, sum(x[ivar]*A[ictr,ivar] for ivar in 1:nbvar) <= b[ictr])
		elseif eq[ictr] == -1
			@constraint(m, sum(x[ivar]*A[ictr,ivar] for ivar in 1:nbvar) >= b[ictr])
		else
			@constraint(m, sum(x[ivar]*A[ictr,ivar] for ivar in 1:nbvar) == b[ictr])
		end
	end
	return m
end


# résolution de la phase1 du simplex classique
function p1(C,A,b,eq,solver)

	m = p11(solver,A,b,eq)

	optimize!(m)#, suppress_warnings = true)

	if termination_status(m) == MOI.OPTIMAL
		x = value.(m[:x])
		ineq = findall(isodd,eq)
		x0 = vcat(x,-A[ineq,:]*x + b[ineq])
	else
		x0 = "the MOLP is infeasible"
	end
	return x0
end


