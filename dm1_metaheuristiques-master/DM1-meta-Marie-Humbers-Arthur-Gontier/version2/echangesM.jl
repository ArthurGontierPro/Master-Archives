function echangesM_Random(C,A,sol)
	



	return sol
end


function echangesM_Smart(C,A,sol)
	



	return sol
end

function simpleDescente(C,A,sol)
	# Simple Descente
	ameliore = true
	while ameliore == true
		voisin = echangesM(C,A,sol)
		if dot(C,sol) >= dot(C,voisin)
			ameliore = false
		else 
			sol = voisin
		end
	end
	return sol
end
