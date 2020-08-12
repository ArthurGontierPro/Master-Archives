
function pj(solverSelected, C::Vector{Float64}, A::Array{Float64,2})
	m = Model(solver = solverSelected)
	
	nb = size(C,1)
	nbctr = size(A,1)
	
	@variable(m,x[1:nb] >= 0)

	@objective(m,Min,sum(x[i]*C[i] for i in 1:nb))
	@constraint(m,ctr[ictr = 1:nbctr], sum(x[iv]*A[ictr,iv] for iv in 1:nb) <= 0)
	return m
end

function isin(L,B)
	isinlist = false
	for i in 1:length(L)
		isinbase = true
		for j in 1:length(B)
			isinbase = isinbase && (B[j] in L[i])
		end
		isinlist = isinlist || isinbase
	end
	return isinlist
end

function printm(M)
	for i in 1:size(M,1)
		for j in 1:size(M,2)
			print("  ",M[i,j])
		end
		println("")
	end
end

function roundm(M)
	for i in 1:size(M,1)
		for j in 1:size(M,2)
			M[i,j] = round(M[i,j],digits=14)
		end
	end
	return M
end

function p3test(C,A,b,B1)
	LB = [B1]
	Lx = []

	nbv = size(A,2)
	nbc = size(A,1) 
	nbo = size(C,1)

	cb = 1 

	while cb <= length(LB)
		Bs = (LB[cb]) 
		#Bs = sort!(copy(B))
		N = [n for n in 1:nbv if !(n in Bs)]

		println("Bs= ",Bs)

		#AB = A[:,B]
		AB2 = A[:,Bs]

		if det(AB2) == 0
			println("Matrice singulière")
		else

		#L,U = lu(AB)
		AB1 = inv(AB2)

		#println("LU = AB ? ",L*U==AB[p,:],p)

		#R = Matrix{Float64}(undef,nbo,length(N))
		R2 = Matrix{Float64}(undef,nbo,length(N))
		for k in 1:nbo
		#	t = U'\C[k,B]
		#	y = L'\t
		#	R[k,:] = (C[k,N])' - y'*A[:,N]
			R2[k,:] = (C[k,N])' - (C[k,Bs])'*AB1*A[:,N]
		end

		#R = roundm(R)
		R2 = roundm(R2)
		#println("R :",R == R2)
		#if R != R2 
		#	println(" basic R : ");printm(R);println(" R test : ");printm(R2)
		#println("rounded R are the sames? :   ",R == R2)
		#end

		#y = L\b
		#xb = U\y
		xb2 = AB1*b
		#println("xb :",xb == xb2,xb,xb2)
		push!(Lx,xb2)

		for j in 1:length(N)
			print("    x",N[j],":")

			rj = R2[:,j]

			A3 = hcat(R2,-rj)

			C3 = [sum(A3[:,o]) for o in 1:size(A3,2)] 

			m = pj(GLPKSolverLP(),C3,A3)
			status = solve(m, suppress_warnings = true)

			if status != :Optimal
				println("Inefficient variable")
			else
				#y = L\A[:,N[j]]
				#d = U\y
				d2 = AB1*A[:,N[j]]
				#print(" d :",d==d2)

				ratios = map(x -> if x<0 Inf else x end,(xb2./d2))
				s,si = findmin(ratios)
print("||",s,d2[si],"||",xb2,d2,"||")
				if s == Inf || round(d2[si],digits=12) == 0
					if s == Inf
						println("Rayon infini")
					else
						println("Pivot impossible")
					end
				else
					print("x",Bs[si]," ==> ")
					Bj = copy(Bs)
					Bj[si] = N[j]

					if isin(LB,Bj)
						println("Base déja vue")
					else
						push!(LB,Bj)
						println("Nouvelle base ")
					end
				end
			end
		end
		end
		cb = cb + 1	
	end
	return LB,Lx
end

