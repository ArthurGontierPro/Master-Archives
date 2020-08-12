# Fonction epsilon contrainte (changer la ligne mt = ... si on veut changer le modèle)
function epsConstraint(solver,Data,Inst,timelim,gaplim,solP,verbose,obJ)

	mt,n,F,rH,rL,d,s = modelHP1W2(solver,Inst,timelim,gaplim,obj=obJ)

	mini = makemini(F,d,s)

	valeurs = []
	nbE = 0

	# Première résolution
	optimize!(mt)
	# Affichage 
	println("########################################")
	println("Statut ",termination_status(mt))
	if termination_status(mt)==MOI.OPTIMAL
		hp = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rH)
		lp = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rL)
		wcol = sum(sum(round(Int64,value(mt[:w][f,i])) for i in 1:n) for f in F)
		println("Solution (hp,w,lp) : (",hp,",",wcol,",",lp,")") 

		push!(valeurs,[hp,lp,wcol])
		nbE = nbE + 1 
	end
	println("########################################")




	# Si le statut est optimal -> on lance la boucle pour obtenir les solutions
	nb = 1
	while termination_status(mt)==MOI.OPTIMAL && wcol > mini

		# Mode verbose
		if verbose printres(mt,Data,Inst) end
		
		# Résolution du nouveau modèle avec l'epsilon modifié
		maxiColor = sum(sum(round(Int64,value(mt[:w][f,i])) for i in 1:n) for f in F)

		#mt,n,F,rH,rL,d,s = modelHP1W2(solver,Inst,timelim,gaplim,obj)

		fix(mt[:const_term], maxiColor - 1) 
		optimize!(mt)

		# Affichage 
		println("########################################")
		println("Statut ",termination_status(mt))
		if termination_status(mt)==MOI.OPTIMAL
			hp = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rH)
			lp = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rL)
			wcol = sum(sum(round(Int64,value(mt[:w][f,i])) for i in 1:n) for f in F)
			println("Solution (hp,w,lp) : (",hp,",",wcol,",",lp,")") 
			#printcolor(mt,F,n)

			# Sauvegarde des solutions
			if valeurs[nbE][1] >= hp && valeurs[nbE][2] >= lp && valeurs[nbE][3] >= wcol
				valeurs[nbE][1] = hp
				valeurs[nbE][2] = lp
				valeurs[nbE][3] = wcol
			else
				push!(valeurs,[hp,lp,wcol])
				nbE = nbE + 1
			end 
		end
		println("########################################")

		# Comptage du nombre de solutions
		nb = nb + 1
	end


	# Ajout : vérif de solutions, vecteur qui récupère toutes les solutions et enlève les faiblement efficaces, arrêter l'algo quand on attend le nombre minimal de couleurs (montrer que c'est infeasible est long pour Gurobi alors que nous le savons) 
	println("La résolution se termine avec le statut  ",termination_status(mt))
	println("La résolution se termine avec ",nb," itérations")
	println("La résolution se termine avec ",nbE," solutions efficaces")
	println("Voici leurs valeurs :")
	for i in 1:nbE
		println("Solution (hp,w,lp) : (",valeurs[nbE][1],",",valeurs[nbE][3],",",valeurs[nbE][2],")") 
	end

end


