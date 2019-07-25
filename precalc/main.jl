
#==
Symbolic math
==#

using SymPy
@vars x a b c 

(x, a, b, c)

p = a*x^2+b*x+c

p(x=>2),p(x=>2,a=>3,b=>4,c=>1)

using Plots; gr()
plot(64-(1//2)*32*x^2,0,2)

simplify((x-1)*x+2)
