

#include("loadSPP.jl")
#include("glouton.jl")
#include("glouton2.jl")
#include("exact.jl")
#include("tripif.jl")
#include("setSPP.jl")
#include("getfname.jl")
#include("pretraitement.jl")


function testadmismat(sol::Vector{Int},nouilles,i,A)
	admis = true
	for c in 1:size(nouilles[i],1)
		if dot(A[nouilles[i][c],:],sol) > 1
			admis = false
		end
	end
	return admis
end


function testplusdecurry(newsol::Vector{Int},sol::Vector{Int},C::Vector{Int})
	dif = dot(newsol,C) - dot(sol,C)
	return dif > 0
end

function exch2_1(curry,nouilles,C,sol,i,A)
	if sol[curry[i]] == 0
		for k in i+1:size(curry,1)-1
			if sol[curry[k]] == 1
				for kk in k+1:size(curry,1)
					if sol[curry[kk]] == 1
						newsol = copy(sol)#a simplifier pour rapidiser
						newsol[curry[i]] = 1
						newsol[curry[k]] = 0
						newsol[curry[kk]] = 0
						if testadmismat(newsol,nouilles,curry[i],A) && testplusdecurry(newsol,sol,C)
							sol = newsol
						end
					end
				end
			end
		end
	end
	return sol
end


function exch1_1(curry,nouilles,C,sol,i,A)
	if sol[curry[i]] == 0
		for k in i+1:size(curry,1)
			if sol[curry[k]] == 1 
				newsol = copy(sol)
				newsol[curry[i]] = 1
				newsol[curry[k]] = 0
				if testadmismat(newsol,nouilles,curry[i],A) && testplusdecurry(newsol,sol,C)
					sol = newsol
				end
			end
		end
	end
	return sol
end


function exch0_1(curry,nouilles,C,sol,i,A)
	if sol[curry[i]] == 0
		newsol = copy(sol)
		newsol[curry[i]] = 1
		if testadmismat(newsol,nouilles,curry[i],A)
			sol = newsol
		end
	end
	return sol
end


function echanges(curry,nouilles,C,sol,A)
	for i in 1:size(C,1)-2
		sol = exch2_1(curry,nouilles,C,sol,i,A)
	end
	for i in 1:size(C,1)-1
		sol = exch1_1(curry,nouilles,C,sol,i,A)
	end
	for i in 1:size(C,1)
		sol = exch0_1(curry,nouilles,C,sol,i,A)
	end
	return sol
end

