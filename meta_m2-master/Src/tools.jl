# Chemin vers les instances.
path = "Data/Instances_"
# Types d'instance (Cf README)
ABX = ["Set_A/","Set_B/","set_X/"]
# Nom des instances du set A (CF README)
instances_A = [
"022_3_4_EP_RAF_ENP/","022_3_4_RAF_EP_ENP/","024_38_3_EP_ENP_RAF/","024_38_3_EP_RAF_ENP/",
"024_38_5_EP_ENP_RAF/","024_38_5_EP_RAF_ENP/","025_38_1_EP_ENP_RAF/","025_38_1_EP_RAF_ENP/",
"039_38_4_EP_RAF_ch1/","039_38_4_RAF_EP_ch1/","048_39_1_EP_ENP_RAF/","048_39_1_EP_RAF_ENP/",
"064_38_2_EP_RAF_ENP_ch1/","064_38_2_EP_RAF_ENP_ch2/","064_38_2_RAF_EP_ENP_ch1/","064_38_2_RAF_EP_ENP_ch2/"
]
# Nom des instances du set B (CF README)
instances_B = [
"022_EP_ENP_RAF_S22_J1/","022_EP_RAF_ENP_S22_J1/","022_RAF_EP_ENP_S22_J1/","023_EP_ENP_RAF_S23_J3/",
"023_EP_RAF_ENP_S23_J3/","023_RAF_EP_ENP_S23_J3/","024_V2_EP_ENP_RAF_S22_J1/","024_V2_EP_RAF_ENP_S22_J1/",
"024_V2_RAF_EP_ENP_S22_J1/","025_EP_ENP_RAF_S22_J3/","025_EP_RAF_ENP_S22_J3/","025_RAF_EP_ENP_S22_J3/",
"028_ch1_EP_ENP_RAF_S22_J2/","028_ch1_EP_RAF_ENP_S22_J2/","028_ch1_RAF_EP_ENP_S22_J2/","028_ch2_EP_ENP_RAF_S23_J3/",
"028_ch2_EP_RAF_ENP_S23_J3/","028_ch2_RAF_EP_ENP_S23_J3/","029_EP_ENP_RAF_S21_J6/","029_EP_RAF_ENP_S21_J6/",
"029_RAF_EP_ENP_S21_J6/","035_ch1_EP_ENP_RAF_S22_J3/","035_ch1_EP_RAF_ENP_S22_J3/","035_ch1_RAF_EP_ENP_S22_J3/",
"035_ch2_EP_ENP_RAF_S22_J3/","035_ch2_EP_RAF_ENP_S22_J3/","035_ch2_RAF_EP_ENP_S22_J3/","039_ch1_EP_ENP_RAF_S22_J4/",
"039_ch1_EP_RAF_ENP_S22_J4/","039_ch1_RAF_EP_ENP_S22_J4/","039_ch3_EP_ENP_RAF_S22_J4/","039_ch3_EP_RAF_ENP_S22_J4/",
"039_ch3_RAF_EP_ENP_S22_J4/","048_ch1_EP_ENP_RAF_S22_J3/","048_ch1_EP_RAF_ENP_S22_J3/","048_ch1_RAF_EP_ENP_S22_J3/",
"048_ch2_EP_ENP_RAF_S22_J3/","048_ch2_EP_RAF_ENP_S22_J3/","048_ch2_RAF_EP_ENP_S22_J3/","064_ch1_EP_ENP_RAF_S22_J3/",
"064_ch1_EP_RAF_ENP_S22_J3/","064_ch1_RAF_EP_ENP_S22_J3/","064_ch2_EP_ENP_RAF_S22_J4/","064_ch2_EP_RAF_ENP_S22_J4/",
"064_ch2_RAF_EP_ENP_S22_J4/"
]
# Nom des instances du set X (CF README)
instances_X = [
"022_RAF_EP_ENP_S49_J2/","023_EP_RAF_ENP_S49_J2/","024_EP_RAF_ENP_S49_J2/","025_EP_ENP_RAF_S49_J1/",
"028_CH1_EP_ENP_RAF_S50_J4/","028_CH2_EP_ENP_RAF_S51_J1/","029_EP_RAF_ENP_S49_J5/","034_VP_EP_RAF_ENP_S51_J1_J2_J3/",
"034_VU_EP_RAF_ENP_S51_J1_J2_J3/","035_CH1_RAF_EP_S50_J4/","035_CH2_RAF_EP_S50_J4/","039_CH1_EP_RAF_ENP_S49_J1/",    "039_CH3_EP_RAF_ENP_S49_J1/","048_CH1_EP_RAF_ENP_S50_J4/","048_CH2_EP_RAF_ENP_S49_J5/","064_CH1_EP_RAF_ENP_S49_J1/",
"064_CH2_EP_RAF_ENP_S49_J4/","655_CH1_EP_RAF_ENP_S51_J2_J3_J4/","655_CH2_EP_RAF_ENP_S52_J1_J2_S01_J1/"
]
# Noms des différents fonction objectifs (Cf README)
fnames = ["optimization_objectives","paint_batch_limit","ratios","vehicles"]
suff = ".txt"
# Fonction permettant d'accèder à la j-ème instance de type i.
function instance_shortcut(i,j)
	if i==1
		return path*ABX[i]*instances_A[j]
	elseif i==2
		return path*ABX[i]*instances_B[j]
	else
		return path*ABX[i]*instances_X[j]
	end
end
#############################################################
# Remarque :
# Nous choisissons d'encoder la composition d'un véhicule de la manière suivante :
# ___Cpt____|___Col____ un vecteur dans lequel
#   - le membre gauche contient les composants utilisés (directement lu dans la matrice parsée)
#   - le membre droit contient une couleur dite boolearisée : Dans les instances, les couleurs sont représentées par des entiers;
#     nous avons choisi de coder les couleurs sur un vecteur de taille Max_Nb_Color ne contenant que des 0 excecpté sur l'indice de la couleur
function extract(D::RawData)
	nbObj=D.nbObj      # Nombre d'objctifs de l'instance
	sObj=D.sortedObj   # Tableau contenant les objectifs à optimiser dans l'ordre
	s=D.limitation;    # Limite de la rafale de peinture de
	l=D.N;             # Ratio N de couple NP
	m=D.P;             # Limite de temps de couple NP
	h=D.prio           # Indice de priorité : 1 si High; 0 si Low
	# Notation :
	#   - J0 : Correspond aux véhicules produits le jour J-1
	#   - J1 : Correspond aux véhicules produits le jour J
	#   - J : Correspond à l'ensemble des véhicules présentés dans l'instance
	##############################################################################
	# booléarisation des couleures et concaténation à la fin des konfigurations
    	colorJ=vcat(D.colorJ0,D.colorJ1)
	matcolorJ=boolearisation(colorJ)
	# Concaténation des couleurs pour les véhicules des jours J0 et J1
    	matJ=vcat(D.matriceHLJ0,D.matriceHLJ1)
	JM=hcat(matJ,matcolorJ)
	# Nombre de composants sans prise en compte des couleurs (nbC minus F)
	nbCmF=size(h,1)
	# Nombre total de compsants prenant en compte les couleurs;
	nbC=nbCmF+maximum(union(D.colorJ0,D.colorJ1))
	# Nombre de voiture produites en J0
	nbe = size(D.colorJ0,1)
	# Calcul configurations, nb de voiture possédant une configuration spécifique et matrice des composants associéses pour la production de la journée J1 (CF modèle maths)
	a,nbK,delta = extractKonfig(JM[nbe+1:end,:])
	# Demande de chaque composants pour la production de la journée J1
	d = [sum(a[c,k]*delta[k] for k in 1:nbK) for c in 1:nbC]
	# Utilisation de la transposée pour obtenir la matrice des demande de composants (et peintures)(i.e. configurations) pour la journée J0
	e=(JM[1:nbe,:])';
	# Nombre de positions
	nbPos = size(JM,1)



	#
	ml = min(nbe,s)
	tmp = nbe*ones(Int,size(m,1))
	#println("m ",m)
	#println("tmp ",tmp)
	mc = minimum([tmp m], dims= 2)
	#println("mc ",mc[:,1])

	carj0=nbe
	carj=nbPos-nbe
	cpmt=nbCmF-count(x->x==0,d[1:nbCmF])
	colr=nbC-nbCmF-count(x->x==0,d[nbCmF+1:nbC])
	return carj0,carj,cpmt,colr,Instance(nbObj,sObj,nbPos-nbe,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc[:,1])
end
#############################################################
# Comme évoqué plus haut, fonction de boolearisation des couleurs
function boolearisation(J)
	m=zeros(Int,size(J,1),maximum(J))
	for i in 1:size(J,1)
		m[i,J[i]]=1
	end
	return m
end
#############################################################
# Extraction des informations relatives aux configurations
# delta : demande en configuration (compteur)
# K : le tableau des configurations possbiles; Lors de parcours des véhicules, deux cas possibles
#      - cas 1 : une nouvelles configuration (composant+peinture) est détectée -> Ajout de cette configuration + incrémentation du compteur
#      - cas 2 : une confguration est déjà rencontrée -> incrémentation du compteur associé à cette confguration
# a : matrice des affectations des composants pour la journée J1 (analyse des configurations)
function extractKonfig(J)
	K=Array{Array{Int,1},1}()
	delta=Array{Int,1}()
	for i in 1:size(J,1)
		k = J[i,:]
		if k in K
			di=findfirst(x->x==k,K)
			delta[di]=delta[di]+1
		else
			push!(K,k)
			push!(delta,1)
		end
	end
	nbK=size(K,1)
	a=zeros(Int,size(K[1],1),nbK)
	for k in 1:nbK
		for c in 1:size(K[1],1)
			if K[k][c] == 1
				a[c,k] = 1
			end
		end
	end
	return a,nbK,delta
end

# retourne tous les composants d'une instance
function retourInst(I)
	return I.nbObj,I.sObj,I.nbPos,I.s,I.nbCmF,I.nbC,I.nbK,I.delta,I.d,I.a,I.l,I.m,I.h,I.e,I.ml,I.mc
end


function coupeEtExtract(nbvehicules::Int,D::RawData,rando=false)
	# Données qui ne changent pas
	nbObj=D.nbObj  		# Nombre d'objctifs de l'instance
	sObj=D.sortedObj 	# Tableau contenant les objectifs à optimiser dans l'ordre
	h=D.prio		# Indice de priorité : 1 si High; 0 si Low
	nbCmF=size(h,1)		# Nombre de composants sans prise en compte des couleurs (nbC minus F)
	nbe = size(D.colorJ0,1)     	# Nombre de voiture produites en J0

	# Données qui ne devraient pas changer
	# on estime ne pas changer ces données car, les fenêtres sont déjà petites
	l=D.N;			# Ratio N de couple NP
	m=D.P; 			# Limite de temps de couple NP



	# Données qui changent
	# nombres de véhicules
	nbPos = nbvehicules # Nombre de véhicules dont on se préoccupera
	# composant qui sont modifié à cause en imposant le nombre de véhicules
	nOrigine = size(D.colorJ1,1)	# Nombre de véhicules de la journée d'origine
	s = floor(nbPos * D.limitation / nOrigine) # Nombre de voitures de même couleur à la suite


	# Choix des nbvéhicules et réduction de colorJ1 et matriceHLJ1
	if rando
		random = sort!(sample(1:nOrigine,nbvehicules,replace = false))
	else
		random = 1:nbvehicules
	end
	ColorJ1 = D.colorJ1[random,:]
	MatriceHLJ1 = D.matriceHLJ1[random,:]

	# Création des matrices
	colorJ=vcat(D.colorJ0,ColorJ1)
	matcolorJ=boolearisation(colorJ)

   	matJ=vcat(D.matriceHLJ0,MatriceHLJ1)
	JM=hcat(matJ,matcolorJ)

	nbC=nbCmF+maximum(union(D.colorJ0,ColorJ1)) # Nombre total de compsants prenant en compte les couleurs;
	# Calcul configurations, nb de voiture possédant une configuration spécifique et matrice des composants associéses pour la production de la journée J1
	a,nbK,delta = extractKonfig(JM[nbe+1:end,:])
    	# Demande de chaque composants pour la production de la journée J1
	d = [sum(a[c,k]*delta[k] for k in 1:nbK) for c in 1:nbC]
	# Utilisation de la transposée pour obtenir la matrice des demande de composants (et peintures)(i.e. configurations) pour la journée J0
	e=(JM[1:nbe,:])';

	#
	ml = min(nbe,s)
	tmp = nbe*ones(Int,size(m,1))
	#println("m ",m)
	#println("tmp ",tmp)
	mc = minimum([tmp m], dims= 2)
	#println("mc ",mc[:,1])
	cpmt=nbCmF-count(x->x==0,d[1:nbCmF])
	colr=nbC-nbCmF-count(x->x==0,d[nbCmF+1:nbC])
	# Affichage
	println("#Cars(J-1)	= ",nbe,"\n","#Cars(J) 	= ",nbPos,"\n","#Cpmt		= ",npmt,"\n","#Color		= ",colr)

	return Instance(nbObj,sObj,nbPos,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc[:,1])
end

# fonction qui print les matrices DenseAxisArray  où axes(A, d) retourne le range valide de la matrice sparcée
function printm(M)
	for i in axes(M, 1)
		println(M[i,:]')
	end
end

# retourne les range et les pondérations gamma associés à l'instance
function gammarisation(sObj,h)
	gamma=[10^6,10^3,1]
	if typeof(findfirst(x->x==0,h))==Nothing
		gammaL=0
		rL=1:1
		gammaH=gamma[findfirst(x->x=="HPRC",sObj)]
		rH=1:size(h,1)
	else
		rL=findfirst(x->x==0,h):size(h,1)
		gammaL=gamma[findfirst(x->x=="LPRC",sObj)]
		if findfirst(x->x==0,h)-1==-1
			gammaH=0
			rH=1:1
		else
			rH=1:findfirst(x->x==0,h)-1
			gammaH=gamma[findfirst(x->x=="HPRC",sObj)]
		end
	end
	if typeof(findfirst(x->x=="PBC",sObj))==Nothing
		gammaF=0
	else
		gammaF=gamma[findfirst(x->x=="PBC",sObj)]
	end
	return rH,rL,gammaH,gammaL,gammaF
end

# transforme une matrice solution du modèle en séquence solution
function makefilm(b,D::RawData,I::Instance)
    	colorJ=vcat(D.colorJ0,D.colorJ1)
	matcolorJ=boolearisation(colorJ)
    	matJ=vcat(D.matriceHLJ0,D.matriceHLJ1)
	JM=hcat(matJ,matcolorJ)
	nbe = size(D.colorJ0,1)
	a,nbK,delta = extractKonfig(JM[nbe+1:end,:])
	J=[JM[i,:] for i in (nbe+1):size(JM,1)]

	s=Array{Int,1}()
	T=collect(1:size(J,1))
	for i in 1:size(b,2)
		j = findfirst(x->x==b[:,i],J)
		J[j]=zeros(Int,size(J[1],1))
		push!(s,j)
	end
	return s
end
# transforme une séquence solution en matrice solution du modèle
function readfilm(s,D::RawData,I::Instance)
    	colorJ=vcat(D.colorJ0,D.colorJ1)
	matcolorJ=boolearisation(colorJ)
    	matJ=vcat(D.matriceHLJ0,D.matriceHLJ1)
	JM=hcat(matJ,matcolorJ)
	nbe = size(D.colorJ0,1)
	a,nbK,delta = extractKonfig(JM[nbe+1:end,:])
	J=JM[nbe+1:end,:]
	b=zeros(Int,size(J))
	for i in 1:size(s,1)
		b[i,:]=J[s[i],:]
	end
	return b'
end

# affiche 
function printres(m,D::RawData,I::Instance)
	#println("Composants installés")
	b = Int.(value.(m[:b]))
	#printm(b)
	#println("Position des [c/k]onfigurations dans le film")
	#p = Int.(value.(m[:p]))	#println(size(bt,2),"\n\n")
	#printm(p)
	#film = Array{Int,1}()
	#for j in 1:size(p,2)
	#	for i in 1:size(p[:,j],1)
	#		if (p[i,j]==1)
	#			push!(film,i)
	#		end
	#	end
	#end
	film = makefilm(b,D,I)
	#b2 = readfilm(film,D,I)
	println("\nFilm obtenu (taille = ",size(film,1),") : ",film)
	##	Contraintes violée sur composants
	#println("Composants violés")
	#g = Int.(value.(m[:g]));printm(g)
	#println("Couleurs violées")
	#w = Int.(value.(m[:w]));printm(w)
end

# affiche les changements de couleurs
function printcolor(m,F,n)
	for j in 1:n
		for i in F
			if (value(m[:w][i,j])==1)
				println("Changement de couleurs à la position ",j)
			end
		end
	end
end



# Fonction pour construire une solution partielle pour la variable w
function solpartiel(mt,d,F,nbCmF,nbC,n)
	##### Et si on ajoutait une solution partielle ...
	# pour les df, il faut trouver le nombre de changements maxi

	nbMaxichgtcol = sum(d[F]) - maximum(d[F])
	f = nbCmF + 1
	j = 1
	nbb = 1
	for i in 1:n
		for col in F
		#println("f ",f," j ",j)
		if i == j && col == f && nbb <= nbMaxichgtcol - 1
			#println(JuMP.all_variables(mt))

			JuMP.set_start_value(variable_by_name(mt,string("w[",f,",",i,"]")),1)
			nbb = nbb + 1
			j = j + 1
			if j == n + 1
				j = 1
			end
			f = f + 1
			if f == nbC + 1
				f = nbCmF + 1
			end
		else
			JuMP.set_start_value(variable_by_name(mt,string("w[",f,",",i,"]")),0)
		end
		end
	end
	println("Et la solution partielle ...",nbMaxichgtcol," et nbb ",nbb)
end


# Fonction pour donner une solution via la variable b donnée par les Français
function solpartielB(mt,B)
	n = size(B,1)
	m = size(B,2)
	for i in 1:n
		for j in 1:m
			JuMP.set_start_value(variable_by_name(mt,string("b[",i,",",j,"]")),B[i,j])

		end

	end
end

# fonction qui test l'admissibilité d'une séquence
function testseq(seq,set,ins;timelim=600,gaplim=0.00)
	Data = parseInstance(instance_shortcut(set,ins))
	carj0,carj,cpmt,colr,Inst = extract(Data)
	println("#Cars(J-1)	= ",carj0,"\n","#Cars(J) 	= ",carj,"\n","#Cpmt		= ",cpmt,"\n","#Color		= ",colr)

	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(Inst)

	b = readfilm(seq,Data,Inst)

	mt = modeltestseq(b,solver,Inst,1000,gaplim,false)

	@time optimize!(mt)
	println(termination_status(mt))
	film = makefilm(b,Data,Inst)
	println("\nSEQUENCE MATCHING ? ",b==film)

end

# a partir d'une liste de rectangles et d'un nouveau rectangle, construit la nouvelle liste de rectangles
function makerect!(L,r,pf,pl,YI)
	a,b=r[1],r[2]
	r1=true;r2=true
	for j in 1:size(L,1)
		c,d = L[j][1],L[j][2]
		r1=r1&&!(c==pl&&d>b)
		r2=r2&&!(d==pf&&c>a)
	end
	if r1 push!(L,(pl,b)) end
	if r2 push!(L,(a,pf)) end
	return L
end

# retourne le plus grand rectangle d'une liste 
function getrect!(L,YI)
	if size(L,1)>0
		i = findmax(map(x->(YI[1]-x[1])*(YI[1]-x[1])+(x[2]-YI[2])*(x[2]-YI[2]),L))[2]
		a,b=L[i][1],L[i][2]
		deleteat!(L,i)
	else
		a,b=0
	end
	return [a,b],L
end

# fonction qui test si une solution dans l'espace des objectif est admissible
function isadmissible(set,ins,hp,ww,lp,solver,timelim=600,gaplim=0.00)
	Data = parseInstance(instance_shortcut(set,ins))
	carj0,carj,cpmt,colr,Inst = extract(Data)
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(Inst)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim,OutputFlag=0))
	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n], binary = true)
	@variable(mt,w[F,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	@objective(mt,Min,0)
	@constraint(mt,sum(sum(g[c,i] for i in 1:n) for c in rH)==hp)
	@constraint(mt,sum(sum(g[c,i] for i in 1:n) for c in rL)==lp)
	@constraint(mt,sum(sum(w[f,i] for i in 1:n) for f in F)==ww)
	@constraint(mt,only1color[i=1:n],sum(b[f,i] for f in F)==1)
	@constraint(mt,compdemand[c=C],sum(b[c,i] for i in 1:n)==d[c])
	@constraint(mt,confbounds[k=K,c=C,i=1:n],p[k,i]<=a[c,k]*b[c,i]+(1-a[c,k])*(1-b[c,i]))
	@constraint(mt, only1conf[c=C,i=1:n],b[c,i]==sum(a[c,k]*p[k,i] for k in K))
	@constraint(mt,confdemand[k=K],sum(p[k,i] for i in 1:n)==delta[k])
	@constraint(mt,   nbviol1[c=CmF,i=1:mc[c]-1],g[c,i]>=sum(b[c,j] for j in 1:i) + sum(e[c,j] for j in (size(e,2) - mc[c]+i+1):size(e,2))-l[c])
	@constraint(mt,   nbviol2[c=CmF,i=m[c]:n],g[c,i]>=sum(b[c,j] for j in i-m[c]+1:i)-l[c])
	@constraint(mt,nbcolorchange1[f=F],w[f,1]>=b[f,1]-e[f,end])
	@constraint(mt,nbcolorchange2[f=F,i=2:n],w[f,i]>=b[f,i]-b[f,i-1])
	@constraint(mt,paintshop1[f=F,i=1:ml],sum(b[f,j] for j in 1:i)+sum(e[f,j] for j in (size(e,2) - ml+1+i):size(e,2))<=s)
	@constraint(mt,paintshop2[f=F,i=s+1:n],sum(b[f,j] for j in i-s:i)<=s)
	optimize!(mt)

	if termination_status(mt)==MOI.OPTIMAL
		println("  ---------------------------------------------------------------------\n | LA SOLUTION : EP=",hp," ENP=",lp," RAF=",ww," EST ADMISSIBLE POUR L'INSTANCE (",set,",",ins,") | \n  ---------------------------------------------------------------------")
	end
	return termination_status(mt)==MOI.OPTIMAL
end

# Calcul du nombre minimum de changement de couleur
function makemini(F,d,s)
	mini = 0
	for col in d[F]
		if col != 0
			mini = mini + div(col,s) 
			if (col%s) > 0
				mini = mini + 1
			end
		end 
	end
	mini = mini - 1
	println("########################################")
	println("Le nombre de changements minimum de couleur est ",mini)
	println("########################################")

	return mini
end

# fonction qui affecte une solution initiale à un modèle
function mangeSolution(path::String,D::RawData,I::Instance,mt::Model)
	#####	Récupération des données de l'instance
	colorJ=vcat(D.colorJ0,D.colorJ1); matcolorJ=boolearisation(colorJ)
	matJ=vcat(D.matriceHLJ0,D.matriceHLJ1); JM=hcat(matJ,matcolorJ)
	nbe = size(D.colorJ0,1); a,nbK,delta = extractKonfig(JM[nbe+1:end,:])
	J=JM[nbe+1:end,:]
	#####	Récupération des données du film proposé par les camarades
	film = CSV.File(path,delim=';',silencewarnings=true,header=false,ignoreemptylines=true) |> DataFrame
	minfilm = size(D.colorJ0)[1]
	matSeq =zeros(Int,size(J))
	for i in 1:size(film,2)
		veh = film[!,i][1]
		if !ismissing(veh)
			matSeq[i, :] = J[veh-minfilm,:]
		end
	end
	#### Construction de la matrice b
	b = matSeq'
	#### Fixation des valeurs des variables de b
	for i in 1:size(b,1)
		for j in 1:size(b,2)
			JuMP.set_start_value(variable_by_name(mt,string("b[",i,",",j,"]")),b[i,j])
		end
	end
	return mt
end

#m=[1 0 0 1 0; 2 1 0 1 0; 1 0 0 1 0; 3 1 0 1 3]


#gamma=[1,1,1]
#a = [1 0;
#     0 1;
#     1 1]
#d = [1,1,2]
#delta = [3,7]
#m = [4,4,4]
#l = [3,7,10]
#e = [1 0 1;1 0 1;1 0 1;1 0 1;1 0 1;1 0 1;1 0 1;1 0 1;1 0 1;1 0 1]
#C=2
#F=1
#K=2
#n=10
#s=3
