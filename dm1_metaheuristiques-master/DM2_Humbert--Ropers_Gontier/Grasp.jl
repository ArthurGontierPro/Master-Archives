include("gloutonrandom.jl")
include("echangeprofond3.jl")


function Grasp(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}},alpha::Float64,timelim::Int)

    temps = time()
	sol = zeros(Int,size(C,1))
    zmax = 0
    while(time() < temps + timelim)
        #println("Solution gloutonne random :")
        gl = gloutonrandom(C, nouV, nouC, alpha)
        #println(" z = ",dot(gl,C))

	recette = echangeprofond3(nouV,nouC,copy(C),copy(gl))
	#println("plus profonde descente économe depuis un glouton à tri : ")
	#println(recette6)
        z = dot(recette,C)
	#println(" z = ",z)

        if z > zmax
            zmax = z
            sol = recette
        end
    end
    return sol,zmax
end
