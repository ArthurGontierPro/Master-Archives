# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface

include("loadSPP2.jl")
include("glouton.jl")
include("glouton2.jl")
include("gloutonM.jl")
include("gloutonM2.jl")
include("gloutonVxV2.jl")
include("exact.jl")
include("echangesimple.jl")
include("echangeprofond3.jl")
include("echangesVxV4.jl")
#include("setSPP.jl")
include("getfname.jl")
include("pretraitement.jl")
# =========================================================================== #

function ScriptSPP()

	target = "/home/arthur/Bureau/arthur/m1ag/heuristiques/DM1/DM1-meta-Marie-Humbers-Arthur-Gontier/data"
	#target = "/home/marie/metaheuristiques/dm1_metaheuristiques/data"
	fnames = getfname(target)

	for i in 1:size(fnames,1)
		name_file = fnames[i]
		C,A,nouillescontr,nouillesvar = loadSPP2(name_file)

		println("")
		println("  ",name_file)
		println("")


		println("|----------GLOUTONS----------|")
		println("Solution gloutonne :")
		gl1 = @time glouton(C,A)
		println(" z = ",dot(gl1,C))

		println("Solution gloutonne qui part d'un tri des poids :")
		gl2 = @time glouton2(C,A)
		println(" z = ",dot(gl2,C))

		println("Solution gloutonne à supression dans la matrice :")
		gl3 = @time gloutonM(C,A)
		println(" z = ",dot(gl3,C))

		println("Solution gloutonne à modification dans matrice :")
		gl4 = @time gloutonM2(C,A)
		println(" z = ",dot(gl4,C))

		println("Solution gloutonne à manipulation de vecteurs :")
		gl5 = @time gloutonVxV2(C,copy(nouillesvar),copy(nouillescontr))
		println(" z = ",dot(gl5,C))

		println("|----------ECHANGES----------|")
		curry = poulet(C,A) #calcul et tri des coup

		@time recette5 = echangesimple(curry,nouillesvar,nouillescontr,C,copy(gl1))
		println("simple descente depuis un glouton simple : ")
		println(" z = ",dot(recette5,C))

		@time recette3,z = profondeDescente2(C,nouillesvar,nouillescontr,copy(gl1))
		println("plus profonde descente depuis un glouton simple : ")
		println(" z = ",z)

		@time recette4,z2 = profondeDescente2(C,nouillesvar,nouillescontr,copy(gl5))
		println("plus profonde descente depuis un glouton à tri : ")
		println(" z = ",z2)

		@time recette7 = echangeprofond3(nouillesvar,nouillescontr,copy(C),copy(gl5))
		println("plus profonde descente économe depuis un glouton à tri : ")
		#println(recette6)
		println(" z = ",dot(recette7,C))

#=

		println("|----------SIMPLEX----------|")
		println("Résolution exacte : ")
		m = modelExacte(GLPKSolverMIP(tm_lim=1000),C,A)

		status = @time solve(m)

		if status == :Optimal
			println("Problème Résolu !!!")
			println(getobjectivevalue(m))
			#println("X = ",getvalue(m[:x]))
		else
			println("Résolution exacte trop lourde")
		end
=#
	end
end

ScriptSPP()


