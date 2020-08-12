using JuMP, GLPK, MathOptInterface, GLPKMathProgInterface, LinearAlgebra, Gurobi#, Profile#, MathProgBase, Clp
include("pretraitement.jl")#prétraitement de Sanji
include("p1.jl")
include("p2.jl")
include("p3.jl")
include("p3sorted.jl")
include("p3test.jl")

include("parsermop.jl")

include("data/EHRGOTT.jl")

const GUROBI_ENV = Gurobi.Env()

function completion(eq)
	global nbneq = nbctr - length(findall(!isodd,eq))

	I = zeros(Int,nbctr,nbneq)
	global i = 1
	for j in 1:nbctr
		if eq[j] != 0
			I[j,i] = eq[j]
			global i = i + 1
		end
	end
	return I,zeros(Int,nbobj,nbneq)
end

function ms(test,verbose)

	global A,b = verif_combi_lin(A,copy(eq),b)

	global nbvar = size(A,2) # nb de variables
	global nbctr = size(A,1) # nb de contraintes
	global nbobj = size(C,1) # nb d' objectifs

	solver = Gurobi.Optimizer

	println("-P1-")
	x0 = p1(C,A,b,eq,solver)
	println("X0 = ",x0)

if x0 != "the MOLP is infeasible"
	println("-P2-")
	B1 = p2(C,A,b,eq,x0,solver)
	println("First basis : ",B1)

if B1 != "Xe = ens vide"
	println("-P3-")
	I,O = completion(eq)
	A3 = hcat(A,I)
	C3 = hcat(C,O)
	global L,Lx = @time p3(solver,C3,A3,b,B1,verbose)
	
	println("")
	if test
		#Ls,Lxs = @time p3test(C,A,b,B1)
		Ls,Lxs = @time p3sorted(C,A,b,B1)

		println("")
		println("")

		same = true
		for i in 1:length(Ls)	
			same = same && isin(L,Ls[i])
		end
		for i in 1:length(L)	
			same = same && isin(Ls,L[i])
		end
		println(" sames : ",same)
		println("Bases test : ",Ls)
		println("Sol associées : ",Lxs,"\n")
	end
	println(size(L,1)," Bases : ",L)#,unique(L)," size : ",size(L,1),", singular : ",size(findall(x->x==[0],L),1),", unique : ",size(unique(L),1))

	if verbose println("Sol associées : ",Lx) end
end
end
end



function main(a=-1,verbose=false,test=false)
	if a == 0
		for i in 1:100 
			println("-----exemple généré-----");include(string("generator.jl"));ms(test,verbose)
		end
	elseif a > length(data) || a < 0
		for i in 1:length(data)
			println("-----",data[i],"-----")
			include(string("data/",data[i],".jl"))
			ms(test,verbose);println("\n")
		end
		println("-----",data[1],"-----");include(string("data/",data[1],".jl"));ms(test,verbose)
	else
		println("-----",data[a],"-----");include(string("data/",data[a],".jl"));ms(test,verbose)
	end
end


println("Choisissez un exemple ou 0 pour un exemple généré")

data = ["EHRGOTT", "ZELENY8-3", "ZELENY8-18", "ZELENY244", "TD2-1", "TD2-2", "PIF","STEUER481", "STEUER482","molp_19_376_1917_entropy","molp_10_779_10174_entropy","molp_21_31_138_entropy"]


#=
include("data/EHRGOTT.jl");ms()
include("data/STEUER481.jl");ms()
include("data/STEUER482.jl");ms()
include("data/ZELENY8-3.jl");ms()
include("data/ZELENY8-18.jl");ms()
include("data/ZELENY244.jl");ms()
include("data/PIF.jl")
include("data/TD2-1.jl")
include("data/TD2-2.jl")
=#

