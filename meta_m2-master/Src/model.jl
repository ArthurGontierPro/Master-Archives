# modèle pour une somme pondéré
function model(solver,I,timelim,gaplim,solPartiel = false )
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim))

	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)
	# 10^6 pour la première pénalité 10^3 pour la deuxième et 1 pour la dernière (elles sont rangées dans l'ordre lexico)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n], binary = true)
	@variable(mt,w[F,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	@objective(mt,Min,sum(gammaH*sum(g[c,i] for i in 1:n) for c in rH)
			+ sum(gammaL*sum(g[c,i] for i in 1:n) for c in rL)
			+ sum(gammaF*sum(w[f,i] for i in 1:n) for f in F))

	#@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rH)
	#		+ sum(sum(g[c,i] for i in 1:n) for c in rL)
	#		+ sum(sum(w[f,i] for i in 1:n) for f in F))

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

	if solPartiel == true 
		solpartiel(mt,d,F,nbCmF,nbC,n)
	end
	return mt
end

# modèle présenté par l'article portugais (non utilisé)
function modelPortugais(solver,I,timelim,gaplim)
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim))

	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)
	# 10^6 pour la première pénalité 10^3 pour la deuxième et 1 pour la dernière (elles sont rangées dans l'ordre lexico)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n] >=0)
	@variable(mt,w[F,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)
	@variable(mt,r[CmF,1:n] >=0)

	@objective(mt,Min,sum(gammaH*sum(g[c,i] for i in 1:n) for c in rH)
			+ sum(gammaL*sum(g[c,i] for i in 1:n) for c in rL)
			+ sum(gammaF*sum(w[f,i] for i in 1:n) for f in F))
	#@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in CmF) + sum(sum(w[f,i] for i in 1:n) for f in F))
	#@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in CmF))
	#@objective(mt,Min,sum(sum(w[f,i] for i in 1:n) for f in F))

	@constraint(mt,ctr3[k=K],sum(p[k,i] for i in 1:n)==delta[k])
	@constraint(mt,ctr4[i=1:n],sum(p[k,i] for k in K)==1)

	@constraint(mt,nctr5et6[c=C],sum(sum(a[c,k]*p[k,i] for k in K) for i in 1:n)==d[c])

	@constraint(mt,ctr9[c=CmF],r[c,1]==sum(a[c,k]*p[k,1] for k in K))
	@constraint(mt,ctr10[c=CmF,i=2:n],r[c,i]==r[c,i-1]+sum(a[c,k]*p[k,i] for k in K))
	@constraint(mt,ctr12[c=CmF,i=1:mc[c]-1],g[c,i]>=r[c,i]+sum(e[c,m] for m in 1:-1:mc[c]-i)-l[c])
	@constraint(mt,ctr13[c=CmF,i=m[c]+1:n],g[c,i]>=r[c,i]-r[c,i-m[c]]-l[c])
	@constraint(mt,ctr13bis[c=CmF],g[c,m[c]]>=r[c,m[c]]-l[c])
	@constraint(mt,ctr14[f=F,i=1:n],b[f,i]==sum(a[f,k]*p[k,i] for k in K))
	@constraint(mt,ctr15[f=F,i=s+1:n],sum(b[f,j] for j in i-s:i)<=s)
	@constraint(mt,ctr15bispotentiel[f=F,i=1:ml],sum(b[f,j] for j in 1:i)+sum(e[f,j] for j in 1:ml+1-i)<=s)
	@constraint(mt,ctr16[f=F],w[f,1]>=b[f,1]-e[f,end])
	@constraint(mt,ctr17[f=F,i=2:n],w[f,i]>=b[f,i]-b[f,i-1])

	return mt
end

# modèle pour la résolution du troisième objectif seulement
function modelz3only(solver,I,timelim,gaplim,solPartiel = false)
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)

	# gamma et distinction des composants de hautes/faibles priorité
	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)

	# Range des composants/couleurs/configurations dans les matrices
	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	# Calcul du nombre minimum de changement de couleur
	nb,mini = 0,0
	for col in d[F]
		if col != 0
			mini = mini + div(col,s) 
			if (col%s) > 0
				mini = mini + 1
			end
			nb = nb + 1
		end 
	end
	mini = mini - 1
	println("Le nombre de changement minimum de couleur est ",mini)

	# Déclaration du modèle
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim,BestObjStop = mini )) # nbC - nbCmF

	# Variables
	@variable(mt,w[F,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	# Objectifs
	@objective(mt,Min,sum(sum(w[f,i] for i in 1:n) for f in F))

	# Contraintes
	@constraint(mt,only1color[i=1:n],sum(b[f,i] for f in F)==1)
	@constraint(mt,compdemand[c=C],sum(b[c,i] for i in 1:n)==d[c])
	@constraint(mt,confbounds[k=K,c=C,i=1:n],p[k,i]<=a[c,k]*b[c,i]+(1-a[c,k])*(1-b[c,i]))
	@constraint(mt, only1conf[c=C,i=1:n],b[c,i]==sum(a[c,k]*p[k,i] for k in K))
	@constraint(mt,confdemand[k=K],sum(p[k,i] for i in 1:n)==delta[k])
	@constraint(mt,nbcolorchange1[f=F],w[f,1]>=b[f,1]-e[f,end])
	@constraint(mt,nbcolorchange2[f=F,i=2:n],w[f,i]>=b[f,i]-b[f,i-1])
	@constraint(mt,paintshop1[f=F,i=1:ml],sum(b[f,j] for j in 1:i)+sum(e[f,j] for j in (size(e,2) - ml+1+i):size(e,2))<=s)
	@constraint(mt,paintshop2[f=F,i=s+1:n],sum(b[f,j] for j in i-s:i)<=s)

	# Si l'on veut déclarer une solution partielle gloutonne
	if solPartiel == true 
		solpartiel(mt,d,F,nbCmF,nbC,n)
	end

	return mt
end

# modèle pour la résolution du second objectif seulement
function modelz2only(solver,I,timelim,gaplim)
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim))

	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)
	# 10^6 pour la première pénalité 10^3 pour la deuxième et 1 pour la dernière (elles sont rangées dans l'ordre lexico)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rL))

	@constraint(mt,only1color[i=1:n],sum(b[f,i] for f in F)==1)
	@constraint(mt,compdemand[c=C],sum(b[c,i] for i in 1:n)==d[c])
	@constraint(mt,confbounds[k=K,c=C,i=1:n],p[k,i]<=a[c,k]*b[c,i]+(1-a[c,k])*(1-b[c,i]))
	@constraint(mt, only1conf[c=C,i=1:n],b[c,i]==sum(a[c,k]*p[k,i] for k in K))
	@constraint(mt,confdemand[k=K],sum(p[k,i] for i in 1:n)==delta[k])
	@constraint(mt,   nbviol1[c=rL,i=1:mc[c]-1],g[c,i]>=sum(b[c,j] for j in 1:i) + sum(e[c,j] for j in (size(e,2) - mc[c]+i+1):size(e,2))-l[c])
	@constraint(mt,   nbviol2[c=rL,i=m[c]:n],g[c,i]>=sum(b[c,j] for j in i-m[c]+1:i)-l[c])
	@constraint(mt,paintshop1[f=F,i=1:ml],sum(b[f,j] for j in 1:i)+sum(e[f,j] for j in (size(e,2) - ml+1+i):size(e,2))<=s)
	@constraint(mt,paintshop2[f=F,i=s+1:n],sum(b[f,j] for j in i-s:i)<=s)


	return mt
end

# modèle pour la résolution du premier objectif seulement
function modelz1only(solver,I,timelim,gaplim)
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim))

	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rH))

	@constraint(mt,only1color[i=1:n],sum(b[f,i] for f in F)==1)
	@constraint(mt,compdemand[c=C],sum(b[c,i] for i in 1:n)==d[c])
	@constraint(mt,confbounds[k=K,c=C,i=1:n],p[k,i]<=a[c,k]*b[c,i]+(1-a[c,k])*(1-b[c,i]))
	@constraint(mt, only1conf[c=C,i=1:n],b[c,i]==sum(a[c,k]*p[k,i] for k in K))
	@constraint(mt,confdemand[k=K],sum(p[k,i] for i in 1:n)==delta[k])
	@constraint(mt,   nbviol1[c=rH,i=1:mc[c]-1],g[c,i]>=sum(b[c,j] for j in 1:i) + sum(e[c,j] for j in (size(e,2) - mc[c]+i+1):size(e,2))-l[c])
	@constraint(mt,   nbviol2[c=rH,i=m[c]:n],g[c,i]>=sum(b[c,j] for j in i-m[c]+1:i)-l[c])
	@constraint(mt,paintshop1[f=F,i=1:ml],sum(b[f,j] for j in 1:i)+sum(e[f,j] for j in (size(e,2) - ml+1+i):size(e,2))<=s)
	@constraint(mt,paintshop2[f=F,i=s+1:n],sum(b[f,j] for j in i-s:i)<=s)


	return mt
end

# modèle qui test si une solution b est admissible
function modeltestseq(b,solver,I,timelim,gaplim,solPartiel = false )
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim))

	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)
	# 10^6 pour la première pénalité 10^3 pour la deuxième et 1 pour la dernière (elles sont rangées dans l'ordre lexico)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n], binary = true)
	@variable(mt,w[F,1:n], binary = true)
	#@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	@objective(mt,Min,0)

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

	if solPartiel == true 
		solpartiel(mt,d,F,nbCmF,nbC,n)
	end
	return mt
end

# Modèle pour l'epsilon contrainte avec les composants hautes priorités en fonction objectif et la fonction objectif sur les couleurs en contrainte
function modelHP1W2(solver,I,timelim,gaplim;solPartiel = false,obj = 1)
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
	mt = Model(with_optimizer(solver,GUROBI_ENV,TimeLimit=timelim,MIPGap=gaplim))
	rH,rL,gammaH,gammaL,gammaF=gammarisation(sObj,h)

	C = 1:nbC
	CmF = 1:nbCmF
	F = nbCmF+1:nbC
	K = 1:nbK

	@variable(mt,g[CmF,1:n], binary = true)
	@variable(mt,w[F,1:n], binary = true)
	@variable(mt,b[C,1:n], binary = true)
	@variable(mt,p[K,1:n], binary = true)

	if obj == 1
		@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rH))
	elseif obj == 2
		@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rL))
	else
		@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rH) + sum(sum(g[c,i] for i in 1:n) for c in rL))
	end
			#+ sum(sum(g[c,i] for i in 1:n) for c in rL)
			#+ sum(sum(w[f,i] for i in 1:n) for f in F))

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


	if solPartiel == true 
		solpartiel(mt,d,F,nbCmF,nbC,n)
	end

	maxiColor = n # n correspond bien au nombre de voitures du jour actuelle ?

	@variable(mt, const_term)
	@constraint(mt, eps, sum(sum(w[f,i] for i in 1:n) for f in F) <= const_term)
	fix(const_term, maxiColor)

	return mt,n,F,rH,rL,d,s
end

# modèle pour la résolution d'une itération de Kirlik et Sayin
function modelKetS(solver,I,timelim,gaplim,solPartiel = false )
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
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

	@objective(mt,Min,sum(gammaH*sum(g[c,i] for i in 1:n) for c in rH))
			#+ sum(gammaL*sum(g[c,i] for i in 1:n) for c in rL)
			#+ sum(gammaF*sum(w[f,i] for i in 1:n) for f in F))

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

	if solPartiel == true
		solpartiel(mt,d,F,nbCmF,nbC,n)
	end

	@variable(mt, const_termf)
	@variable(mt, const_terml)
	@constraint(mt, epsf, sum(sum(w[f,i] for i in 1:n) for f in F) <= const_termf)
	@constraint(mt, epsl, sum(sum(g[c,i] for i in 1:n) for c in rL) <= const_terml)

	return mt,n,F,rH,rL,d,s
end

# modèle pour la deuxième résolution de la double résolution de Kirlik et Sayin
function modelKetSdouble(solver,I,timelim,gaplim,solPartiel = false )
	nbObj,sObj,n,s,nbCmF,nbC,nbK,delta,d,a,l,m,h,e,ml,mc = retourInst(I)
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

	@objective(mt,Min,sum(sum(g[c,i] for i in 1:n) for c in rL)
			+ sum(sum(w[f,i] for i in 1:n) for f in F))

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

	if solPartiel == true
		solpartiel(mt,d,F,nbCmF,nbC,n)
	end

	@variable(mt, const_termf)
	@variable(mt, const_terml)
	@variable(mt, const_termh)
	@constraint(mt, epsf, sum(sum(w[f,i] for i in 1:n) for f in F) <= const_termf)
	@constraint(mt, epsl, sum(sum(g[c,i] for i in 1:n) for c in rL) <= const_terml)
	@constraint(mt, epsy, sum(sum(g[c,i] for i in 1:n) for c in rH) <= const_termh)

	return mt,n,F,rH,rL,d,s
end



