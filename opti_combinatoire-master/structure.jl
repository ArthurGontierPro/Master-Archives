mutable struct Arbre
	#sonde::Bool
	#Z::Float64
	contr::Int64
	#nomb::Float64
	suite::Dict{Char,Arbre}
	function Arbre()
		return new(0,Dict{Char,Arbre}())
	end
end


