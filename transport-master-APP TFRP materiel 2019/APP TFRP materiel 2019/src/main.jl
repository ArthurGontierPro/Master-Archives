# Please write here the path to the "APP TFRP materiel 2019" directory.
#PATH = "/comptes/E187113J/Transport/APP TFRP materiel 2019/"
#PATH = "/Users/xavier/Documents/Scolarite/M2_Informatique_ORO/1er_semestre/Transport_et_logistique/APP TFRP materiel 2019/"
#PATH = "/home/sanjy/Desktop/TRAVAIL/M2/TransportLogistique/APP TFRP materiel 2019/"
PATH = "/home/arthur/Bureau/arthur/m2ag/transport/transport/APP TFRP materiel 2019/"

# Then run (copy and paste) the whole file in a Julia 1.2 terminal.
# Expected run time on an average machine : 30 min.

#cd(PATH) # Changing the Julia terminal directory

# PARSE iNstance, parameters and distanceMatrix
const INSTDIR = PATH*"instances2019/"
const OUTDIR = PATH*"res/"
const instNames = ["C1-2-8.txt","C2-2-8.txt","C1-3-10.txt","C1-3-12.txt","C2-3-10.txt","C2-3-12.txt",
	  "R1-2-8.txt","R2-2-8.txt","R1-3-10.txt","R1-3-12.txt","R2-3-10.txt","R2-3-12.txt"]
const paramf = string(INSTDIR,"parameters.txt")
const matf =string(INSTDIR,"distancematrix98.txt")
const RANGE_INSTANCE = 1:size(instNames,1)
#const RANGE_INSTANCE = 1:2

# Let's include all the required libraries
try
	using Gurobi
catch
	using Pkg
	Pkg.add("Gurobi")
	Pkg.build("Gurobi")
	using Gurobi
end
try
	using Cbc
catch
	using Pkg
	Pkg.add("Cbc")
	using Cbc
end
try
	using JuMP
catch
	using Pkg
	Pkg.add("JuMP")
	using JuMP
end
try
	using JSON
catch
	using Pkg
	Pkg.add("JSON")
	using JSON
end
try
	using LinearAlgebra
catch
	using Pkg
	Pkg.add("LinearAlgebra")
	using LinearAlgebra
end
try
	using Statistics
catch
	using Pkg
	Pkg.add("Statistics")
	using Statistics
end
try
	using PyPlot
catch
	using Pkg
	Pkg.add("PyPlot")
	using PyPlot
end
try
	using LightGraphs
catch
	using Pkg
	Pkg.add("LightGraphs")
	using LightGraphs
end
try
	using DataFrames
catch
	using Pkg
	Pkg.add("DataFrames")
	using DataFrames
end
try
	using CSV
catch
	using Pkg
	Pkg.add("CSV")
	using CSV
end

include(PATH*"src/instance.jl")

function printarc(x)
	for i in 1:size(x,1)
		for j in 1:size(x,2)
			if x[i,j]==1 println("	",i,"-",j) end
		end
	end
end

# Solve the truc and freighter problem
function solveTnF(inst::Instance; param::Vector = [2, 400, 7200, 300], inegv = false, testparam=false, gurobi = true)
	model = gurobi ? Model(with_optimizer(Gurobi.Optimizer, OutputFlag=0)) :  Model(with_optimizer(Cbc.Optimizer, logLevel=1))

	VO = union(inst.D[1],inst.P,inst.S,inst.LS,inst.D[2]) # Tous les sommets
	V = union(inst.P,inst.S,inst.LS) # Clients + parkings

	P = inst.P
	J = union(inst.S,inst.LS)
	JS= inst.LS
	VBO= union(inst.D[1],inst.P,inst.S,inst.D[2])
	VB=union(inst.P,inst.S)
	D = inst.D
	println("V= ", V) #LAS
	println("P= ", P) #LAS
	println("J= ", J) #LAS
	println("JS= ", JS) #LAS
	println("VB= ", VB) #LAS
	println("D= ", D) #LAS

	n = inst.D[2]-1

	t = zeros(Float64,n+1,n+1)
	for i in VO
		for j in VO
			t[i,j]=getDistance(inst,i,j)
		end
	end

	#parametres à faire varier
	if testparam
		Q = param[2] #400
		alpha = param[1]
		delta = param[4]
		s = param[3]
	else
		Q = inst.SV_cap #400
		alpha = inst.speed_ratio
		delta = inst.tw_width #7200
		s = inst.service_duration #300
	end
	T = inst.time_horizon
	M = 100000
	q = [inst.nodes[j].demand for j in VO];println(q)
	a = [inst.nodes[j].TW_min for j in VO]
	b = [inst.nodes[j].TW_max for j in VO]

	if inegv
		JB = inst.S
		temps = copy(t[VO,VO])
		for i in VO
			for j in VO
				if j in JS
					if i in J
						temps[i,j] = s+alpha*temps[i,j]
					else
						temps[i,j] = alpha*temps[i,j]
					end
				elseif i in JS
					temps[i,j] = s+alpha*temps[i,j]
				elseif i in JB
					temps[i,j] = s+min(1,alpha)*temps[i,j]
				else
					temps[i,j] = min(1,alpha)*temps[i,j]
				end
			end
		end

		g = SimpleDiGraph(temps)
		infU = bellman_ford_shortest_paths(g, 1, temps).dists
		supU = fill(T,length(VO)) - bellman_ford_shortest_paths(reverse(g), length(VO), transpose(temps)).dists

		for i in VO
			if 0 > infU[i] || 0 > supU[i]
				println("L'instance n'est pas satisfiable pour le client ", i)
			end
		end
	end

	#Variables
	@variable(model,xB[1:n+1,1:n+1], binary = true) #Gros véhicule
	@variable(model,xS[1:n+1,1:n+1], binary = true) #petit véhicule
	@variable(model,xBS[1:n+1,1:n+1], binary = true) #petit dans gros
	@variable(model,u[1:n+1] >= 0) #temps sortie d'un point sauf arrive dépot
	@variable(model,h[1:n+1] >= 0) #capacité petit véhicule

	#contraintes de flots B,S,BS
	@constraint(model, flotB[j=VB], sum(xB[i,j] for i in VBO)==sum(xB[j,i] for i in VBO))
	@constraint(model, flotS[j=J], sum(xS[i,j] for i in VO) == sum(xS[j,i] for i in VO))
	@constraint(model, flotBS[j=V],  sum(xS[i,j] + xBS[i,j] for i in VO) == sum(xS[j,i] + xBS[j,i] for i in VO))
	@constraint(model, BSImpS[i=VO,j=VO], xB[i,j] >= xBS[i,j] )
	@constraint(model, BSImpnS[i=VO,j=VO], 1-xS[i,j] >= xBS[i,j])

	#contraintes de demandes et départs (aussi flots particuliers)
	@constraint(model, demand[j=J], sum(xB[i,j] + xS[i,j] for i in VO) == 1 )
	@constraint(model, sum(xBS[1,i] for i in VB) == 1) #B Part du Depot en transportant S
	@constraint(model, sum(xB[i,n+1] for i in VB) == 1) #B arrive au Depot
	@constraint(model, sum(xS[i,n+1] + xBS[i,n+1] for i in V) ==1) #S arrive Depot dans Big ou tout seul
	@constraint(model, sum(xB[i,1] + xS[i,1] + xBS[i,1] for i in V) == 0) #pas de retour au dépot 1
	@constraint(model, sum(xB[n+1,i] + xS[n+1,i] + xBS[n+1,i] for i in V) == 0) #pas de départ du dépot n+1
 	@constraint(model, xB[1,n+1] + xS[1,n+1] + xBS[1,n+1] + xB[n+1,1] + xS[n+1,1] + xBS[n+1,1] == 0) # pas le droit de boucler sur dépot
	@constraint(model, [i=V], xB[i,i] + xS[i,i] + xBS[i,i] == 0)
	@constraint(model, [i=VO,j=JS], xB[i,j] + xB[j,i] == 0)

	#contraintes de temps
	if inegv
		# Raffinement du big M
		@constraint(model,tempsS[i=VO,j=VO], u[j] >= u[i] + alpha*t[i,j] + s - supU[j]*(1-xS[i,j]))
		@constraint(model,tempsB[i=VO,j=VO], u[j] >= u[i] + t[i,j] + s - supU[j]*(1-xB[i,j]))

		#amelioration des contraintes de temps suivantes par les inegalites valides
		majU = min.(b,supU)
		minU = max.(a + fill(s,length(a)),infU)

		@constraint(model,windob[j=VO],u[j] <= majU[j])
		@constraint(model,windoa[j=VO],u[j] >= minU[j])

		nb_ameliorations = length(filter(j -> b[j] > supU[j], VO))
		nb_ameliorations += length(filter(j -> infU[j] > a[j]+s , VO))
		nb_ameliorations += 2*length(VO)
		println(nb_ameliorations, " contraintes améliorées par des inégalites valides")
	else
		@constraint(model,tempsS[i=VO,j=VO], u[j] >= u[i] + alpha*t[i,j] + s - M*(1-xS[i,j]))
		@constraint(model,tempsB[i=VO,j=VO], u[j] >= u[i] + t[i,j] + s - M*(1-xB[i,j]))
		@constraint(model,windob[j=VO],u[j] <= b[j])
		@constraint(model,windoa[j=VO],u[j] >= a[j]+s)
		@constraint(model, u[n+1] <= T )
		nb_ameliorations = 0
	end

	#contraintes de capacités
	@constraint(model,captpJ[i=VO,j=J], h[j] <= h[i] - q[j]/2*(2-sum(xB[i,j] for i in VBO)) + M*(1-xS[i,j]))
	@constraint(model,captoP[i=VO,j=P], h[j] <= Q*sum(xB[i,j] for i in VO) + h[i] + M*(1-xS[i,j]))
	@constraint(model, caph[j=VO], h[j] <= Q )

	# Minimize u_n+1 cost
	@objective(model, Min, sum(xB[i,j]*t[i,j]+xS[i,j]*alpha*t[i,j] for i in VO for j in VO))

	println("Commence la résolution ----------------------------------")
	tim1=time()
	JuMP.optimize!(model)
	tim2=time()-tim1
	println(termination_status(model))
	println("Résolution finie ----------------------------------------")

	if termination_status(model)!=MOI.OPTIMAL
		println("Probleme impossible")
	else
		obj_value = JuMP.objective_value.(model)
		xB_value = JuMP.value.(xB)
		xS_value = JuMP.value.(xS)
		xBS_value = JuMP.value.(xBS)
		u_value = JuMP.value.(u)
		h_value = JuMP.value.(h) #cohérent?

		println("Coût de la tournée: ", obj_value, "\n")
		println("Temps maximum : ", T, "\n")
		println("xB_value ");printarc(xB_value)#, xB_value, "\n")
		println("xS_value ");printarc(xS_value)#, xS_value, "\n")
		println("xBS_value ");printarc(xBS_value)#, xBS_value, "\n")
		println("u_value \n	", u_value, "\n")
		println("h_value \n	", h_value,"\n")
	end
	return model, tim2, nb_ameliorations
end

# Fonction qui sert à ecrire proprement la solution d'une instance dans une ligne d'un tableau LaTeX
# @param f : fichier courant.
# @param i : numero de l'instance courrante.
# @param m : model JuMP courant.
# @param tim : temps de resolution de l'instance.
function printf(f,i,m,tim)
	if termination_status(m)!=MOI.OPTIMAL
		write(f,string(i," & NAN & ",tim," \\\\ \n \\hline\n"))
	else
		write(f,string(i," & ",objective_value.(m)," & ",tim," \\\\ \n \\hline\n"))
	end
end

# Fonction qui sert à écrire proprement la solution d'une instance dans une ligne d'un tableau LaTeX, pour les inégalités valides.
# @param f : fichier courant.
# @param i : numero de l'instance courrante.
# @param m : model JuMP courant.
# @param tim : temps de résolution de l'instance.
# @param nbam : nombre de contraintes ameliorées par des inégalités valides.
function printf2(f,i,m,tim,nbam)
	if termination_status(m)!=MOI.OPTIMAL
		write(f,string(i," & NAN & ",tim, " & ", nbam," \\\\ \n \\hline\n"))
	else
		write(f,string(i," & ",objective_value.(m)," & ",tim, " & ", nbam," \\\\ \n \\hline\n"))
	end
end

# Fonction qui remplace les espaces par de _ dans un string. Pour faciliter la rédaction du pdf.
# @param str::String : le string dont il faut retirer les espaces
# @return String : le string avec _  à la place des espaces.
function supprspaces(str::String)
	str2 = ""
	for c in str
		str2 = string(str2, c == ' ' ? '_' : c)
	end
	return str2
end

# Fonction qui pour une matrice de caractéristiques trace tous les plots deux-à-deux de ces caractéristiques
# et les enregistre dans PATH/img/.
# @param stats::Array{Float64,2} : la matrice de caractéristiques.
# @param statsNames::Array{String,1} : le nom des caractéristiques (colonnes).
# @param suffixe::String : suffixe à ajouter à la fin du nom des fichiers créés.
function crossplot(stats::Array{Float64,2}, statsNames::Array{String,1}, suffixe::String = "")
	dossier = PATH*"img/"
	try
		mkdir(dossier)
	catch
		nothing
	finally
		clf()
		for i in 1:size(stats,2)
			for j in i+1:size(stats,2)
				scatter(stats[:,i], stats[:,j])
				xlabel(statsNames[i])
				ylabel(statsNames[j])
				pltTitle = string(statsNames[i], "   vs   ",statsNames[j])
				title(pltTitle)
				savefig(string(dossier,string(supprspaces(pltTitle), suffixe)))
				clf()
			end
		end
	end
	println("Les crossplots ont été enregitrés dans : ", PATH, "img/")
end

# Fonction qui sert à écrire proprement la solution d'une instance dans une ligne d'un tableau LaTeX, pour l'étude des paramètres.
# @param f : fichier courant.
# @param i : numero de l'instance courrante.
# @param m : model JuMP courant.
# @param tim : temps de résolution de l'instance.
# @param alpha : le alpha du modèle.
# @param Q : le Qdu modèle.
# @param s : le s du modèle.
# @param delta : le delta du modèle.
function printf3(f,i,m,tim,alpha,Q,s,delta)
	if termination_status(m)!=MOI.OPTIMAL
		write(f,string(i," & NAN & ",tim, " & ", alpha, " & ",Q, " & ",s, " & ",delta," \\\\ \n \\hline\n"))
	else
		write(f,string(i," & ",objective_value.(m)," & ",tim, " & ",alpha, " & ",Q, " & ",s, " & ",delta," \\\\ \n \\hline\n"))
	end
end

# Fonction qui fait l'étude de la variation des paramètres et enregistre ensuite les corssplots obtenus dans PATH/img/.
function varierParam(; gurobi = true, inegv = false)
	statsNames = ["objectif", "temps de calcul (s)", "alpha", "Q", "s", "delta", "nb ineg valides ameliorantes"]
	global instNames, OUTDIR, RANGE_INSTANCE
	alphas = [0.5, 1, 2, 3, 5]
	Qs = [200, 400, 600, 800]
	deltas = [3000, 5000, 7200, 10000, 14400]
	ss = [100, 200, 300, 400, 500]

	Qo = 400
	alphao = 2
	so = 300
	deltao = 7200

	params = [[alpha, Qo, so, deltao] for alpha in alphas]
	append!(params, [[alphao, Q, so, deltao] for Q in Qs])
	append!(params, [[alphao, Qo, s, deltao] for s in ss])
	append!(params, [[alphao, Qo, so, delta] for delta in deltas])

	temps_de_calcul_total = length(alphas) + length(Qs) + length(deltas) + length(ss)
	println("Commencement des expérimentations numériques.")
	println("Temps total estimé : ", temps_de_calcul_total, " min (sur la machine d'Arthur).")

	stats = Array{Float64,2}(undef, size(RANGE_INSTANCE,1)*temps_de_calcul_total,7)

	I = 0
println(params)
	for param in params
		open(string(OUTDIR, "res_var_alpha__alpha", param[1], "_Q", param[2], "_delta", param[3], "_s", param[4], ".tex"),"w") do f
			write(f,string("\\begin{tabular}{|c|c|c|c|c|c|c|c|}\n\\hline\n Numéro & Objectif & Temps (s) & alpha & Q & s & delta \\\\\n\\hline\n"))
			for i in RANGE_INSTANCE
				instf =string(INSTDIR,instNames[i])
				inst = parseInstance(paramf,instf,matf)
				m,tim, nbam=solveTnF(inst, param = param, gurobi = gurobi, inegv = inegv, testparam = true)
				printf3(f,i,m,tim, param[1], param[2], param[3], param[4])
				# Recueil des donnees pour l'etude des parametres des instances.
				if termination_status(m) == MOI.OPTIMAL
					stats[I + i,:] = [objective_value.(m), tim, param[1], param[2], param[3], param[4], nbam]
				else
					stats[I + i,:] = [NaN, tim, param[1], param[2], param[3], param[4], nbam]
				end
			end
			write(f,string("\\end{tabular}\n"))
			I += length(RANGE_INSTANCE)
		end
	end
	#return stats, statsNames
	crossplot(stats, statsNames, "_var")
end

try
	mkdir(OUTDIR)
catch
	nothing
end

function main(;inegv = false, testparam = false, gurobi = true)
	global RANGE_INSTANCE, OUTDIR
	if !inegv && !testparam
		# Optimisation de toutes les instances
		open(string(OUTDIR,"res.tex"),"w") do f
			write(f,string("\\begin{tabular}{|c|c|c|}\n\\hline\n Numéro & Objectif & Temps (s) \\\\\n\\hline\n"))
			for i in RANGE_INSTANCE
				instf =string(INSTDIR,instNames[i])
				inst = parseInstance(paramf,instf,matf)
				m,tim, nbam =solveTnF(inst, gurobi = gurobi)
				printf(f,i,m,tim)
			end
			write(f,string("\\end{tabular}\n"))
		end
	elseif testparam
		# Étude de la variation des paramètres et enregistrement des corssplots obtenus dans PATH/img/.
		varierParam(gurobi = gurobi)

		println("C'est terminé, les résultats ont été sauvegardés dans les dossiers res/ et img/")

	else
		# Optimisation avec les inéglités valides de toute les instances et étude  statique des paramètres
		# Un tableau qui va stocker les caractéristiques des instances.
		stats = Array{Float64,2}(undef, (size(RANGE_INSTANCE,1),8))
		# Nom des caractérisitques correspondants aux colonnes de stats.
		statsNames = ["objectif", "temps de calcul (s)", "fenetre livraison moyenne", "nb clients", "nb clients gros vehicule", "nb clients petit vehicule", "nb parkings", "temps arc moyen"]

		open(string(OUTDIR, "res_inegv.tex"),"w") do f
			delta = 7200
			write(f,string("\\begin{tabular}{|c|c|c|c|}\n\\hline\n Numéro & Objectif & Temps & Nombre de contraintes amélioréees\\\\\n\\hline\n"))
			for i in RANGE_INSTANCE
				instf =string(INSTDIR,instNames[i])
				inst = parseInstance(paramf,instf,matf)
				m,tim, nbam=solveTnF(inst, inegv = true, gurobi = gurobi)
				printf2(f,i,m,tim, nbam)

				# Recueil des données pour l'étude des paramètres des instances.

				#global stats
				VO = union(inst.D[1],inst.P,inst.S,inst.LS,inst.D[2])
				a = [inst.nodes[j].TW_min for j in VO]
				b = [inst.nodes[j].TW_max for j in VO]
				JB = inst.S
				JS = inst.LS
				P = inst.P
				t = inst.dist_matrix
				T = 32400
				if termination_status(m)==MOI.OPTIMAL
					stats[i,:] = [objective_value.(m), tim, delta,  length(JB) + length(JS), length(JB), length(JS), length(P), mean(t[VO,VO])]
				else
					stats[i,:] = [NaN, tim,  delta,  length(JB) + length(JS), length(JB), length(JS), length(P), mean(t[VO,VO])]
				end
			end
			write(f,string("\\end{tabular}\n"))
		end
		# Tracer des crossplots de l'étude des paramétres statiques.
		crossplot(stats, statsNames)
	end
end

main(gurobi = true)
main(inegv = true, gurobi = true)
main(testparam = true, gurobi = true)
