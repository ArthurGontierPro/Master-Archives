# --------------------------------------------------------------------------- #
# Loading an instance of SPP (format: OR-library)

function loadSPP2(fname)

# Initialisation
    f=open(fname)
    # lecture du nbre de contraintes (m) et de variables (n)
    m, n = parse.(Int, split(readline(f)) )
    # lecture des n coefficients de la fonction economique et cree le vecteur d'entiers c
    C = parse.(Int, split(readline(f)) )
    # lecture des m contraintes et reconstruction de la matrice binaire A
    A=zeros(Int, m, n)
    # lecture des m contraintes et construction du vecteur de vecteur
    nouillesContr = Vector{Vector{Int}}(m)
    # construction du vecteur de vecteurs des variables
    nouillesVar = Vector{Vector{Int}}(n)

# Construction de A et des nouillesContr
    for i=1:m
        # lecture du nombre d'elements non nuls sur la contrainte i (non utilise)
	k = parse.(Int,readline(f))
        Vec = Vector{Int}(k)
        jj = 1
        # lecture des indices des elements non nuls sur la contrainte i
        for valeur in split(readline(f))
          j = parse.(Int, valeur)
          A[i,j] = 1
          Vec[jj] = j
          jj = jj + 1
        end
        nouillesContr[i] = Vec
        # construction du vecteur de vecteur donnant les contraintes
    end
    close(f)

# Construction des nouillesVar
    for i in 1:size(A,2)
        jj = 1
        V = Vector{Int}(sum(A[:,i]))
        for k in 1:size(A,1)
           if A[k,i]==1
              V[jj] = k
              jj = jj + 1
           end
        end
        nouillesVar[i] = V
    end 
    return C, A, nouillesContr, nouillesVar
end

