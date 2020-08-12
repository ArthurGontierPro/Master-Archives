
#   cd 1julia/Projet/projetRO


#= GONTIER - Arthur 1
#   NOM2 - Prénom 2
#   N'oubliez pas de modifier ce commentaire, ainsi que le nom du fichier!=#

Pkg.add("JuMP")

using JuMP, GLPKMathProgInterface


#= Nombreuses autres fonctions à ajouter
#   .permutations(C::Array{Int,2})ERROR: 
#   .cycles(p::Array{Int,1})
#   .testcycles(c::Array{Array{Int64,1},1})
#   .solveplat(s)
#   .solverelief(s)
#   .approx2opt(s,dep)
#   .script2Opt()
#A utiliser avec les deux scripts : script2Opt() et scriptTSP()=#



# Fonction de résolution exacte du problème de voyageur de commerce, dont le distancier est passé en paramètre

function TSP(C::Array{Int,2})
        m = Model(solver = GLPKSolverMIP())

        n = size(C,1)

        @variable(m, x[1:n,1:n], Bin)

    @objective(m, Min, sum(sum(C[i,j]x[i,j] for j in 1:n) for i in 1:n))

        @constraint(m, sumi[i in 1:n], sum(x[i,j] for j in 1:n if i!=j) == 1)
        @constraint(m, sumj[j in 1:n], sum(x[i,j] for i in 1:n if i!=j) == 1)

    return m
end


#= Fonction qui résout l'ensemble des instances du projet avec la méthode
#de résolution exacte,
#   le temps d'exécution de chacune des instances est mesuré =#

function scriptTSP()
    # Première exécution sur l'exemple pour forcer la compilation si elle n'a pas encore été exécutée
    solveplat("plat/exemple.dat")


    # Série d'exécution avec mesure du temps pour les instances symétriques
    for i in 10:10:150
        file = "plat/plat" * string(i) * ".dat"
        @time solveplat(file)
    end

    # Série d'exécution avec mesure du temps pour les instances asymétriques
    for i in 10:10:150
        file = "relief/relief" * string(i) * ".dat"
        @time solverelief(file)
    end
end

# fonction qui prend en paramètre un fichier contenant un distancier et qui retourne le tableau bidimensionnel correspondant

function parseTSP(nomFichier::String)
    # Ouverture d'un fichier en lecture
    f = open(nomFichier,"r")

    # Lecture de la première ligne pour connaître la taille n du problème
    s = readline(f) # lecture d'une ligne et stockage dans une chaîne de
caractères
    tab = parse.(Int,split(s," ",keep = false)) # Segmentation de la ligne en plusieurs entiers, à stocker dans un tableau (qui ne contient ici qu'un entier)
    n = tab[1]

    # Allocation mémoire pour le distancier
    C = Array{Int,2}(n,n)

    # Lecture du distancier
    for i in 1:n
        s = readline(f)
        tab = parse.(Int,split(s," ",keep = false))ERROR: 
        for j in 1:n
            C[i,j] = tab[j]
        end
    end

    # Fermeture du fichier
    close(f)

    # Retour de la matrice de coûts
    return C
end

# calcule les permutations et les met dans un tableau a une dimention ou chaque indice pointe vers l'indice du noeud qui le suit
function permutations(C::Array{Int,2})
        t = Vector{Int64}(size(C,1))
        for i = 1:size(C,1)
                j = 1
                while C[i,j] != 1
                        j+=1
                end
                t[i] = j
        end
        return t
end
# calcule les cycles des permutation (en détruisant celle-ci au fur a mesure que les cycles sonts créés) et les rangent dans un tableau de cycles (qui sonts dans des tableaux)
function cycles(p::Array{Int,1})
        t = Vector{Vector{Int}}(0)
        i = 1
        j = 1
        while i <= length(p)
                tj = Vector{Int}(0)
                if p[i] > 0
                        dep = i
                        j = p[i]
                        p[i] = -1
                        push!(tj,i)
                        while j != dep
                                push!(tj,j)
                                temp = p[j]
                                p[j] = -1
                                j = temp
                        end
                push!(t,tj)
                end
                i+=1
        end
        return t
end

# cherche et renvoi l'indice du plus petit cycle a partir du tableau des cycles.
function testcycles(c::Array{Array{Int64,1},1})
        min = 10000
        pos = -1
        for i = 1:length(c)
                if length(c[i]) < min
                        min = length(c[i])
                        pos = i
                end
        end
        return pos
end

function solveplat(s)
        # s = "plat/plat50.dat"
    C = parseTSP(s)
    m = TSP(C)
        status = solve(m)# première résolution enautorisant tous les cycles
        p = permutations(Array{Int,2}(getvalue(m[:x])))
        cls = cycles(p)
        ptc = testcycles(cls)
        pc = cls[ptc]# plus petit cycle
        x = m[:x]

        while length(pc) != size(C,1)
                expr = AffExpr()
                exprinv = AffExpr()
                for i = 1:(length(pc)-1)# boucle qui créé la contrainte qui cassera le petit cycle (et son cycle inverse puisaue nous sommes sur du plat)
                        push!(expr,1.0,x[pc[i],pc[i+1]])
                        push!(exprinv,1.0,x[pc[i+1],pc[i]])
                end
                push!(expr,1.0,x[pc[(length(pc))],pc[1]])
                push!(exprinv,1.0,x[pc[1],pc[(length(pc))]])
                cons = @constraint(m,expr <= (length(pc)-1))# ajout de la nouvelle contrainte (x2)
                cons = @constraint(m,exprinv <= (length(pc)-1))
                status = solve(m)# nouvelle résolution
                p = permutations(Array{Int,2}(getvalue(m[:x])))
                cls = cycles(p)
                ptc = testcycles(cls)
                pc = cls[ptc]# nouveau plus petit cycle
        end

        S = "---Moralité--- : "
        if status == :Optimal
                println(S, "Problème résolu à l'optimalité")
                println("z = ",getobjectivevalue(m))
                # println("Solution : ",getvalue(m[:x]))
                # println("Permutations : ",permutations(Array{Int,2}(getvalue(m[:x]))))
                println("Le plus court cycle de ",s," est :
",cycles(permutations(Array{Int,2}(getvalue(m[:x])))))
        elseif status == :Unbounded
                println(S, "Problème non-borné")

        elseif status == :Infeasible
                println(S, "Problème impossible")
        end
end

function solverelief(s)
    C = parseTSP(s)
    m = TSP(C)
        status = solve(m)# première résolution enautorisant tous les cycles
        p = permutations(Array{Int,2}(getvalue(m[:x])))
        cls = cycles(p)
        ptc = testcycles(cls)
        pc = cls[ptc]# plus petit cycle
        x = m[:x]

        while length(pc) != size(C,1)
                expr = AffExpr()
                exprinv = AffExpr()
                for i = 1:(length(pc)-1)# boucle qui créé la contrainte qui cassera le petit cycle
                        push!(expr,1.0,x[pc[i],pc[i+1]])
                end
                push!(expr,1.0,x[pc[(length(pc))],pc[1]])
                cons = @constraint(m,expr <= (length(pc)-1))# ajout de la nouvelle contrainte
                status = solve(m)
                p = permutations(Array{Int,2}(getvalue(m[:x])))
                cls = cycles(p)
                ptc = testcycles(cls)
                pc = cls[ptc]#nouveau plus petit cycle
        end

        S = "---Moralité--- : "
        if status == :Optimal
                println(S, "Problème résolu à l'optimalité")
                println("z = ",getobjectivevalue(m))
                #println("Solution : ",getvalue(m[:x]))
                #println("Permutations : ",permutations(Array{Int,2}(getvalue(m[:x]))))
                println("Le plus court cycle de ",s," est : ",cycles(permutations(Array{Int,2}(getvalue(m[:x])))))
        elseif status == :Unbounded
                println(S, "Problème non-borné")

        elseif status == :Infeasible
                println(S, "Problème impossible")
        end
end

#=Tests=#
solveplat("plat/exemple.dat")
solveplat("plat/plat10.dat")
solveplat("plat/plat20.dat")
solveplat("plat/plat30.dat")
solveplat("plat/plat40.dat")
solveplat("plat/plat50.dat")
solveplat("plat/plat60.dat")
solveplat("plat/plat70.dat")
solveplat("plat/plat80.dat")
solveplat("plat/plat90.dat")
solveplat("plat/plat100.dat")
solveplat("plat/plat110.dat")
solveplat("plat/plat120.dat")
solveplat("plat/plat130.dat")
solveplat("plat/plat140.dat")
@time solveplat("plat/plat150.dat")

solverelief("relief/relief10.dat")
solverelief("relief/relief20.dat")
solverelief("relief/relief30.dat")
solverelief("relief/relief40.dat")
solverelief("relief/relief50.dat")
solverelief("relief/relief60.dat")
solverelief("relief/relief70.dat")
solverelief("relief/relief80.dat")
solverelief("relief/relief90.dat")
solverelief("relief/relief100.dat")
solverelief("relief/relief110.dat")
solverelief("relief/relief120.dat")
solverelief("relief/relief130.dat")
solverelief("relief/relief140.dat")
@time solverelief("relief/relief150.dat")


#scriptTSP()

#Solution approchée avec l'heuristique 2-opt (dep est l'indice de départ, la solution dépendra de sa valeur)
function approx2opt(s,dep)
        #s = "plat/exemple.dat"
    m = parseTSP(s)
        lon = size(m,1)
        #vecteur des valeurs disponibles
        r = Vector{Bool}(lon)
        for i = 1:lon
                r[i] = true
        end
        r[dep]=false
        #méthode des plus proches voisins gloutons
        c = Vector{Int}(lon)
        i = dep
        for cpt = 1:(lon-1)
                min = 10000
                ind = Int
                for j = 1:lon
                        if i != j
                                if r[j]
                                        if m[i,j] <= min
                                                min = m[i,j]
                                                ind = j
                                        end
                                end
                        end
                end
                r[ind] = false
                c[i] = ind
                cpt += 1
                i = ind
        end
        c[i] = dep


        s2 = 0
        for w = 1:lon
                s2 = s2+m[w,c[w]]
        end
        println("Distance Gloutonne = ",s2)
        #println("Cycle des plus proches voisins Gloutons : ",c)

        #heuristique
        delta = -1
        while delta < 0
                delta = 1
                for i = 1:lon
                        j = 1
                        cpt = 1
                        while cpt <= lon && delta >= 0
                                if i!=j && c[i] != j && c[j] != i
                                        if (m[i,j] + m[c[j],c[i]] - m[i,c[i]] - m[j,c[j]]) < 0
                                                delta = m[i,j] + m[c[j],c[i]] - m[i,c[i]] - m[j,c[j]]
                                                k = c[i]
                                                c[i] = j
                                                l = c[k]
                                                c[k] = c[j]
                                                #println("delta = ",delta,"      i:j = ",i,":",j)
                                                while l!=j
                                                        temp = c[l]
                                                        c[l] = k
                                                        k = l
                                                        l = temp
                                                end
                                                c[l] = k
                                        end
                                end
                                j = c[j]
                                cpt += 1
                        end
                end
        end
        #Affichage
        s3 = 0
        for w = 1:lon
                s3 = s3+m[w,c[w]]
        end
        println("Distance = ",s3)
        println("Cycle = ",c)
end

#=Tests=#
approx2opt("plat/exemple.dat",1)
approx2opt("plat/plat10.dat",1)
approx2opt("plat/plat20.dat",1)
approx2opt("plat/plat30.dat",1)
approx2opt("plat/plat40.dat",1)
approx2opt("plat/plat50.dat",1)
approx2opt("plat/plat60.dat",1)
approx2opt("plat/plat70.dat",1)
approx2opt("plat/plat80.dat",1)
approx2opt("plat/plat90.dat",1)
approx2opt("plat/plat100.dat",1)
approx2opt("plat/plat110.dat",1)
approx2opt("plat/plat120.dat",1)
approx2opt("plat/plat130.dat",1)
approx2opt("plat/plat140.dat",1)
@time approx2opt("plat/plat150.dat",1)



function script2Opt()
    # Première exécution sur l'exemple pour forcer la compilation si elle n'a pas encore été exécutée
        println("----Approximation de : plat/exemple.dat")
    approx2opt("plat/exemple.dat")

    # Série d'exécution avec mesure du temps pour les instances symétriques
    for i in 10:10:150
        file = "plat/plat" * string(i) * ".dat"
                println("----Approximation de : ",file)
        @time approx2opt(file,1)
    end
end




script2Opt()
scriptTSP()


