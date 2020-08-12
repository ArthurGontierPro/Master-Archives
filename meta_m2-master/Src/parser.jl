# parse une instance en une struct Instance.
function parseInstance(path)
	println(path)
	#Attribut(s) paint_batch_limit
	paint = CSV.File(path*fnames[2]*suff,delim=';',silencewarnings=true,header=true,ignoreemptylines=true) |> DataFrame
	lim = paint[1,1]
	#Attribut(s) optimization_objectives
	opti = CSV.File(path*fnames[1]*suff,delim=';',silencewarnings=true,header=true,ignoreemptylines=true) |> DataFrame
	nbObj = size(opti,1)
	sortedObj = Vector{String}(undef,nbObj)
	for i in 1:nbObj
		if ((opti[i,2] == "high_priority_level_and_easy_to_satisfy_ratio_constraints")
		|| (opti[i,2] == "high_priority_level_and_difficult_to_satisfy_ratio_constraints"))
			sortedObj[i] = "HPRC"
		elseif opti[i,2] == "paint_color_batches"
			sortedObj[i] = "PBC"
		else
			sortedObj[i] = "LPRC"
		end
	end
	#Attribut(s) ratio
	ratios = CSV.File(path*fnames[3]*suff,delim=';',silencewarnings=true,header=true,ignoreemptylines=true) |> DataFrame
	ratioString = ratios[:,1]
	N = [parse(Int,split(ratios[i,1],'/')[1]) for i in 1:size(ratios,1)]
	P = [parse(Int,split(ratios[i,1],'/')[2]) for i in 1:size(ratios,1)]
	prio = ratios[:,2]
	#Attribut(s) vehicles
	vehi = CSV.File(path*fnames[4]*suff,delim=';',silencewarnings=true,header=true,ignoreemptylines=true) |> DataFrame
	dateJ0=vehi[1,1]
	dday = 0
	for i in 1:size(vehi,1)
		if (vehi[i,1]==dateJ0)
			dday = dday + 1 # numéro de la ligne de changement de dddDDDDDDDDddday
		end
	end
 	J0 = 1:dday # journée j-1-
	J1 = (dday+1):size(vehi,1) # véhicules à séquencer
	colorJ0 = vehi[J0,4]
	colorJ1 = vehi[J1,4]
	if ismissing(vehi[1,end])
		matriceHLJ0 = convert(Matrix,vehi[J0,5:end-1])
		matriceHLJ1 = convert(Matrix,vehi[J1,5:end-1])
	else
		matriceHLJ0 = convert(Matrix,vehi[J0,5:end])
		matriceHLJ1 = convert(Matrix,vehi[J1,5:end])	
	end

	return RawData(lim,nbObj,sortedObj,ratioString,N,P,prio,colorJ0,matriceHLJ0,colorJ1,matriceHLJ1)
end
