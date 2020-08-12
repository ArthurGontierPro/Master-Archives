# =========================================================================== #

# Using the following packages

@everywhere include("loadSPP2.jl")
@everywhere include("Grasp.jl")
@everywhere include("gloutonrandom.jl")
@everywhere include("echangeprofond3.jl")
@everywhere include("reactiveGrasp.jl")
@everywhere include("getfname.jl")
@everywhere include("pretraitement.jl")
#include("Grasp_graphique.jl")
#include("reactiveGrasp_graphique.jl")
@everywhere include("pathrelinking.jl")
# =========================================================================== #


function ScriptSPP(alpha::Float64,nalpha::Int,timelim::Int,nbiter::Int,Valpha::Vector{Float64})

	#target = "/home/arthur/Bureau/arthur/m1ag/heuristiques/DM1/data"
	#target = "/home/marie/metaheuristiques/dm1_metaheuristiques/data"
    	#target = "/comptes/E152541F/1julia/Heuristiques/dm1_metaheuristiques/data"
	#fnames = getfname(target)
#=fnames = [["pb_1000rnd0300.dat", 661],["pb_1000rnd0700.dat", 2260],["pb_100rnd0500.dat", 639],
	["pb_2000rnd0700.dat", 1811],["pb_200rnd0100.dat", 416],["pb_200rnd0300.dat", 731],
	["pb_200rnd0700.dat", 1004],["pb_200rnd0900.dat", 1324],["pb_500rnd0700.dat",1141],
	["pb_500rnd0900.dat", 2236]]=#

	fnames =  [["pb_100rnd0100.dat", 372],["pb_100rnd0200.dat", 34],["pb_100rnd0300.dat", 203],
		["pb_100rnd0400.dat", 16],["pb_100rnd0500.dat", 639],["pb_100rnd0600.dat", 64],
		["pb_100rnd0700.dat", 503],["pb_100rnd0800.dat", 39],["pb_100rnd0900.dat", 463],
		["pb_100rnd1000.dat", 40],["pb_100rnd1100.dat", 306],["pb_100rnd1200.dat", 23],
		["pb_200rnd0100.dat", 416],["pb_200rnd0200.dat", 32],["pb_200rnd0300.dat", 731],
		["pb_200rnd0400.dat", 64],["pb_200rnd0500.dat", 184],["pb_200rnd0600.dat", 14],
		["pb_200rnd0700.dat", 1004],["pb_200rnd0800.dat", 83],["pb_200rnd0900.dat", 1324],
		["pb_200rnd1000.dat", 118],["pb_200rnd1100.dat", 545],["pb_200rnd1200.dat", 43],
		["pb_200rnd1300.dat", 571],["pb_200rnd1400.dat", 45],["pb_200rnd1500.dat", 926],
		["pb_200rnd1600.dat", 79],["pb_200rnd1700.dat", 255],["pb_200rnd1800.dat", 19],
		["pb_500rnd0100.dat", 323],["pb_500rnd0200.dat", 25],["pb_500rnd0300.dat", 776],
		["pb_500rnd0400.dat", 62],["pb_500rnd0500.dat", 122],["pb_500rnd0600.dat", 8],
		["pb_500rnd0700.dat", 1141],["pb_500rnd0800.dat", 89],["pb_500rnd0900.dat", 2236],
		["pb_500rnd1000.dat", 179],["pb_500rnd1100.dat", 424],["pb_500rnd1200.dat", 33],
		["pb_500rnd1300.dat", 474],["pb_500rnd1400.dat", 38],["pb_500rnd1500.dat", 1196],
		["pb_500rnd1600.dat", 88],["pb_500rnd1700.dat", 192],["pb_500rnd1800.dat", 13],
		["pb_1000rnd0100.dat", 67],["pb_1000rnd0200.dat", 4],["pb_1000rnd0300.dat", 661],
		["pb_1000rnd0400.dat", 48],["pb_1000rnd0500.dat", 222],["pb_1000rnd0600.dat", 15],
		["pb_1000rnd0700.dat", 2260],["pb_1000rnd0800.dat", 175],["pb_2000rnd0100.dat", 40],
		["pb_2000rnd0200.dat", 2],["pb_2000rnd0300.dat", 478],["pb_2000rnd0400.dat", 32],
		["pb_2000rnd0500.dat", 140],["pb_2000rnd0600.dat", 9],["pb_2000rnd0700.dat", 1811],
		["pb_2000rnd0800.dat", 135]]

	for i in 1:size(fnames,1)
		name_file = string("data/",fnames[i][1])
        
		println("")
		println("  ",name_file)
		println("")

		C,A,nouillescontr,nouillesvar = loadSPP2(name_file)

		#sol,z = Grasp(copy(C),copy(nouillesvar),copy(nouillescontr),alpha,timelim)
		#sol=reactiveGrasp(copy(C),copy(nouillesvar),copy(nouillescontr),nalpha,timelim,Valpha)
		#sol3 = sol[1]
	
		solut = @parallel append! for j in 1:2
		reactiveGrasp(copy(C),copy(nouillesvar),copy(nouillescontr),nalpha,timelim,Valpha)
		end
		
		sol3 = pathre(solut[1],solut[2],copy(C),nouillesvar,nouillescontr)
		z3 = dot(C,sol3)
		z1 = dot(C,solut[1])
		z2 = dot(C,solut[2])
		if z3 > z1 && z3 > z2
			println("AMELIORATON !")
		end	
		println("| z1 : ",z1," | z2 : ",z2," | z3 : ",z3)

		println("accuracy: ",round(z3/fnames[i][2]*100,2),"%")

		#zinit,zls,zbest=Graspgraphique(copy(C),copy(nouillesvar),copy(nouillescontr),alpha,nbiter)
		#plotRunGrasp(string("Grasp : $(fnames[i][1])"), zinit, zls, zbest)
		#zinit,zls,zbest,palpha,zmax=reactiveGraspgraphique(copy(C),copy(nouillesvar),copy(nouillescontr),nalpha,nbiter,Valpha)
		#plotRunGrasp(string("reactiveGrasp : $(fnames[i][1])"), zinit, zls, zbest)
		#println("alpha dominant : ",Valpha[indmax(palpha)])
		#println("accuracy: ",round(zmax/fnames[i][2]*100,2),"%")

		#plotpalpha(Valpha,palpha)

	end
end

ScriptSPP(0.5,3,3,50,[0.35,0.5,0.65,0.8,0.95])








