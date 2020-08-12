
function istabou(TM,TL,i)
	flag = false
	for k in 1:TL
		if i == TM[k][1] || i == TM[k][2]
			flag = true
		end
	end
	return flag
end

# Fonction vérifiant les contraintes
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

# 2-1 echange
function exch2_1t(nouV,nouC,C,sol,z,TM)
	imax,kmax,kkmax = 0,0,0
	for i in 1:size(C,1)
		if sol[i] == 0
			nb = size(C,1)
			for kc in nouV[i]
			for kv in nouC[kc]
				if sol[kv] == 1 && i!=kv && !istabou(TM,size(TM,1),kv)
					for kkc in nouV[i]
					for kkv in nouC[kc]
						if sol[kkv] == 1 && kv!=kkv && i!=kkv && !istabou(TM,size(TM,1),kkv)
							sol[i] = 1
							sol[kv] = 0
							sol[kkv] = 0
							if imax == 0
								zn = dot(C,sol)
							else
								zn = C[i] - C[kv] - C[kkv]
							end
							if admis(sol,nouV,nouC,i) && z <= zn
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
	end
	if imax > 0
#print("x")
		sol[imax] = 1
		sol[kmax] = 0
		sol[kkmax] = 0
	end
	return sol,z,imax
end

# 1-1 echange
function exch1_1t(nouV,nouC,C,sol,z,TM)
	imax,kmax = 0,0
	for i in 1:size(C,1)
		if sol[i] == 0
			nb = size(C,1)
			for kc in nouV[i]
			for kv in nouC[kc]
				if sol[kv] == 1 && i!=kv && !istabou(TM,size(TM,1),kv)
					sol[i] = 1
					sol[kv] = 0
					if imax == 0
						zn = dot(C,sol)
					else
						zn = z + C[i] - C[kv]
					end
					if admis(sol,nouV,nouC,i) && z <= zn
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
	end
	if imax > 0
#print("x")
		sol[imax] = 1
		sol[kmax] = 0
	end
	return sol,z,imax
end

# 0-1 echange
function exch0_1t(nouV,nouC,sol,i,TM)
	if sol[i] == 0
		sol[i] = 1
		if admis(sol,nouV,nouC,i)
#print("x")
		else
			sol[i] = 0
		end
	end
	return sol
end

# Fonction de plus profonde descente
function echangeprofondtabou(nouV,nouC,C,sol,TM)

	sol1,z1,t1 = exch2_1t(nouV,nouC,C,sol,0,TM)

	sol2,z2,t2 = exch1_1t(nouV,nouC,C,sol1,0,TM)

	pcontr = Vector{Int}(size(C))
	for iv in 1:size(C,1)
		pcontr[iv] = size(nouV[iv],1)
	end
	for i in 1:size(C,1)
		v = indmax(C./pcontr)
		sol = exch0_1t(nouV,nouC,sol2,v,TM)
		C[v] = 0
	end
	#println("")
	return sol,t1,t2
end

