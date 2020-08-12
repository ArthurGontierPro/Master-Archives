function remplissageArb(filePath)
        flux=open(filePath,"r")
        sep = vcat([c for c in " ?,.()/1234567890#~&{}[]|`%@*=+;:!-_<>'"],['$','"','\t'])
        abr = ArbreMots()
        currentAbr = abr

        while ! eof(flux)                                                                                
            ligne=readline(flux)
            li = split(uppercase(ligne),sep)
            for mot in li
                    i = 1
                    for lettre in mot
	                    if !haskey(currentAbr.suite,uppercase(lettre))
	                        currentAbr.suite[uppercase(lettre)] = ArbreMots()
	                    end
	                    currentAbr = currentAbr.suite[uppercase(lettre)]
	                    if i == length(mot)
	                        currentAbr.terminal = true
	                        currentAbr.nb = currentAbr.nb + 1 
	                    end         
		            i = i + 1
                    end
                    currentAbr = abr
            end
        end
        close(flux)

        return abr
	end
                                                                                                    

function motPresent(abr,mot::String)
    existe = false
    k = 1
    i = 1
    currentAbr = abr
    while !existe && k <= length(mot)
	if isvalid(mot,i)
		lettre = mot[i]
		if haskey(currentAbr.suite,lettre)
		    currentAbr = currentAbr.suite[lettre]
		    if k == length(mot) && currentAbr.terminal == true
		        existe = true
		    end
		end
		k = k + 1
	end
	i = i + 1
    end
    return existe
	end


function ParcoursAbr(arb,taille)
    if isempty(arb.suite) && arb.terminal == true
           nomb = arb.nb
           sum = arb.nb * taille 
    elseif arb.terminal == true
           sum = arb.nb * taille
           nomb = arb.nb
           for l in arb.suite
                n,t = ParcoursAbr(l[2],taille+1)
                sum = sum + t
                nomb = nomb + n
           end
    else  
           sum = 0
           nomb = 0
           for l in arb.suite
                n,t = ParcoursAbr(l[2],taille+1)
                sum = sum + t
                nomb = nomb + n
           end
    end
    return nomb, sum
end


function longMoyenne(arb)
    taille = 0
    n,t = ParcoursAbr(arb,taille)
    if n == 0 
        found = 0
    else 
        found = t / n
    end
    return found
end




function ParcAbrD(arb)
    if isempty(arb.suite) && arb.terminal == true
        n = 1
    elseif arb.terminal == true
        n = 1
        for sousA in arb.suite
            n = n + ParcAbrD(sousA[2])
        end
    else
        n = 0
        for sousA in arb.suite
            n = n + ParcAbrD(sousA[2])
        end
    end
    return n
    end


function NbmotsDistinct(arb)
    n = ParcAbrD(arb)
    return n
    end


function ParcoursDeb(prefixe,arb,liste)
    if isempty(arb.suite) && arb.terminal == true
        append!(liste,[prefixe])
    elseif arb.terminal == true
        for sousA in arb.suite
            append!(liste,[prefixe])
            liste = ParcoursDeb(prefixe*sousA[1],sousA[2],liste)
        end
    else
        for sousA in arb.suite
            liste = ParcoursDeb(prefixe*sousA[1],sousA[2],liste)
        end
    end
    return liste
    end


function ListeMotsDeb(arb,prefixe)
    currentAbr = arb
    i = 1
    possible = true
    deb = prefixe
    while i <= sizeof(prefixe) && possible 
	if isvalid(prefixe,i)
		if !haskey(currentAbr.suite,prefixe[i])
		    possible = false
		else 
		    currentAbr = currentAbr.suite[prefixe[i]]
		end
	end
	i = i + 1
    end
    liste = Array{String,1}
    if possible
        liste = ParcoursDeb(prefixe,currentAbr,[])
    end
    return liste
    end

function testSuffixe(mot,suffixe)
	k = sizeof(mot) # ncodeunits
	i = sizeof(suffixe)
	possible = true
	while k > 0 && possible && i > 0
		if isvalid(suffixe,i) && isvalid(mot,k)
			possible = suffixe[i] == mot[k]
			k = k - 1
			i = i - 1
		elseif isvalid(suffixe,i) || isvalid(mot,k)
			possible = false
		else 
			k = k - 1
			i = i - 1
		end
	end
	return possible
end

function ParcoursFin(arb,mot,suffixe,liste) 
    if isempty(arb.suite) && arb.terminal == true
        if length(suffixe)<=length(mot) && testSuffixe(mot,suffixe)
            append!(liste,[mot])
        end
    elseif arb.terminal == true
        if length(suffixe)<=length(mot) && testSuffixe(mot,suffixe)
            append!(liste,[mot])
        end
        for sousA in arb.suite
            liste = ParcoursFin(sousA[2],mot*sousA[1],suffixe,liste)
        end
    else
        for sousA in arb.suite
            liste = ParcoursFin(sousA[2],mot*sousA[1],suffixe,liste) 
        end
    end
    return liste
end


function ListeMotsFin(arb,suffixe)
    liste = ParcoursFin(arb,"",suffixe,[]) 
    return liste
end


function ParcoursNbLettre(nb,arb,liste,prefixe)
    if arb.terminal == true && nb == 0
        append!(liste,[prefixe])
    end
    if !isempty(arb.suite) && nb > 0
        for sousA in arb.suite
            	liste = ParcoursNbLettre(nb-1,sousA[2],liste,prefixe*sousA[1])
        end
    end

    return liste
    end


function NbMotsAvecNLettres(arb,N)
	liste = ParcoursNbLettre(N,arb,[],"")
	return liste
end



function ParcoursOccur(arb,lettre,nbs)
	somme = 0
    if arb.terminal == true
	somme = somme + nbs * arb.nb
    end
    if !isempty(arb.suite)
        for sousA in arb.suite
		if sousA[1] == lettre
	            somme = somme + ParcoursOccur(sousA[2],lettre,nbs+1)
		else
		    somme = somme + ParcoursOccur(sousA[2],lettre,nbs)
		end
        end
    end
    return somme
    end

function NbOccurLettre(abr,lettre)
	return ParcoursOccur(abr,lettre,0)
end



