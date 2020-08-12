rect1<-function(f,a,b,n){
  sum = 0
  for (k in 1:n){
    sum = sum + f(a+k*(b-a)/n)
  }
  return ((b-a)/n*sum)
} 

rect2<-function(f,a,b,n){return((b-a)/n*sum(f(a+(c(1:n))*(b-a)/n)))}

montecarlo<-function(f,a,b,n,ymin,ymax){
  suma = 0
  for (i in 1:n){
    x = runif(1,min=a,max=b)
    y = runif(1,min=ymin,max=ymax)
    suma = suma + if (f(x) > y) {1} else {0}
  }
  return (((b-a)*(ymax-ymin)*suma)/n +ymin*(b-a))
}
montecarlo2<-function(f,a,b,n,ymin,ymax){(b-a)*(ymax-ymin)*(sum(f(runif(n,min=0,max=1))>runif(n,min=1,max=3)))/n +ymin*(b-a)}


f <- function(t){t*t+t+1}
x <- rect1(f,0,1,100000)
y <- rect2(f,0,1,100000)

z <- montecarlo(f,0,1,100000,f(0),f(1))
z2 <- montecarlo2(f,0,1,100000,f(0),f(1))
