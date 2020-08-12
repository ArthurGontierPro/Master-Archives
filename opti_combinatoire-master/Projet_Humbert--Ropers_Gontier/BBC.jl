using JuMP, GLPKMathProgInterface


function solEntiere(sol)
	i,entier = 1,true
	while i <= length(sol) && entier == true
		if sol[i] != floor(sol[i])
			entier = false
		end
		i = i + 1
	end
	return entier
end


function BBC(k,Aspp,Ac,Af,Fe,Ce,contr,n)#,s)
	m = LPP_LP(GLPKSolverLP(),k,Aspp,Ac,Af,Fe,Ce)#;println(s)
	x = m[:x]
	for i in 1:n
		@constraint(m, x[contr[2*i]] == contr[2*i+1])#;print("ctr:",contr[i])
	end
	status = solve(m, suppress_warnings = true)
	if status == :Optimal
		z = getobjectivevalue(m)
		sol = map(x -> round(x,digits = 5),getvalue(m[:x]))
		global primal
		if z < primal
			if solEntiere(sol)
				global maxsol
				primal = z
				maxsol = sol
			else
				i = findfirst(x -> (x>0 && x<1),sol)
				contr[2*n+2] = i
				contr[2*n+3] = 1
				BBC(k,Aspp,Ac,Af,Fe,Ce,contr,n+1)#,s*'a')
				global primal
				if z < primal
					contr[2*n+3] = 0
					BBC(k,Aspp,Ac,Af,Fe,Ce,contr,n+1)#,s*'b')
				end
			end
		end
	end
end

