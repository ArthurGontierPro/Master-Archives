using JuMP, GLPKMathProgInterface

#include("structure.jl") -> Il faut lancer une seule fois structure.jl avant !
include("data.jl")
include("LPP.jl")
include("BBAH.jl")
include("BBC.jl")
include("MPC.jl")

function affichage(Z,sol,kv,freqmax,nbrame)
	println(" Coup minimum : ",round(Z,digits = 5))
	println("Lignes choisies")
	sol = map(x -> round(x,digits = 5),sol)
	i = findall(x -> x == 1,sol)
	for j in 1:size(i,1)
		l = div(i[j]-1,freqmax*nbrame)
		f = div(i[j]-1-l*freqmax*nbrame,nbrame)
		c = i[j]-1-l*freqmax*nbrame -f*nbrame
		println("X",i[j]," : ","l=",l+1," f=",f+1," c=",c+1," cout ",kv[i[j]])
	end
end

function main(num::Int64,versionV=1,versionN=1,p=5,comparaison=false,station=false)
	if !station
		println("Prétraitement")
		Ce,kv,Aspp,Af,Ac,Fe = pretraitement(OD, Fee, nbrame, freqmax, caprame, coutFixe, coutDist, d, Ligne)
		println("Prétraitement fait !")
		println()
		println("modèle MIP")
		m = LPP_MIP(GLPKSolverMIP(),kv,Aspp,Ac,Af,Fe,Ce)

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
				println("X",i[j]," : ","l=",l+1," f=",f+1," c=",c+1," cout ",kv[i[j]])
			end
			solMIP = getvalue(m[:x])
			zprimal = getobjectivevalue(m)
		else
			println("Encore quelques corrections à faire ...")
		end

		println("Pour indication, temps du LP sur une résolution : ")
		mm = LPP_LP(GLPKSolverLP(),kv,Aspp,Ac,Af,Fe,Ce)
		@time solve(mm)
		println()

		if num == 1 
			if versionV == 1 && versionN == 1
				println()
				println("Branch and Bound")
				println("Choix de la variable la plus proche d'un entier")
				println("Choix du noeud avec le modèle ayant la meilleure solution")
				Z,sol = @time BBAH(kv,Aspp,Ac,Af,Fe,Ce,0,1,comparaison,zprimal,solMIP)
				affichage(Z,sol,kv,freqmax,nbrame)
				println()
			elseif  versionV == 2 && versionN == 1
				println()
				println("Branch and Bound")
				println("Choix de la première variable qui n'est pas entière")
				println("Choix du noeud avec le modèle ayant la meilleure solution")
				Z,sol = @time BBAH(kv,Aspp,Ac,Af,Fe,Ce,0,2,comparaison,zprimal,solMIP)
				affichage(Z,sol,kv,freqmax,nbrame)
				println()
			elseif  versionV == 1 && versionN == 2
				println()
				println("Branch and Bound")
				println("Choix de la variable la plus proche d'un entier")
				println("Choix du noeud en comparant avec le modèle ayant la meilleure solution et la solution du noeud actuel pour profiter du hot start")
				Z,sol = @time BBAH(kv,Aspp,Ac,Af,Fe,Ce,p,1,comparaison,zprimal,solMIP)
				affichage(Z,sol,kv,freqmax,nbrame)
				println()
			elseif  versionV == 2 && versionN == 2
				println()
				println("Branch and Bound")
				println("Choix de la première variable qui n'est pas entière")
				println("Choix du noeud en comparant avec le modèle ayant la meilleure solution et la solution du noeud actuel pour profiter du hot start")
				Z,sol = @time BBAH(kv,Aspp,Ac,Af,Fe,Ce,p,2,comparaison,zprimal,solMIP)
				affichage(Z,sol,kv,freqmax,nbrame)
				println()
			else
				println("Vérifier les numéros des versions")
			end
		elseif num == 2
			if comparaison == true
				println()
				println("Branch and Bound simple: ")
				global primal
				global maxsol
				primal = zprimal
				maxsol = solMIP
				@time BBC(kv,Aspp,Ac,Af,Fe,Ce,Array{Int}(undef,10000),0)
				affichage(primal,maxsol,kv,freqmax,nbrame)
				println()
			else
				println()
				println("Branch and Bound simple: ")
				global primal
				global maxsol
				primal = Integer(maxintfloat())
				maxsol = Array{Float64}(undef,size(Af,2))
				@time BBC(kv,Aspp,Ac,Af,Fe,Ce,Array{Int}(undef,10000),0)
				affichage(primal,maxsol,kv,freqmax,nbrame)
				println()
			end
		else
			println("Erreur dans les choix")
		end
	else
		H,C,p,jmax = parser("chouchou.txt")
		m = MCP(GLPKSolverMIP(),H,C,jmax,p,H)
		status = @time solve(m)

		if status == :Optimal
			println("Problème Résolu !!!")
			println(getobjectivevalue(m)," Habitants desservis, soit : ",100*getobjectivevalue(m)/112575.0,"%")
			println("stations desservies : ",findall(x -> x==1.0,getvalue(m[:x])))
			
		else
			println("Encore du boulot : Va corriger !")
		end
	end
end
#main(1)
