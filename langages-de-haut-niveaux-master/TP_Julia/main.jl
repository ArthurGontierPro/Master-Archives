
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




function main(fichier::String)

    println("Pour le texte : "*fichier)
    println()
    println("Remplissage de l'arbre")
    	@time arb = remplissageArb(fichier)
    println("Remplissage du tableau")
    	@time tab = remplissagetab(fichier)
    println()
    println()


    mot = "À"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    mot = "FÊTE"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    mot = "OMBRE"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    mot = "FÊTES"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    mot = "DOULEUR"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    mot = "TARTELETTE"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    mot = "TENTATIVES"
    println("Recherche d'un mot présents dans l'arbre :" * mot)
	@time  for i in 1:1000 motPresent(arb,mot) end
    println(motPresent(arb,mot))
    println("Recherche d'un mot présents dans le tableau :" * mot)
	@time for i in 1:1000 motPresent(tab,mot) end
    println(motPresent(tab,mot))

    println()
    println("Recherche de la longueur moyenne des mots dans l'arbre")
    	@time for i in 1:1000 longMoyenne(arb) end
    println("Moyenne :",longMoyenne(arb))
    println("Recherche de la longueur moyenne des mots dans le tableau")
   	@time for i in 1:1000 longMoyenne(tab) end
    println("Moyenne : ",longMoyenne(tab))
    println()


    println("Nombre de mots distincts dans l'arbre")
   	@time for i in 1:1000 NbmotsDistinct(arb) end
    println("Nb : ",NbmotsDistinct(arb))
    println("Nombre de mots distincts dans le tableau")
    	@time for i in 1:1000 NbmotsDistinct(tab) end
    println("Nb : ",NbmotsDistinct(tab))
    println()


    prefixe = "L" 
    println("Liste de Mots commençant par (arbre): "*prefixe)
    println(ListeMotsDeb(arb,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(arb,prefixe) end
    println("Liste de Mots commençant par (tab): "*prefixe)
    println(ListeMotsDeb(tab,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(tab,prefixe) end
    println()

    prefixe = "ÂM" 
    println("Liste de Mots commençant par (arbre): "*prefixe)
    println(ListeMotsDeb(arb,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(arb,prefixe) end
    println("Liste de Mots commençant par (tab): "*prefixe)
    println(ListeMotsDeb(tab,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(tab,prefixe) end
    println()

    prefixe = "FON" 
    println("Liste de Mots commençant par (arbre): "*prefixe)
    println(ListeMotsDeb(arb,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(arb,prefixe) end
    println("Liste de Mots commençant par (tab): "*prefixe)
    println(ListeMotsDeb(tab,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(tab,prefixe) end
    println()

    prefixe = "REPRÉSENT" 
    println("Liste de Mots commençant par (arbre): "*prefixe)
    println(ListeMotsDeb(arb,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(arb,prefixe) end
    println("Liste de Mots commençant par (tab): "*prefixe)
    println(ListeMotsDeb(tab,prefixe))
 	@time for i in 1:1000 ListeMotsDeb(tab,prefixe) end
    println()


    suffixe = "LETTE"
    println("Liste de Mots finissant par (arbre): "*suffixe)
    println(ListeMotsFin(arb,suffixe))
 	@time for i in 1:1000 ListeMotsFin(arb,suffixe) end
    println("Liste de Mots finissant par (tab): "*suffixe)
    println(ListeMotsFin(tab,suffixe))
 	@time for i in 1:1000 ListeMotsFin(tab,suffixe) end

    suffixe = "AL"
    println("Liste de Mots finissant par (arbre): "*suffixe)
    println(ListeMotsFin(arb,suffixe))
 	@time for i in 1:1000 ListeMotsFin(arb,suffixe) end
    println("Liste de Mots finissant par (tab): "*suffixe)
    println(ListeMotsFin(tab,suffixe))
 	@time for i in 1:1000 ListeMotsFin(tab,suffixe) end

    suffixe = "S"
    println("Liste de Mots finissant par (arbre): "*suffixe)
    println(ListeMotsFin(arb,suffixe))
 	@time for i in 1:1000 ListeMotsFin(arb,suffixe) end
    println("Liste de Mots finissant par (tab): "*suffixe)
    println(ListeMotsFin(tab,suffixe))
 	@time for i in 1:1000 ListeMotsFin(tab,suffixe) end

    suffixe = "Q"
    println("Liste de Mots finissant par (arbre): "*suffixe)
    println(ListeMotsFin(arb,suffixe))
 	@time for i in 1:1000 ListeMotsFin(arb,suffixe) end
    println("Liste de Mots finissant par (tab): "*suffixe)
    println(ListeMotsFin(tab,suffixe))
 	@time for i in 1:1000 ListeMotsFin(tab,suffixe) end

    Nb = 2
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    Nb = 3
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    Nb = 4
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    Nb = 6
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    Nb = 8
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    Nb = 10
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end

    Nb = 15
    println("Liste de Mots de taille (arbre): $(Nb)")
    println(NbMotsAvecNLettres(arb,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(arb,Nb) end
    println("Liste de Mots de taille (tab): $(Nb)")
    println(NbMotsAvecNLettres(tab,Nb))
 	@time for i in 1:1000 NbMotsAvecNLettres(tab,Nb) end


    lettre = 'Â'
    println("Nombre d'occurences de la lettre (arbre): "*lettre)
    println(NbOccurLettre(arb,lettre))
 	@time for i in 1:1000 NbOccurLettre(arb,lettre) end
    println("Nombre d'occurences de la lettre (tab): "*lettre)
    println(NbOccurLettre(tab,lettre))
 	@time for i in 1:1000 NbOccurLettre(tab,lettre) end


    lettre = 'E'
    println("Nombre d'occurences de la lettre (arbre): "*lettre)
    println(NbOccurLettre(arb,lettre))
 	@time for i in 1:1000 NbOccurLettre(arb,lettre) end
    println("Nombre d'occurences de la lettre (tab): "*lettre)
    println(NbOccurLettre(tab,lettre))
 	@time for i in 1:1000 NbOccurLettre(tab,lettre) end


    lettre = 'X'
    println("Nombre d'occurences de la lettre (arbre): "*lettre)
    println(NbOccurLettre(arb,lettre))
 	@time for i in 1:1000 NbOccurLettre(arb,lettre) end
    println("Nombre d'occurences de la lettre (tab): "*lettre)
    println(NbOccurLettre(tab,lettre))
 	@time for i in 1:1000 NbOccurLettre(tab,lettre) end



end
main("data/cyrano.txt")







