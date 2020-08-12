
# Problème auxiliaire qui, si il est non borné nous donne l'efficiency d'une variable entrante xj
# il résoud le PL min{ e'v : Ry - r^jd + Iv = 0,y,d,v <= 0 } où R est la matrice des coef des var hors base des fonctions objectifs
function pj(solverSelected, C::Vector{Float64}, A::Array{Float64,2},nb)
	maux = Model(with_optimizer(solverSelected, OutputFlag=0,GUROBI_ENV))
	
	@variable(maux,x[1:nb] >= 0)

	@objective(maux,Min,sum(x[i]*C[i] for i in 1:nb))
	@constraint(maux,ctr[ictr = 1:nbobj], sum(x[iv]*A[ictr,iv] for iv in 1:nb) <= 0)
	return maux
end

# fonction qui test si la base B est dans la liste de bases L
function isin(L,B,t0)
	isinlist = false
	for i in t0:length(L)
		isinbase = true
		for j in 1:length(B)
			isinbase = isinbase && (B[j] in L[i])
		end
		isinlist = isinlist || isinbase
	end
	return isinlist
end


function p3(solver,C,A,b,B1,verbose)
	singular = 0
	# construction de la liste de bases et la liste de solutions
	LB = [B1]
	Lx = []
	Lt = [1] #liste des sphères tabou
	it = 1 # indice de la sphère tabou

	cb = 1 # indice de la base courante
	# tant qu'il nous reste des bases dans la liste L à explorer faire
	while cb <= length(LB)
		B = LB[cb] # base courante
		N = [n for n in 1:(nbvar+nbneq) if !(n in B)] # N : variables hors base

		if verbose || true println("B = ",B) end

		AB = A[:,B] # matrice A sous la base B

		# décomposition LU
		F = lu(AB;check=false)
		#if !LinearAlgebra.issuccess(F) println(" ERREUR : SINGULAR MATRIX ");LB[cb]=[0] else 
		L,U = F.L,F.U

		# Calcul de R, matrice des coef des var en bases des fonctions objectifs 
		# le calcul est fait depuis les donnés du probleme avec la forme révisée + LU
		R = Matrix{Float64}(undef,nbobj,length(N))
		for k in 1:nbobj
			t = U'\C[k,B]
			y = L'\t
			R[k,:] = (C[k,N])' - y'*A[:,N]
		end
		#R = roundm(R);printm(R)
		#construction de la solution xb de la base B
		y = L\b
		xb = U\y
		push!(Lx,xb)

		# énumération des variables hors bases pour tester si elles sont efficientes
		for j in 1:length(N)
			if verbose print("    x",N[j],":") end

			# Modélisation et résolution du PL auxiliaire pour savoir si une var est intéressante
			rj = R[:,j]

			A3 = hcat(R,-rj)

			# la fonction objectif est la somme des colonnes de R-rj
			C3 = [sum(A3[:,o]) for o in 1:size(A3,2)] 

			maux = pj(solver,C3,A3,size(C3,1)) # ; println(maux)
			optimize!(maux)

			if termination_status(maux) != MOI.OPTIMAL
				if verbose println("Inefficient variable") end
			else
				# calcul de la colone de la variable entrante xj dans le tableau simplexe révisé
				y = L\A[:,N[j]]
				d = U\y

				# Identification de la variable sortante
				ratios = map(x -> if x<0 Inf else x end,(xb./d))
				s,si = findmin(ratios)

				if s == Inf || round(d[si],digits=12) == 0
					if s == Inf
						if verbose println("Rayon infini") end
					else
						if verbose println("Pivot impossible") end
					end
				else
					if verbose print("x",B[si]," ==> ") end
					# construcion de la nouvelle base Bj
					Bj = copy(B)
					Bj[si] = N[j]


					#t0 = if size(Lt,1)>2 Lt[end-1]+1 else 1 end
#if isin(LB,Bj,t0) != isin(LB,Bj,1) println(" ERREUR : PARCOURT : it =  ",it," Lt[end] = ",Lt[end]) end
					if isin(LB,Bj,1)
						if verbose println("Base déja vue") end
					else
						ABj = A[:,Bj]
						F = lu(ABj;check=false)
						if LinearAlgebra.issuccess(F)
							# ajout de la nouvelle base dans la liste
							push!(LB,Bj)
							if verbose println("Nouvelle base ") end
						else singular = singular + 1 end
					end
				end
			end
		end
		#end
		#mise a jour de la tabou sphère (on mémorise le nombre de bases découvertes sur la base B)
		#if it>=Lt[end]
		#	push!(Lt,size(LB,1))
		#else
		#	it = it + 1
		#end
		cb = cb + 1	
	end
	println("Singular matrices : ",singular)
	return LB,Lx
end


