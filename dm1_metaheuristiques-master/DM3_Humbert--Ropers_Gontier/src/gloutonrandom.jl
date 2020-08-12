# =========================================================================== #

# Glouton avec la matrice,ajoutant les premières variables possibles :: c pa vré

# =========================================================================== #

function gloutonrandom(C::Vector{Int}, nouV::Vector{Vector{Int}}, nouC::Vector{Vector{Int}},alpha::Float64)
    nb = size(C,1)
	sol = zeros(Int,nb)
    curry = Vector{Float64}(nb)
    for i in 1:nb
        if size(nouV[i],1) == 0
            curry[i] = realmax(Float64)
        else
            curry[i] = C[i]/size(nouV[i],1) 
        end
    end

    unused = []
    while nb > size(unused,1)
        limit = findmin(curry[find(x->x!=-1,curry)])[1] + alpha * (findmax(curry[find(x->x!=-1,curry)])[1] - findmin(curry[find(x->x!=-1,curry)])[1])
        RCL = find(x -> x >= limit, curry)
        i = rand(1:size(RCL,1))
        push!(unused,RCL[i])
        for iv in nouV[RCL[i]]
            unused = union(unused,nouC[iv])
        end
        curry[unused] = -1
        sol[RCL[i]] = 1
    end
	return sol
end

