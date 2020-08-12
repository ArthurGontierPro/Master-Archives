
#include("loadSPP2.jl")
#include("gloutonVxV.jl")

function testContr(nouC,sol)
	admis = true
	c = 1
	while admis == true && c <= size(nouC,1)
		sum = 0
		for i in nouC[c]
			sum = sum + sol[i]
			#println(c," ",i, " ",sol[i])
		end
		if sum > 1
			admis = false
		end
		#println(admis," ",c, " sum : ",sum)
		c = c + 1
	end
	return admis
end

function testObjectif(C,voisin,sol)
	return dot(C,voisin) > dot(C,sol)
end

function mergeVect(A,B)
	V = Vector{Int}(0)
	k,l = 1,1
	while k <= size(A,1) || l <= size(B,1) 
		if k <= size(A,1) && l <= size(B,1) 
			if A[k] < B[l] 
				push!(V,A[k])
				k = k + 1
			elseif A[k] == B[l] 
				push!(V,A[k])
				k = k + 1
				l = l + 1
			elseif A[k] > B[l]
				push!(V,B[l])
				l = l + 1
			end
		elseif l <= size(B,1) 
			push!(V,B[l])
			l = l + 1
		elseif k <= size(A,1) 
			push!(V,A[k])
			k = k + 1
		end
	end
	return V
end

function toutespres(A,B)
	# Si A incluse dans B
	bool = true
	l,k = 1,1
	if size(A,1) <= size(B,1)
		while k <= size(A,1) && bool
			if l >= size(B,1)
				bool = false
			elseif A[k] == B[l]
				k = k + 1
				l = l + 1
			elseif A[k] < B[l]
				bool = false
			elseif A[k] > B[l]
				l = l + 1
			end
		end
	else 
		bool = false
	end
	return bool
end

# Cela ne marche pas bien
function echangesVxV_Random(nouV,resteV1,resteV0,resteC0,sol)
	up = rand(1:size(resteV0,1))
	voisin = copy(sol)
	if size(resteV0,1) != 0
		voisin[resteV0[up]] = 1
		if toutespres(nouV[up],resteC0)
			sol = voisin
		elseif size(resteV1,1) != 0
			down = rand(1:size(resteV1,1))
			voisin[resteV1[down]] = 0
			r = mergeVect(resteC0,nouV[down])
			if toutespres(nouV[up],r)
				sol = voisin
			elseif size(resteV1,1) > 1
				down2 =rand(1:size(resteV1,1))
				while down == down2
					down2 =rand(1:size(resteV1,1))
				end
				voisin[resteV1[down2]] = 0
				r2 = mergeVect(r,nouV[down2])
				if toutespres(nouV[up],r2)
					sol = voisin
				end
			end
		end
	end
	return sol,resteV1,resteV0,resteC0
end


function recupV(sol)
	# Récupérer les variables à 1 et 0
	resteV1 = Vector{Int}(0)
	resteV0 = Vector{Int}(0)
	for i in 1:size(sol,1)
		if sol[i] == 1
			push!(resteV1,i)
		elseif sol[i] == 0
			push!(resteV0,i)
		end
	end
	return resteV1,resteV0
end 


function recupC0(nouC,resteV0)
	# Récupère les contraintes qui ne sont pas à l'égalité
	resteC0 = Vector{Int}(0)
	for i in 1:size(nouC,1)
		if toutespres(nouC[i],resteV0)
			push!(resteC0,i)
		end
	end
	return resteC0
end

function recherche(V::Vector{Float64},ind::Float64,res::Int)
	n = div(size(V,1),2)
	if ind > 0
		if size(V,1) == 1 && V[1] == ind
			trouve = 1 + res 
		elseif size(V,1) == 1 && V[1] != ind
			trouve = -1
		elseif V[n] == ind 
			trouve = n + res	
		elseif V[n] < ind
			trouve = recherche(V[(n+1):size(V,1)],ind,res+n)
		elseif V[n] > ind
			trouve = recherche(V[1:n],ind,res)  
		end
	else 
		trouve = -1
	end
	return trouve
end

function Benef(C,nouV,sol)
	V = zeros(Float64,size(C,1))
	for i in 1:size(C,1)
		if size(nouV[i],1) != 0
			V[i] = C[i] / sum(nouV[i])
		else 
			V[i] = realmax(Float16)
		end
	end	
	V = V.*sol
	#println(V)
	triV = sort!(copy(V),rev = true)
	#println(triV)
	k,prec = 1,-1
	Res = Vector{Int}(0)
	while k <= size(sol,1) && triV[k] != 0.0
		#println(k," ",prec," ",Res)
		n = find(x->x==triV[k],V)
		#println(n)
		#println(prec," ",triV[k])
		if prec != triV[k]
			for i in 1:size(n,1)
				prec = triV[k]
				push!(Res,n[i])
				k = k + 1
			end
		else 
			k = k + 1
		end
	end
	return Res
end

function Benef2(C,nouV,sol)
	V = zeros(Float64,size(C,1))
	for i in 1:size(C,1)
		

		V[i] = C[i] / sum(nouV[i])
	end	
	V = V.*sol
	#println(V)
	triV = sort!(copy(V),rev = true)
	#println(triV)
	k,prec = 1,-1
	Res = Vector{Int}(0)
	while k <= size(sol,1) && triV[k] != 0.0
		#println(k," ",prec," ",Res)
		n = find(x->x==triV[k],V)
		#println(n)
		#println(prec," ",triV[k])
		if prec != triV[k]
			for i in 1:size(n,1)
				prec = triV[k]
				push!(Res,n[i])
				k = k + 1
			end
		else 
			k = k + 1
		end
	end
	return Res
end


function contraire(sol)
	sol1 = copy(sol)
	for i in 1:size(sol,1)
		if sol1[i] == 0
			sol1[i] = 1
		elseif sol1[i] == 1
			sol1[i] = 0
		end
	end
	return sol1
end

function reverse(V)
	VV = Vector{Int}(0)
	for i in 1:size(V,1)
		push!(VV,V[size(V,1)-i+1])
	end
	return VV
end

# A finir!!
function echangesVxV_Tri1(C,nouV,nouC,sol)  #,resteV1,resteV0,resteC0
	# up random, choix smart down, élargissement du voisinage...
	# up = rand(1:size(resteV0,1))
	Kgoingdown = reverse(Benef(C,nouV,sol)) # Ceux à 1
	voisin = copy(sol)
	Pgoingup = Benef(C,nouV,contraire(sol)) # Ceux à 0
	println(Kgoingdown," ",Pgoingup)

	# Faire tous les 2-1 possibles 
	if size(Kgoingdown,1) >= 2
		for l in Pgoingup
			for i in Kgoingdown
				for k in Kgoingdown
					voisin = copy(sol)
					voisin[l] = 1
					voisin[i] = 0
					voisin[k] = 0
					if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
						sol = voisin
					end
					println(sol)
				end
			end
		end
	end

	# Faire tous les 1-1 possibles
	if size(Kgoingdown,1) >= 1
		for l in Pgoingup
			for i in Kgoingdown
				voisin = copy(sol)
				voisin[l] = 1
				voisin[i] = 0
				if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
					 sol = voisin
				end
			end
		end
	end

	# Faire tous les 0-1 possibles
	for l in Pgoingup
		voisin = copy(sol)
		voisin[l] = 1
		#println("sol ",sol)
		#println("voisin ",voisin)
		#println(testContr(nouC,voisin))
		if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
			#println(l)
			sol = voisin
		end
		#println(l," ",sol)
		#println("nouveau tour")
	end


# Possibilité 1 (x2 pour le voisinage ou deux voisinages -> 2-1 echange ?)
	# Si possible de faire 2-1 -> use triP + verif contraintes
	# Sinon, si possible de faire 1-1 -> use triP + verif contraintes
	# Sinon, faire 
	# Sinon, ressortir solution prec

	return sol
end


function echange2_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	ameliore = false
	#println("Kgoingdown ",Kgoingdown)
	#println("Pgoingup ",Pgoingup)
	l = 1
	while ameliore == false && l <= size(Pgoingup,1)
		i = 1
		while ameliore == false && i <= size(Kgoingdown,1)
			k = i + 1
			while ameliore == false && k <= size(Kgoingdown,1)
				#println("voisin  ",voisin)
				#println("i ",i,"j ",j,"k ",k)
				voisin = copy(sol)
				voisin[Pgoingup[l]] = 1
				voisin[Kgoingdown[i]] = 0
				voisin[Kgoingdown[k]] = 0
				if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
					ameliore = true
					sol = voisin
				end
				k = k + 1
			end
			i = i + 1
		end
		l = l + 1
	end
	return sol
end


function echange1_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	ameliore = false
	l = 1
	while ameliore == false && l <= size(Pgoingup,1)
		i = 1
		while ameliore == false && i <= size(Kgoingdown,1)
			voisin = copy(sol)
			voisin[Pgoingup[l]] = 1
			voisin[Kgoingdown[i]] = 0
			if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
				ameliore = true	
				sol = voisin
			end
			i = i + 1
		end
		l = l + 1
	end
	return sol
end


function echange0_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	ameliore = false
	l = 1
	while ameliore == false && l <= size(Pgoingup,1)
		voisin = copy(sol)
		voisin[Pgoingup[l]] = 1
		if testContr(nouC,voisin) && testObjectif(C,voisin,sol)
			sol = voisin
		end
		l = l + 1
	end
	return sol
end

function echangesVxV_Tri2(C,nouV,nouC,sol) 
	Kgoingdown = reverse(Benef(C,nouV,sol)) # Ceux à 1
	voisin = copy(sol)
	#println("Kgoingdown ",Kgoingdown)
	Pgoingup = Benef(C,nouV,contraire(sol)) # Ceux à 0
	#println("Tout ",Kgoingdown," ",Pgoingup)

	# Faire 2-1 échange
	if size(Kgoingdown,1) >= 2
		#println("2_1 echange")
		sol = echange2_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	# Faire 1-1 échange
	elseif size(Kgoingdown,1) >= 1
		#println("1_1 echange")
		sol = echange1_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	else
	# Faire 0-1 échange
		#println("0_1 echange")
		sol = echange0_1(C,nouV,nouC,sol,Kgoingdown,Pgoingup)
	end
	return sol
end

function simpleDescente(C,nouV,nouC,sol)
	# Simple Descente
	ameliore = true
	if !testContr(nouC,sol)
		ameliore = false
		println("Solution d'entrée invalide")
	end

	Pgoingup = Benef(C,nouV,contraire(sol))

	k = 1
	while size(nouV[Pgoingup[k]],1) == 0
		sol[Pgoingup[k]] = 1 
	end

	while ameliore == true
		voisin = echangesVxV_Tri2(C,nouV,nouC,sol)
		if dot(C,sol) >= dot(C,voisin)
			ameliore = false
		else 
			sol = voisin
		end
	end
	return sol
end

#=
name_file = "didactic.dat"
C,A,nouC,nouV = loadSPP2(name_file)

solInit = [0,1,0,1,0,0,0,0,0]
println("Solution kp-echange avec vecteur de vecteurs :")

# Tourner plus possible 2-1 puis 1-1 puis 0-1 et stop
gl1 = @time echangesVxV_Tri1(C,nouV,nouC,solInit) 
println(gl1)
println(" z = ",dot(gl1,C))
gl2 = @time simpleDescente(C,nouV,nouC,solInit)
println(gl2)
println(" z = ",dot(gl2,C))


=#
