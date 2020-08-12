function remplissagetab(filePath::String)
    motss = sort!(pretraitement(filePath))

	tab = TableauMots()
	nb = size(motss,1)

	tab.decompte = zeros(UInt64,nb)
	tab.mots = fill(" ",nb)

	j = 1
	tab.mots[j] = motss[j]
	tab.decompte[j] = 1

	for i in 2:nb
		if tab.mots[j] != motss[i]
			j = j + 1
			tab.mots[j] = motss[i]
		end
		tab.decompte[j] = tab.decompte[j] + 1	
	end
	if tab.mots[1] == ""
		tab.mots = tab.mots[2:j]
		tab.decompte = tab.decompte[2:j]
	else 
		tab.mots = tab.mots[1:j]
		tab.decompte = tab.decompte[1:j]
	end
	tab.nbMots = sum(tab.decompte)
	tab.nbMotsDistincts = size(tab.decompte,1)
	return tab
end



function recpre(tab::TableauMots,e::String,deb,fin)
	i = deb + div(fin-deb,2)
	if tab.mots[i] == e
		return true
	elseif e < tab.mots[i] && deb<i
		return recpre(tab,e,deb,i-1)
	elseif tab.mots[i] < e && i<fin
		return recpre(tab,e,i+1,fin)
	else
		return false
	end
end

function motPresent(tab::TableauMots,e::String)
	return recpre(tab,e,1,size(tab.decompte,1))
end



function longMoyenne(tab::TableauMots)
	nb = size(tab.decompte,1)
	sum = 0
	nb2 = 0
	for i in 1:nb
		sum = sum + tab.decompte[i]*length(tab.mots[i])
		nb2 = nb2 + tab.decompte[i]
	end
	return sum/nb2
end


function NbmotsDistinct(tab::TableauMots)
    return tab.nbMotsDistincts
end


function testPrefixe(mot,prefixe)
	k = 1 
	i = 1
	possible = true
	while possible && i <= sizeof(prefixe)
		if isvalid(prefixe,i) && isvalid(mot,k)
			possible = prefixe[i] == mot[k]
			k = k + 1
			i = i + 1
		elseif isvalid(prefixe,i) || isvalid(mot,k)
			possible = false
		else 
			k = k + 1
			i = i + 1
		end
	end
	return possible
end


function RecupIndice(tab::TableauMots,prefixe::String,deb,fin)
	i = deb + div(fin-deb,2)
	if tab.mots[i] == prefixe
		return i
	elseif prefixe < tab.mots[i] && deb<i
		return RecupIndice(tab,prefixe,deb,i)
	elseif tab.mots[i] < prefixe && i<fin
		return RecupIndice(tab,prefixe,i+1,fin)
	elseif sizeof(prefixe) <= sizeof(tab.mots[i]) && testPrefixe(tab.mots[i],prefixe)
		return i
	else
		return 0
	end
end



function ListeMotsDeb(tab::TableauMots,prefixe::String)
	f = RecupIndice(tab::TableauMots,prefixe,1,size(tab.decompte,1))
	if f != 0
		d = f
		while d <= size(tab.decompte,1) && testPrefixe(tab.mots[d],prefixe)
			d = d + 1
		end
		return tab.mots[f:d-1]
	else 
		return []
	end
end




function testSuffixe(mot,suffixe)
	k = sizeof(mot) 
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


function ListeMotsFin(tab::TableauMots,suffixe)
	liste = []
	for k in 1:size(tab.mots,1)
		if testSuffixe(tab.mots[k],suffixe) && length(tab.mots[k]) >= length(suffixe)
			append!(liste,[tab.mots[k]])
		end	
	end
	return liste
end




function NbMotsAvecNLettres(tab::TableauMots,N)
	liste = []
	for k in 1:size(tab.mots,1)
		if length(tab.mots[k]) == N
			append!(liste,[tab.mots[k]])
		end
	end
	return liste
end




function NbOccurLettre(tab::TableauMots,lettre::Char)
	nb = 0
	for k in 1:size(tab.mots,1)
		for j in 1:sizeof(tab.mots[k]) 
			if isvalid(tab.mots[k],j) && (tab.mots[k])[j] == lettre
				nb = nb + tab.decompte[k]
			end
		end
	end
	return nb
end

