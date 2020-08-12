
#fonction qui verifie l'existence de combinaison linéaire
function verif_combi_lin(A::Matrix,equ_const::Array{Int64},b::Array{Int64})
    println("Verification dépendance linéaire")
    #initialisation matrice resultat
    res_A=Array{Array{Int64,1},1}(undef,0)
    #indice des contraintes d'égalité possiblement redondantes (vide au début)
    ind=Array{Int64}(undef,0)
    egal=false
    #boucle pour rajout ligne contr égal == (parcous equ_const indique contr ==)
    for i in 1:length(equ_const)
        #si equ_const[i]== 0 alors on a une contrainte d'égalité
        if equ_const[i]==0
            #creation ligne coef A + membre b
            ligne=push!(A[i,:],b[i])
            #rajoute ligne dans res
            push!(res_A,ligne)
            #rajout le num contr d'= concernée
            push!(ind,i)
            #il existe une contr =
            egal=true
        end
    end
    println("contrainte à l'égalité : \n indice contraintes: ", ind)
        #suppr dans A et equ_const et b
        sort!(ind, rev=true)
        for i in ind
            A = A[1:size(A,1) .!= i,: ]
            deleteat!(equ_const,i)
            deleteat!(b,i)
        end

    #s'il existe contr d'égalité
    if egal
        #transfo du res en matrix
        res_A=Arr_to_Mat(res_A)
        #ordonne sur la famille libre
        res_A=ordonne(res_A)
        #calcul du rang de res
        rang = rank(res_A)
    else
        #pas de contraintes d'égalité rang nul
        rang = 0
    end
    #si la diff>0 alors il existe contr combinaison linéaire
    for i in 1:size(res_A)[1] - rang
        #suppr contrainte redondante (supprime la dernière ligne)
        println("La contrainte redondante avec second membre: ",  res_A[size(res_A,1),: ])
        res_A = res_A[1:size(res_A,1) .!= size(res_A,1),: ]
    end

    if rang !=0
    #la dernière colonne correspond au second membre
        res_b=res_A[:,size(res_A)[2]]
        #sppr la dernière colonne dans res_A
        res_A = res_A[:, 1:size(res_A,2) .!= size(res_A,2) ]
        #rajoute des contraintes non redondantes parmi les contraintes initiales
        res_A = vcat(A,res_A)
        #rajoute des seconds membres b
        res_b = vcat(b,res_b)
    else
         res_A = A
         res_b = b
    end
    #retour de la matrice A sans les contraintes redondantes avec le vecteur b second membre
    return res_A,res_b
end

#fonction qui ordonne la famille libre à récup
function ordonne(M::Matrix)
    res=Array{Array{Int64,1},1}(undef,0)
    trouve=false
    pivot=0
    c=1
    l=1
    while c <= size(M,2) && pivot < min(size(M,1),size(M,2))
        while l  <= size(M,1) && c <= size(M,2)
            if M[l,c] != 0
                push!(res,M[l,:])
                #suppr contrainte redondante (supprime la ligne l)
                M = M[1:size(M,1) .!= l,: ]
                c=c+1
                l=1
                pivot=pivot+1
            else
                l=l+1
            end
        end
        c=c+1
    end
    for i in 1:size(M,1)
        push!(res,M[i,:])
    end
    res=Arr_to_Mat(res)
    return res
end

#fonction qui transforme un array d'array en matrix
function Arr_to_Mat(tab2D::Array{Array{Int64,1},1})
    res=hcat(tab2D...)
    res=transpose(res)
    res=convert(Matrix,res)
    return res
end


