
#include("structures.jl")
include("prefixes_abr.jl")
include("prefixes_tab.jl")


function pretraitement(filePath)
    words = Vector{String}(undef,0)
    flux=open(filePath,"r")
    while ! eof(flux)
        ligne=readline(flux)
        append!(words,split(uppercase(ligne),vcat([c for c in " ?,.()/1234567890#~&{}[]|`%@*=+;:!-_<>'"],['$','"','\t'])))
    end
    close(flux)
    return words
end


                                                                                               

function main(fichier::String,numFonction::Int,mot = "TARTE",Nb = 3,lettre = 'Â')

    println("Pour le texte : "*fichier)
    println()
    println("Remplissage de l'arbre")
    	@time arb = remplissageArb(fichier)
    println("Remplissage du tableau")
    	@time tab = remplissagetab(fichier)
    println()
    println()



    if numFonction == 1
        println("Recherche d'un mot présents dans l'arbre :" * mot)
	    @time  for i in 1:1000 motPresent(arb,mot) end
        println(motPresent(arb,mot))
        println("Recherche d'un mot présents dans le tableau :" * mot)
	    @time for i in 1:1000 motPresent(tab,mot) end
        println(motPresent(tab,mot))

    elseif numFonction == 2
        println("Recherche de la longueur moyenne des mots dans l'arbre")
        	@time for i in 1:1000 longMoyenne(arb) end
        println("Moyenne :",longMoyenne(arb))
        println("Recherche de la longueur moyenne des mots dans le tableau")
       	@time for i in 1:1000 longMoyenne(tab) end
        println("Moyenne : ",longMoyenne(tab))

    elseif numFonction == 3
        println("Nombre de mots distincts dans l'arbre")
       	@time for i in 1:1000 NbmotsDistinct(arb) end
        println("Nb : ",NbmotsDistinct(arb))
        println("Nombre de mots distincts dans le tableau")
        	@time for i in 1:1000 NbmotsDistinct(tab) end
        println("Nb : ",NbmotsDistinct(tab))


    elseif numFonction == 4
        prefixe = mot
        println("Liste de Mots commençant par (arbre): "*prefixe)
        println(ListeMotsDeb(arb,prefixe))
     	@time for i in 1:1000 ListeMotsDeb(arb,prefixe) end
        println("Liste de Mots commençant par (tab): "*prefixe)
        println(ListeMotsDeb(tab,prefixe))
     	@time for i in 1:1000 ListeMotsDeb(tab,prefixe) end


    elseif numFonction == 5
        suffixe = mot
        println("Liste de Mots finissant par (arbre): "*suffixe)
        println(ListeMotsFin(arb,suffixe))
     	@time for i in 1:1000 ListeMotsFin(arb,suffixe) end
        println("Liste de Mots finissant par (tab): "*suffixe)
        println(ListeMotsFin(tab,suffixe))
     	@time for i in 1:1000 ListeMotsFin(tab,suffixe) end

    elseif numFonction == 6
        println("Liste de Mots de taille (arbre): $(Nb)")
        println(NbMotsAvecNLettres(arb,Nb))
     	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
        println("Liste de Mots de taille (tab): $(Nb)")
        println(NbMotsAvecNLettres(tab,Nb))
     	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    elseif numFonction == 7
        println("Nombre d'occurences de la lettre (arbre): "*lettre)
        println(NbOccurLettre(arb,lettre))
     	@time for i in 1:1000 NbOccurLettre(arb,lettre) end
        println("Nombre d'occurences de la lettre (tab): "*lettre)
        println(NbOccurLettre(tab,lettre))
     	@time for i in 1:1000 NbOccurLettre(tab,lettre) end

    else 
        println("Seulement 7 fonctions de disponible alors choisissez un nombre entre 1 et 8 !")
    end
    
end
main("data/cyrano.txt",1)







