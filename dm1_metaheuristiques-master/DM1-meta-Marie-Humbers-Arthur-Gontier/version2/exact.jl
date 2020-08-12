# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface

include("loadSPP.jl")

# =========================================================================== #


#name_file = "data/test.dat"
#C,A = loadSPP(name_file)

function modelExacte(solverSelected, C::Vector{Int}, A::Array{Int,2})
	m = Model(solver = solverSelected)
	
	
	nb = size(C,1)
	nb_constr = size(A,1)
	
	#Déclaration des variables
	@variable(m,x[1:nb] >= 0,Bin)

	#Fonction objectif
	@objective(m,Max,sum(x[i]*C[i] for i in 1:nb))

	# Contraintes
	@constraint(m,Ingredients[icontr = 1:nb_constr], sum(x[ivars]*A[icontr,ivars] for ivars in 1:nb) <= 1)
	return m
end

#m = modelExacte(GLPKSolverMIP(),C,A)

#status = @time solve(m)

#if status == :Optimal
#	println("Problème Résolu !!!")
#	println("Z = ",getobjectivevalue(m))
#	println("X = ",getvalue(m[:x]))
#else
#	println("Encore du boulot : Va corriger !")
#end

