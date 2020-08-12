# fonction Kirlik et Sayin
function KetS(solver,Data,Inst,timelim,gaplim,solP,verbose)
	mt,n,F,rH,rL,d,s = modelKetS(solver,Inst,timelim,gaplim)
	mini = makemini(F,d,s)
	YI = [0,0]
	YN = [50000,50000]
	L = [(YN[1],YN[2])]
	nb=0
	while size(L,1)>0
		r,L = getrect!(L,YI)
		fix(mt[:const_terml], r[1] - 1)
		fix(mt[:const_termf], r[2] - 1)
		optimize!(mt)
		if termination_status(mt)==MOI.OPTIMAL
			ph = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rH)
			pf = sum(sum(round(Int64,value(mt[:w][f,i])) for i in 1:n) for f in F)
			pl = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rL)
			println("Solution (EP,RAF,ENP) : (",ph,",",pf,",",pl,")") 
			L = makerect!(L,r,pf,pl,YI)
			nb = nb + 1
		end
	end
	println("La résolution se termine avec ",nb," solutions, en comptant les faiblement efficaces")

end

# fonction Kirlik et Sayin en double résolution pour éviter les faiblement efficaces
function KetSdouble(solver,Data,Inst,timelim,gaplim,solP,verbose)
	mt,n,F,rH,rL,d,s = modelKetS(solver,Inst,timelim,gaplim)
	md,n,F,rH,rL,d,s = modelKetSdouble(solver,Inst,timelim,gaplim)
	YI = [0,0]
	YN = [50000,50000]
	L = [(YN[1],YN[2])]
	nb=0
	mini = makemini(F,d,s)

	while size(L,1)>0
		r,L = getrect!(L,YI)
		fix(mt[:const_terml], r[1] - 1)
		fix(mt[:const_termf], r[2] - 1)
		fix(md[:const_terml], r[1] - 1)
		fix(md[:const_termf], r[2] - 1)
		optimize!(mt)
		if termination_status(mt)==MOI.OPTIMAL
			ph = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rH)
			pf = sum(sum(round(Int64,value(mt[:w][f,i])) for i in 1:n) for f in F)
			pl = sum(sum(round(Int64,value(mt[:g][c,i])) for i in 1:n) for c in rL)
			println("Première solution : (",ph,",",pf,",",pl,")") 
			fix(md[:const_termh], ph)
			optimize!(md)
			if termination_status(mt)==MOI.OPTIMAL
				ph = sum(sum(round(Int64,value(md[:g][c,i])) for i in 1:n) for c in rH)
				pf = sum(sum(round(Int64,value(md[:w][f,i])) for i in 1:n) for f in F)
				pl = sum(sum(round(Int64,value(md[:g][c,i])) for i in 1:n) for c in rL)
				println("Solution double (EP,RAF,ENP) : (",ph,",",pf,",",pl,")") 
			end
			L = makerect!(L,r,pf,pl,YI)
			nb = nb + 1
		end
	end
	println("La résolution se termine avec ",nb," solutions, en enlevant les faiblement efficaces")

end


