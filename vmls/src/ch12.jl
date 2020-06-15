module Chapter12_LeastSquare
using Test
using LinearAlgebra

include("vmls.jl")
using .VMLS

A = [ 2 0;
      -1 1;
      0 2]
b = [ 1, 0, -1 ]

x̂= [ 1/3, -1/3]
r̂= A * x̂- b
norm( x̂)

x = [ 1/2, -1/2 ]
r = A*x - b
norm(x)

@test inv(A'*A)*A'*b ≈ pinv(A)*b

@test (A'A)*x̂- A'*b ≈ [ 0.0, 0.0 ]

z = [ -1.1, 2.3 ]
(A*z)'*r̂

z = [ 5.3, -1.2 ]
(A*z)'*r̂
A\b

A = rand(100,20); b= rand(100);
x1 = A\b;
x2 = inv(A'*A)*(A'*b);
x3 = pinv(A)*b;
norm(x1 - x2)

# Q,R = qr(A)
# Q = Matrix(Q)
# x4 = R\(Q'*b)



end
