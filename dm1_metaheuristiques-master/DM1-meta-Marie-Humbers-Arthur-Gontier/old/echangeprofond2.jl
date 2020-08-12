
#include("loadSPP2.jl")
#include("gloutonVxV.jl")

function admis(sol,nouV,nouC,i)
	flag = true
	ic = 1
	while ic <= size(nouV[i],1) && flag
		if sum(sol[nouC[nouV[i][ic]]]) > 1
			flag = false
		end
		ic = ic+1
	end
	return flag		
end


function exch2_1(nouV,nouC,C,sol,i,z)
	imax,kmax,kkmax = 0,0,0
	if sol[i] == 0
		nb = size(C,1)
		for kc in nouV[i]
		for kv in nouC[kc]
			if sol[kv] == 1 && i!=kv
				for kkc in nouV[i]
				for kkv in nouC[kc]
					if sol[kkv] == 1 && kv!=kkv && i!=kkv
						sol[i] = 1
						sol[kv] = 0
						sol[kkv] = 0
						zn = dot(C,sol)
						if admis(sol,nouV,nouC,i) && z < zn
							z = zn
							imax = i
							kmax = kv
							kkmax = kkv
						end
						sol[i] = 0
						sol[kv] = 1
						sol[kkv] = 1
					end
				end
				end
			end
		end
		end
	end
	if imax > 0
print("x")
		sol[imax] = 1
		sol[kmax] = 0
		sol[kkmax] = 0
	end
	return sol,z
end


function exch1_1(nouV,nouC,C,sol,i,z)
	imax,kmax = 0,0
	if sol[i] == 0
		nb = size(C,1)
		for kc in nouV[i]
		for kv in nouC[kc]
			if sol[kv] == 1 && i!=kv
				sol[i] = 1
				sol[kv] = 0
				zn = dot(C,sol)
				if admis(sol,nouV,nouC,i) && z < zn
					z = zn
					imax = i
					kmax = kv
				end 
					sol[i] = 0
					sol[kv] = 1
			end
		end
		end
	end
	if imax > 0
print("x")
		sol[imax] = 1
		sol[kmax] = 0
	end
	return sol,z
end


function exch0_1(nouV,nouC,C,sol,i)
	if sol[i] == 0
		sol[i] = 1
		if admis(sol,nouV,nouC,i)
print("x")
		else
			sol[i] = 0
		end
	end
	return sol
end


function echangeprofond2(nouV,nouC,C,sol)
	z = dot(C,sol)
	print("2-1 : ")
	for i in 1:size(C,1)
		sol,z = exch2_1(nouV,nouC,C,sol,i,z)
	end
	println("")
	print("1-1 : ")
	for i in 1:size(C,1)
		sol,z = exch1_1(nouV,nouC,C,sol,i,z)
	end
	println("")
	print("0-1 : ")
	for i in 1:size(C,1)
		sol = exch0_1(nouV,nouC,C,sol,i)
	end
	println("")
	return sol
end

