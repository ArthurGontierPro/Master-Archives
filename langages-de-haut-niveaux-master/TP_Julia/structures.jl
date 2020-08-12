# Deux types de structures de données ( à lancer uniquement lors du premier appel dans le terminal)

mutable struct TableauMots
	nbMots::UInt64 # nombre total de mots
	nbMotsDistincts::UInt64 # nombre de mots différents les uns des autres
	mots::Array{String}
	decompte::Array{UInt64}
	function TableauMots()
		return new(0,0,Array{String,1}(),Array{UInt64,1}())
	end
end


mutable struct ArbreMots
	terminal::Bool
	nb::Int64
	suite::Dict{Char,ArbreMots}
	function ArbreMots()
		return new(false,0,Dict{Char,ArbreMots}())
	end
end
