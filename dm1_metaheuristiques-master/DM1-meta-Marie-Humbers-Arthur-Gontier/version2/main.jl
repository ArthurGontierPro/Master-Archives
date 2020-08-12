# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface

include("loadSPP.jl")
include("loadSPP2.jl")
include("gloutonVxV2.jl")
include("gloutonM.jl")
include("echangesVxV2.jl")
include("echangesVxV4.jl")
include("getfname.jl")
# =========================================================================== #

function ScriptSPP()


	target = "/home/marie/metaheuristiques/dm1_metaheuristiques/version2/data"
	fnames = getfname(target)

	for i in 1:size(fnames,1)
		name_file = fnames[i]
		C,A,nouC,nouV = loadSPP2(name_file)

		println("")
		println("  ",name_file)
		println("")

#=
		println("|----------SIMPLEX----------|")
		println("Résolution exacte : ")
		m = modelExacte(GLPKSolverMIP(),C,A)

		status = @time solve(m)

		if status == :Optimal
			println("Problème Résolu !!!")
			println(getobjectivevalue(m))
			println("X = ",getvalue(m[:x]))
		else
			println("Impossible ou non-borné")
		end
=#
		println("|----------GLOUTONS----------|")
		println("Solution gloutonne avec vecteur de vecteurs :")
		gl1 = @time gloutonVxV2(C,nouV,nouC)
		#println(gl1)
		println(" z = ",dot(gl1,C))

#=
		println("Solution gloutonne avec une matrice:")
		gl2 = @time gloutonM(C,A)
		#println(gl2)
		println(" z = ",dot(gl2,C))
=#


		println("|----------ECHANGES----------|")

		println("simpleDescente : Solution kp-echange avec vecteur de vecteurs :")
		gl1 = @time simpleDescente(C,nouV,nouC,gloutonVxV2(C,nouV,nouC))
		#println(gl1)
		println(" z = ",dot(gl1,C))


		println("profonde Descente : Solution kp-echange avec vecteur de vecteurs :")
		gl2,z = @time profondeDescente2(C,nouV,nouC,gloutonVxV2(C,nouV,nouC))
		#println(gl1)
		println(" z = ",z)

	end
end

ScriptSPP()

