using JuMP, GLPKMathProgInterface

function choixNoeudHotStart(dico::Dict,bestZ,noeud,ancienZ,p)
	nb,som = "",maxintfloat()
	for k in keys(dico)
		if dico[k] > bestZ
			delete!(dico,k)
		elseif dico[k] < som
			nb = k
			som = dico[k]	
		end
	end
	if ancienZ * (1-p/100) <= som && haskey(dico,noeud)
		nb = noeud 
	end
	return dico,nb
end


function choixVarProcheEnt(sol)
	k,dif,entier = 0,1,true
	for i in 1:length(sol)
		s = round(sol[i],digits = 5)
		if floor(s) != s && ceil(s) != s
			if dif > min(s - floor(s) , ceil(s) - s)
				dif = min(s - floor(s) , ceil(s) - s)
				k = i
				entier = false
			end
		end
	end
	return entier,k
end

function choixVarPremEntR(sol)
	i,entier = 1,true
	while i <= length(sol) && entier
		s = round(sol[i],digits =5)
		if floor(s) != s
			entier = false
		else 
			i = i + 1
		end
	end
	return entier,i
end


function BBAH(k,Aspp,Ac,Af,Fe,Ce,p,version,comparaison,zprimal,solMIP)
	cc = LPP_LP(GLPKSolverLP(),k,Aspp,Ac,Af,Fe,Ce)
	status = solve(cc,suppress_warnings=true)
	if status == :Optimal
		z = getobjectivevalue(cc)
		sol = getvalue(cc[:x])
	end
	dico = Dict()
	dico["g"] = z
	abr = Arbre()
	abr.suite['g'] = Arbre()
	currentAbr = abr.suite['g']
	if !comparaison
		bestZ = Integer(maxintfloat())
		bestSol = Vector{}(undef,size(sol,1))
	else
		bestZ = zprimal
		bestSol = solMIP
	end
	if version == 1
		entier,var = choixVarProcheEnt(sol)
	else 
		entier,var = choixVarPremEntR(sol)
	end
	if var != 0
		currentAbr.contr = var
	end
	x = cc[:x]
	vraiment = 1
	noeud = 'g'
	ancienZ = z
	noeudActu = noeud
	while dico != Dict()
		dico,noeud = choixNoeudHotStart(dico,bestZ,noeudActu,ancienZ,p)
		vraiment = vraiment + 2
		if noeud != "" 	
			# Pour les deux enfants : Résolution de la version LP du problème
			for kk in "ab"
				if noeud != noeudActu
					currentAbr = abr
					cc = LPP_LP(GLPKSolverLP(),k,Aspp,Ac,Af,Fe,Ce)
					x = cc[:x]
					if length(noeud) > 1
						for i in 1:(length(noeud)-1)
							currentAbr = currentAbr.suite[noeud[i]]
							if noeud[i+1] == 'a'
								@constraint(cc, x[currentAbr.contr] <= 0.0 ) # nouv[i]
							elseif noeud[i+1] == 'b'
								@constraint(cc, x[currentAbr.contr] >= 1.0 ) # nouv[i]
							end
						end
					end
					noeudActu = noeud
					currentAbr = currentAbr.suite[noeud[length(noeud)]]
				end
				noeudActu = noeudActu * kk
				if kk == 'a'
					@constraint(cc, x[currentAbr.contr] <= 0.0 )
				elseif kk == 'b'
					@constraint(cc, x[currentAbr.contr] >= 1.0 )
				end

				status = solve(cc, suppress_warnings=true)
				if status == :Optimal
					if version == 1
						entier,var = choixVarProcheEnt(getvalue(cc[:x]))
					else 
						entier,var = choixVarPremEntR(getvalue(cc[:x]))
					end
					if !entier
						if getobjectivevalue(cc) < bestZ
							dico[noeud*kk] = getobjectivevalue(cc)
							currentAbr.suite[kk] = Arbre()
							currentAbr = currentAbr.suite[kk]
							if var != 0
								currentAbr.contr = var
							end
						end
					else
						if getobjectivevalue(cc) < bestZ
							bestZ = getobjectivevalue(cc)
							bestSol = getvalue(cc[:x])
						end
					end
					ancienZ = getobjectivevalue(cc)
				end
			end
		end
		delete!(dico,noeud)
	end
	println("Nombre de Noeuds : ")
	println(vraiment)
	return bestZ,bestSol
end

