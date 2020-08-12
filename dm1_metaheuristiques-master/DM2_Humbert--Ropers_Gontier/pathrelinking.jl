function pathre(s1::Vector{Int},s2::Vector{Int},C::Vector{Int},nouV::Vector{Vector{Int}},nouC::Vector{Vector{Int}})
	nb = size(C,1)
	smax = copy(s1)
	s3 = copy(s1)
	dif = xor.(s1,s2)
	fdif = find(isodd,dif)
	zmax = dot(C,s1)
	zinit = zmax
	i = 0
	while size(fdif,1) > 0 && i<10000
		iswap = rand(1:size(fdif,1))
		s3[fdif[iswap]] = abs(s3[fdif[iswap]]-1)
		if admis(s3,nouV,nouC,fdif[iswap])
			z = dot(C,s3)
			promising = z > zinit
			if promising
				s3 = echangeprofond3(nouV,nouC,copy(C),copy(s3))
				z = dot(C,s3)
			end
			dif = xor.(s3,s2)
			fdif = find(isodd,dif)
			if z > zmax
				zmax = z
				smax = copy(s3)
			end
		else
			s3[fdif[iswap]] = abs(s3[fdif[iswap]]-1)
		end
		i = i + 1
		#print(i," ")
	end
	if i == 10000 println("broken link")end
	return smax
end














