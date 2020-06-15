module Chapter11_inverse
using Test
using LinearAlgebra

include("vmls.jl")
using .VMLS

A = [-3 -4; 4 6; 1 1]
B = [-11 -10 16; 7 8 -11]/9

@test B*A ≈ I                   # left inverse

C = [0 -1 6; 0 1 -4]/2          # another left inverse
@test C*A ≈ I

# inverse
A = [1 -2 3; 0 2 2; -4 -4 -4]
@test A^-1 == inv(A)            #

B = inv(A)
@test B*A ≈ I ≈ A*B

# dual bases
A = [ 1 0 1; 4 -3 -4; 1 -1 -2 ]
B = inv(A)
x = [ 0.2, -0.3, 1.2]

rhs = (B[1,:]'*x)*A[:,1] + (B[2,:]'*x)*A[:,2] + (B[3,:]'*x)*A[:,3]

# inverse via QR
A = rand(3,3)
inv(A)
Q,R = qr(A)
@test inv(R)*Q' ≈ A^-1

function backsubst(R, b)
    n = length(b)
    x = zeros(n)
    for i=n:-1:1
        x[i] = (b[i] - R[i,i+1:n]'*x[i+1:n]) / R[i,i]
    end
    x
end

R = triu(rand(4,4))
b = rand(4)
x = backsubst(R,b)
@test R*x ≈ b

x = R\b

# polynomial insterpolation
t = [ -1.1, -0.4, 0.2, 0.8]
A = vandermonde(t,4)
b1 = [ -1.0, 1.3, 1.0, 0.5 ]
c1 = A \ b1

b2 = [ 1.0, 0.0, -2.0, 0.0 ]
c2 = A \ b2

using AbstractPlotting, GLMakie

ts = linspace(-1.2, 1.2, 1000);

p1 = @.c1[1] + c1[2]*ts + c1[3]*ts^2 + c1[4]*ts^3
plot(ts,p1)
scatter!(t, b1)

p2 = @.c2[1] + c2[2]*ts + c2[3]*ts^2 + c2[4]*ts^3;
plot!(ts,p2)
scatter!(t, b2, color=:red)

# pseudo inverse
A = [ -3 -4; 3 6; 1 1 ]
@time pinv(A)
Q,R = qr(A)
Q = Q.T[:,1:end-1]
R \ Q'


end
