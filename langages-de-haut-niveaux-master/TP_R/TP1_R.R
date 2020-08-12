## TP1 Langage de programmation de haut-niveau
f <- function(t){t*t + t + 1}

# Méthode des rectangles
# Avec boucles
rectangle <- function (f,a,b,n) {
  S = 0
  for (i in 1:n) {
    S = S + f(a+i*(b-a)/n)*(b-a)/n
  }
  S
}

n = 1
while (n < 1000000){
  n = n * 10
  y <- rectangle(f,0,1,n)
  print(y)
}
# Sans boucles
rectangle2 <- function (f,a,b,n) {
  sum(f(c(1:n)*(b-a)/n+a)*(b-a)/n)
}


# Monte-Carlo
# Avec boucles
montecarlo <- function(f,a,b,n,ymin,ymax){ 
  Su = 0
  for (k in 1:n){
    x <- runif(1,a,b)
    y <- runif(1,ymin,ymax)
    if (y <= f(x)){Su = Su + 1} 
  }
  return (Su/n*(b-a)*(ymax-ymin))
}
montecarlo(f,0,1,1000,0,3)

# Sans boucles
montecarlo2 <- function(f,a,b,n,ymin,ymax){
  (b-a)*(ymax-ymin)*(sum(runif(n,ymin,ymax) <=  f(runif(n,a,b)))/n )
}
montecarlo2(f,0,1,1000,0,3)


# Comparaison des systèmes time
n = 100000
system.time(rectangle(f,0,1,n))
system.time(rectangle2(f,0,1,n))
system.time(montecarlo(f,0,1,n,0,3))
system.time(montecarlo2(f,0,1,n,0,3))


# Graphique -> précision en fonction des n
n = 500
#plot(c(1:n),rectangle(f,0,1,c(1:n)))
rect <- function(n){
  rectangle2(f,0,1,n)
}
monte <- function(n){
  montecarlo2(f,0,1,n,0,3)
}

plot(c(1:n),apply(matrix(c(1:n),ncol = 1),1,rect))
plot(c(1:n),apply(matrix(c(1:n),ncol = 1),1,monte))

# Graphique avec deux courbes superposées
x <- c(1:n)
r <- apply(matrix(c(1:n),ncol = 1),1,rect)
m <- apply(matrix(c(1:n),ncol = 1),1,monte)
y <- matrix(c(m,r),ncol = 2); y
matplot(x,y,col=c("red","blue"),type="p",lty=20,pch = 1,xlab="nombre d'itérations",ylab = "valeur de l'intégrale trouvée par la méthode")
k <- rep(11/6,n)
matlines(x, k, type = "l", lty = 1,lwd = 3, col = "black")
legend(350,3.2,legend=c("monte-Carlo","rectangles","valeur exacte"),pch=c(1,1,20),col=c("red","blue","black"))
title(main = "Valeur du calcul de l'intégrale en fonction du nombre d'itérations")
savePlot("precision_iteration.png"= paste("Rplot", type, sep = "."),type="png",device = dev.cur())


# Graphique avec deux courbes superposées pour la précision (inverse)
n = 500
x <- c(1:n)
r <- apply(matrix(c(1:n),ncol = 1),1,rect)
m <- apply(matrix(c(1:n),ncol = 1),1,monte)
y <- matrix(c((1/abs(11/6-m)),(1/abs(11/6-r))),ncol = 2); y
matplot(x,y,col=c("red","blue"),type="p",lty=20,pch = 1,xlab="nombre d'itérations",ylab = "valeur de l'intégrale trouvée par la méthode")
legend(0,1500,legend=c("monte-Carlo","rectangles"),pch=c(1,1),col=c("red","blue"))
title(main = "Valeur de la précision des algorithmes")
savePlot("precision_iteration_inverse.png"= paste("Rplot", type, sep = "."),type="png",device = dev.cur())

# Graphique avec deux courbes superposées par rapport à la solution "exacte" -> 11/6
y <- matrix(c(11/6-m,11/6-r),ncol = 2); y
matplot(x,y,col=rainbow(2),type="p",lty=20,pch = 1)




# Graphique -> précision en fonction du temps
trect <- function(temps,pt){
  i = 1
  j = 1
  rep = c()
  tstart = Sys.time()
  while (Sys.time() < tstart + temps){
    if (Sys.time() > tstart + j*pt){
      rep[j] = rectangle2(f,0,1,i)
      j = j + 1 
    }else{
      rectangle2(f,0,1,i)
    }
    i = i + 1
  }
  return (rep)
}

tmonte <- function(temps,pt){
  i = 1
  j = 1
  rep = c()
  tstart = Sys.time()
  while (Sys.time() < tstart + temps){
    if (Sys.time() > tstart + j*pt){
      rep[j] = montecarlo2(f,0,1,i,0,3)
      j = j + 1
    }else{
      montecarlo2(f,0,1,i,0,3)
    }
    i = i + 1
  }
  return (rep)
}

tlim = 1
tpas = 0.005
reprec = c()
reprec = trect(tlim,tpas)
l = length(reprec)
plot(c(1:l),reprec)

repmont = c()
repmont = tmonte(tlim,tpas)
l2 = length(repmont)
plot(c(1:l2),repmont)
#plot(c(1:tlim),apply(matrix(c(1:tlim),ncol = 1),1,monte))


# Graphique avec deux courbes superposées
tlim <- 3
tpas <- 0.009
reprec <- trect(tlim,tpas); length(reprec)
repmont <- tmonte(tlim,tpas); length(repmont) ;length(c(1:length(reprec)*tpas))
yy <- matrix(c((1/abs(11/6-repmont)),(1/abs(11/6-reprec))),ncol = 2)
matplot(c(1:length(reprec)*tpas),yy,col=c("red","blue"),type="p",lty=20,pch = 1,xlab="temps en secondes",ylab = "valeur de l'intégrale trouvée par la méthode")
matlines(c(0:(length(reprec)-1)), k, type = "l", lty = 1,lwd = 3, col = "black")
legend(0,10000,legend=c("monte-Carlo","rectangles"),pch=c(1,1),col=c("red","blue"))
title(main = "Valeur de la précision de calcul de l'intégrale en fonction du temps")
savePlot("precision_temps.png"= paste("Rplot", type, sep = "."),type="png",device = dev.cur())

# Regarder les astuces suivantes -> https://www.r-bloggers.com/5-ways-to-measure-running-time-of-r-code/
