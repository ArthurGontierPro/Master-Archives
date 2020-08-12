
#ex généré
nobj = rand(3:9)
nvar = rand(2:20)
nctr = rand(1:30)
C = zeros(Int,nobj,nvar)
A = zeros(Int,nctr,nvar)
b = zeros(Int,nctr)
eq = zeros(Int,nctr)

for i in 1:nvar
	for j in 1:nobj
		if rand(1:3) != 1
			C[j,i] = rand(-9:9)
		end
	end
	for j in 1:nctr
		if rand(1:2) != 1
			A[j,i] = rand(-9:9)
		end
	end
end

for i in 1:nctr
	b[i] = rand(1:20)
	eq[i] = rand(-1:1)
	if eq[i] == 0
		eq[i] = rand(-1:1)
	end
end


println("C[",nobj,",",nvar,"]")
println("A[",nctr,",",nvar,"]")
#println("eq: ",eq)
