
using JuMP, GLPKMathProgInterface

function MCP(solverSelected,h::Vector{Int},C::Vector{Vector{Int}},jmax::Int,p::Int,H)
	m = Model(solver = solverSelected)
	nb = size(H,1)

	@variable(m,x[1:jmax] >= 0,Bin)
	@variable(m,s[1:nb] >= 0 , Bin)

	@objective(m,Max,sum(s[i]*h[i] for i in 1:nb))

	@constraint(m,couv[i = 1:nb], sum(x[j] for j in C[i])-s[i] >= 0)
	@constraint(m,pmax, sum(x[j] for j in 1:jmax) <= p)
	return m
end

function parser(fname)
	f = open(fname)
	p,jmax = parse.(Int, split(readline(f)))
	H = parse.(Int, split(readline(f)))
	nb = size(H,1)
	C = Vector{Vector{Int}}(undef,nb)    
	for i=1:nb
		k = parse.(Int,readline(f))
		Vec = Vector{Int}(undef,k)
		jj = 1
		for valeur in split(readline(f))
			j = parse.(Int, valeur)
			Vec[jj] = j
			jj = jj + 1
		end
		C[i] = Vec
	end
	close(f)
	return H,C,p,jmax
end

#= Instance de test
H = [13,25,45,10,78,22,50]
C = [[1,2],[1],[2,3],[3,4],[5]]
p = 3
jmax = 6
=#


