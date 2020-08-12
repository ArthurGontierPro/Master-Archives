include("Src/include.jl")
############################################################
# Shortcut (CF Src/Tools.jl) => Accès l'instance 1 (.,1) du set A (1,.)

# Lance la résolution de la méthode epsilon contrainte sur une instance
function runeps2obj(set,ins;coupe=false,verbose=false,timelim=600,gaplim=0.00,solP = false,obj=1)

	Data = parseInstance(instance_shortcut(set,ins))

	if verbose println(Data) end

	carj0,carj,cpmt,colr,Inst = extract(Data)
	println("#Cars(J-1)	= ",carj0,"\n","#Cars(J) 	= ",carj,"\n","#Cpmt		= ",cpmt,"\n","#Color		= ",colr)

	if coupe Inst = coupeEtExtract(nb,Data) end

	epsConstraint(solver,Data,Inst,timelim,gaplim,solP,verbose,obj)
end

#runeps2obj(2,18,verbose = false,timelim =6000)


# Lance la résolution de la méthode de Kirlik et Sayin sur une instance
function rune3o(set,ins;double=true,verbose=false,timelim=600,gaplim=0.00,solP = false)

	Data = parseInstance(instance_shortcut(set,ins))

	if verbose println(Data) end

	carj0,carj,cpmt,colr,Inst = extract(Data)
	println("#Cars(J-1)	= ",carj0,"\n","#Cars(J) 	= ",carj,"\n","#Cpmt		= ",cpmt,"\n","#Color		= ",colr)

	if !double KetS(solver,Data,Inst,timelim,gaplim,solP,verbose)
	else KetSdouble(solver,Data,Inst,timelim,gaplim,solP,verbose)
	end
end
#rune3o(2,17,timelim =6000)


# fonction qui met en place la résolution d'une instance
function main(set,ins;coupe=false,nb=200,port=false,verbose=false,timelim=600,gaplim=0.00,solP = false)

	Data = parseInstance(instance_shortcut(set,ins))

	if verbose println(Data) end

	carj0,carj,cpmt,colr,Inst = extract(Data)
	println("#Cars(J-1)	= ",carj0,"\n","#Cars(J) 	= ",carj,"\n","#Cpmt		= ",cpmt,"\n","#Color		= ",colr)


	if coupe Inst = coupeEtExtract(nb,Data) end


	# Choix du modèle
	mt = model(solver,Inst,timelim,gaplim)
	#mt = modelz3only(solver,Inst,1000,gaplim)

	@time optimize!(mt)
	println(termination_status(mt))
	#printres(mt,Data,Inst)

	if termination_status(mt)==MOI.OPTIMAL
		if verbose printres(mt,Data,Inst) end
	end

	if port println("\n\n\nModele Portugais")
		mp = modelPortugais(solver,Inst,timelim)
		optimize!(mp)
		println(termination_status(mp))
		if termination_status(mp)==MOI.OPTIMAL
			if verbose printres(mp) end
		end
	end
end

#main(2,25,verbose = true,solP = true,timelim =6000)
#main(3,19,gaplim=0.90)
#main(2,6,false,0,false,false,10)
#main(1,3)


# Lance la résolution de toutes les instances
function runall(;manual_rem=true,timelim=600,gaplim=0.00)
	open("results.txt","w") do f
		for set in 1:3
			if set == 1 nbins=16 elseif set==2 nbins=45 else nbins=19 end
			for ins in 1:nbins
				print(ins,":")
				if manual_rem && (set==1&&ins==3 || set==1&&ins==4 || set==1&&ins==5 || set==1&&ins==6 || set==1&&ins==7 || set==1&&ins==8 || set==1&&ins==9 || set==1&&ins==10 || set==1&&ins==11 || set==1&&ins==12 || set==1&&ins==13 || set==1&&ins==15 || set==2&&ins==2 || set==2&&ins==3 || set==2&&ins==4 || set==2&&ins==5 || set==2&&ins==12 || set==2&&ins==13 || set==2&&ins==14 || set==2&&ins==15 || set==2&&ins==16)
					write(f,string(ins,":",instance_shortcut(set,ins),"\n            MANUALY REMOVED\n\n"))
				else
					write(f,string(ins,":",instance_shortcut(set,ins),"\n"))
					Data = parseInstance(instance_shortcut(set,ins))
					carj0,carj,cpmt,colr,Inst = extract(Data)
					write(f,string("#Cars(J-1)	= ",carj0,"\n","#Cars(J) 	= ",carj,"\n","#Cpmt		= ",cpmt,"\n","#Color		= ",colr,"\n"))
					mt = model(solver,Inst,timelim,gaplim)
					optimize!(mt)
					if termination_status(mt)==MOI.OPTIMAL
						write(f,"            OPTIMAL\n\n")
					else
						write(f,"            TIME OUT\n\n")
					end
				end
			end
		end
	end
end
#runall(manual_rem=false,timelim=3600)


# Lance une résolution sur une instance dont le nombre de voitures à été réduit
function runcoupe(set,ins;timelim=600,gaplim=0.00)
	Data = parseInstance(instance_shortcut(set,ins))

	carj0,carj,cpmt,colr,Inst = extract(Data)

	println("Instance complète : ")
	println("#Cars(J-1)	= ",carj0,"\n","#Cars(J) 	= ",carj,"\n","#Cpmt		= ",cpmt,"\n","#Color		= ",colr)

	nb = 20
	timout = 0
	open("resultscoupe.txt","w") do f
		write(f,string(instance_shortcut(set,ins),"\n"))
		while timout < 2
			write(f,string("Coupe à ",nb," voitures\n"))
			Inst = coupeEtExtract(nb,Data)
			mt = model(solver,Inst,timelim,gaplim)

			optimize!(mt)
			println(termination_status(mt))
			if termination_status(mt)==MOI.OPTIMAL
				write(f,"            OPTIMAL\n\n")
			elseif termination_status(mt)==MOI.INFEASIBLE_OR_UNBOUNDED
				write(f,"            INFEASIBLE_OR_UNBOUNDED\n\n")
			else
				write(f,"            TIME OUT\n\n")
				timout=timout+1
			end
			nb = nb + 10
		end
	end
end
#runcoupe(1,1)


# Test d'admissibilité de la solution d'un autre groupe
if false
	seq=[71,17,15,14,20,21,22,56,26,29,28,30,31,34,33,35,36,37,38,40,43,42,44,45,46,48,49,75,58,51,52,53,55,24,74,59,64,63,16,62,72,68,66,61,18,65,67,73,60,50,76,69,77,25,32,39,47,54,57,70,78,23,27,41,19]
	seq = map(s->s-minimum(seq)+1,seq);println(seq)
	#testseq(seq,3,6)

	################################################
	Data = parseInstance(instance_shortcut(3,6))
	carj0,carj,cpmt,colr,Inst = extract(Data)
	timelim = 600; gaplim=0.0;
	mt = model(solver,Inst,timelim,gaplim)
	mangeSolution("Seq/unknown_seq.txt",Data,Inst,mt)
	optimize!(mt)
	print(Int.(value.(mt[:w])))
	################################################
	isadmissible(3,6,0,3,0,solver)
	isadmissible(3,10,9,5,9,solver)
end
