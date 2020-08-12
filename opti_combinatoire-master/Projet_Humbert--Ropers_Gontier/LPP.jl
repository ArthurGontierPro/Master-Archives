
using JuMP, GLPKMathProgInterface


function coupe(s,ee,G,Ts)
	for i in 1:size(G,1)
		if i != ee && s in G[i]
			if G[i][1] == s
				k = 2
			else
				k = 1
			end
			push!(Ts,G[i][k])
			Ts = coupe(G[i][k],i,G,Ts)
		end
	end
	return Ts
end
		

function pretraitement(OD, Fee, nbrame, freqmax, caprame, coutFixe, coutDist, d, Ligne)
# prétraitement : hypothèse graphe arbre
	nbtriplet = freqmax * nbrame * size(Ligne,1)
	nbedge = size(G,1)
	nbligne = size(Ligne,1)

	Fe = fill(Fee,nbedge)

# Calcul de Ce
	Ce = Array{Int}(undef,nbedge)
	tmp = copy(OD)
	for ee in 1:nbedge
		sum = 0
		Ti = [G[ee][1]]
		Tj = [G[ee][2]]
		Ti = coupe(G[ee][1],ee,G,Ti)
		Tj = coupe(G[ee][2],ee,G,Tj)
#println(Ti,Tj)

		for i in Ti
			for j in Tj
				sum = sum + OD[i,j] + OD[j,i]
			end
		end
		Ce[ee] = Int(floor(sum/caprame))+1
	end

# Calcul des contraintes
	Af = zeros(Int, nbedge, nbtriplet)
	Ac = zeros(Int, nbedge, nbtriplet)
	Aspp = zeros(Int,nbligne, nbtriplet)
	k = zeros(Float64, nbtriplet)
	#println("k=",k);println("Af=",Af);println("Ac=",Ac);println("Aspp=",Aspp)
	for l in 1:nbligne
	        for ee in 1:nbedge
			if (G[ee][1] in Ligne[l]) && (G[ee][2] in Ligne[l])
				for f in 1:freqmax
					for c in 1:nbrame
	#println((l-1)*freqmax*nbrame+f*nbrame+c-2,"l=",l,"f=",f,"c=",c)
						ind = (l-1)*freqmax*nbrame+f*nbrame+c-2
						Af[ee,ind] = f
						Ac[ee,ind] = f*c
						Aspp[l,ind] = 1
						if k[ind] ==0
							if c==1
k[ind] = (ceil(2*(temps[l]+5)/120*f))*coutFixe + f*d[l]*coutDist
#println("k[",ind,"] = ",k[ind])
							else
k[ind] = (ceil(2*(temps[l]+5)/(120/f)))*coutFixe*1.05 + f*d[l]*coutDist-20
#println("k[",ind,"] = ",k[ind])
							end
						end
					end
				end
			end
		end
	end
	#println("k=",k);println("Af=",Af);println("Ac=",Ac);println("Aspp=",Aspp)
	#println("Fe=",Fe);println("Ce=",Ce)
	return Ce,k,Aspp,Af,Ac,Fe
end

#Ce,k,Aspp,Af,Ac,Fe = pretraitement(OD, Fee, nbrame, freqmax, caprame, coutFixe, coutDist, d, Ligne)

function LPP_MIP(solverSelected,k::Vector{Float64},Aspp::Array{Int,2},Ac::Array{Int,2},Af::Array{Int,2},Fe::Vector{Int},Ce::Vector{Int})
	m = Model(solver = solverSelected)
	nbedge = size(Af,1)
	nb = size(Af,2)
	nbligne = size(Aspp,1)

	@variable(m,x[1:nb] >= 0,Bin)

	@objective(m,Min,sum(k[i]*x[i] for i in 1:nb))

	@constraint(m,F[ee = 1:nbedge], sum(x[j]*Af[ee,j] for j in 1:nb) >= Fe[ee])
	@constraint(m,C[ee = 1:nbedge], sum(x[j]*Af[ee,j]*Ac[ee,j] for j in 1:nb) >= Ce[ee])
	@constraint(m,SPP[l= 1:nbligne], sum(x[j]*Aspp[l,j] for j in 1:nb) <= 1)
	return m
end

#=
println()
println("modèle MIP")
m = LPP_MIP(GLPKSolverMIP(),k,Aspp,Ac,Af,Fe,Ce)

status = @time solve(m)

if status == :Optimal
	println("Problème Résolu !!!")
	println(" Coup minimum : ",getobjectivevalue(m))
	println("Lignes choisies")
	i = findall(x -> x == 1,getvalue(m[:x]))
	for j in 1:size(i,1)
		l = div(i[j]-1,freqmax*nbrame)
		f = div(i[j]-1-l*freqmax*nbrame,nbrame)
		c = i[j]-1-l*freqmax*nbrame -f*nbrame
		println("X",i[j]," : ","l=",l+1," f=",f+1," c=",c+1," cout ",k[i[j]])
	end
	solMIP = getvalue(m[:x])
else
	println("ENcore quelques corrections à faire ...")
end
=#


function LPP_LP(solverSelected,k::Vector{Float64},Aspp::Array{Int,2},Ac::Array{Int,2},Af::Array{Int,2},Fe::Vector{Int},Ce::Vector{Int})
	m = Model(solver = solverSelected)
	nbedge = size(Af,1)
	nb = size(Af,2)
	nbligne = size(Aspp,1)
	@variable(m,x[1:nb] >= 0)

	@objective(m,Min,sum(k[i]*x[i] for i in 1:nb))

	@constraint(m,F[ee = 1:nbedge], sum(x[j]*Af[ee,j] for j in 1:nb) >= Fe[ee])
	@constraint(m,C[ee = 1:nbedge], sum(x[j]*Af[ee,j]*Ac[ee,j] for j in 1:nb) >= Ce[ee])
	@constraint(m,SPP[l= 1:nbligne], sum(x[j]*Aspp[l,j] for j in 1:nb) <= 1.0)
	return m
end


#=
println()
println("modèle LP")
mm = LPP_LP(GLPKSolverLP(),k,Aspp,Ac,Af,Fe,Ce)

status = @time solve(mm)

if status == :Optimal
	println("Problème Résolu !!!")
	println(" Coup minimum : ",getobjectivevalue(mm))
	println("Lignes choisies")
	i = findall(x -> x == 1,getvalue(mm[:x]))
	#i = [22, 47, 86, 106, 126, 171, 209]
	#println("sol prof z=",sum(k[[22 47 86 106 126 171 209]]))
	#println(k[i],"(nous) VS (prof)",k[[22 47 86 106 126 171 209]])
	for j in 1:size(i,1)
		l = div(i[j]-1,freqmax*nbrame)
		f = div(i[j]-1-l*freqmax*nbrame,nbrame)
		c = i[j]-1-l*freqmax*nbrame -f*nbrame
		println("X",i[j]," : ","l=",l+1," f=",f+1," c=",c+1," cout ",k[i[j]])
	end
	println(getvalue(mm[:x]))
else
	println("Encore du boulot : Va corriger !")
end
=#
