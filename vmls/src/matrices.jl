module Matrices

using Test

A = [  0.0   1.0  -2.3  0.1
       1.3   4.0  -0.1  0.0
       4.1  -1.0   0.0  1.7 ]

@test A[1,3] == -2.3
@test A[5] == A[2,2] == 4.0 # column first single index: 3+2
@test size(A,1) == 3
@test size(A,2) == 4

tall(X) = size(X,1)>size(X,2)
@test !tall(A)

# block matrices
B = [  0.0   1.0  -2.3 ]
C = [  0.1 ]
D = [  1.3   4.0  -0.1
       4.1  -1.0   0.0]
E = [ 0.0
      1.7 ]

Â= [ hcat(B, C)
     hcat(D, E) ]

Â̂= [ B C
     D E ]

@test Â== A
@test A[2:3, 1:3] == D

notB = [ 1 1 1]
@test any(B .== notB)

A[2,:] # row as column vector

m = size(A,1)
A[m:-1:1,:] # reverse rows

A[:] # stacked columns

reshape(A, (4,3)) # from stacked coluns to new shape

a = [ [1., 2.], [4., 5.], [7., 8.] ]
A = hcat(a...)
B = vcat(a...)

zeros(2,3)
eye(n) = Matrix(I,n,n)
eye(5)

[A; I]
E = zeros(4,4)
(E+I)

dm = [I E
      E I]

diag(dm)

diagm(1 => fill(1, 4))

rand(2,4)|>diag

using SparseArrays

idx = [ 1, 2, 2, 1, 3, 4 ]
jdy = [ 1, 1, 2, 3, 3, 4 ]
V = [ -1.11, 0.15, -0.10, 1.17, -0.30, 0.13 ]

A = sparse(idx, jdy, V)
@test nnz(A) == length(V)
density = nnz(A) / prod(size(A))

B = Array(A)
Â= sparse(B)
@test A == Â

spzeros(2,3) |> Array
sparse(0.1I, 3, 4) |> Array
speye(5) |> Array
spdiagonal([1,2,3,4,5]) |> Array
sprand(Bool, 10000, 10000, 10^-7)


H = [0 1 -2 1
     2 -1 3 0]
@test H'' == H


U = [ 0 4; 7 0; 3 1]
V = [ 1 2; 2 3; 0 4]
@test U+V == V+U

@test 2.2U == U*2.2

U - Matrix(I,size(U))

@test U'*V != U.*V

Ue = exp.(U)
@test norm(U) == norm(U[:])

diff_matrix(n) = [ -speye(n-1) spzeros(n-1)] + [spzeros(n-1) speye(n-1)]

D = diff_matrix(4)
D * [-1, 0, 2, 1]

function running(n)
    s = zeros(n,n)
    for i = 1:n; for j = 1:i
        s[i,j] = 1
    end; end
    s
end

R = running(4)
R * [-1, 0, 2, 1]

function voldemort(t,n)
    m = length(t)
    V = zeros(m,n)
    for i=1:m
        for j=1:n
            V[i,j] = t[i]^(j-1)
        end
    end
    V
end

voldemort([-1, 0, 0.5,1], 5)

vandermonde(t,n) = hcat([t.^i for i=1:n-1]... )
V = vandermonde([-1, 0, 0.5,1], 5)
V[2,:]
V[3,2]


reverse(A, dims=2)
reverser(n) = reverse(eye(n), dims=1)
R = reverser(5)
x = [1., 2., 3., 4., 5.];
R*x

#Incidence  matrix  of  a  graph
A =[ -1 -1   0   1   0
     1   0  -1   0   0
     0   0   1  -1  -1
     0   1   0   0   1 ]

xcirc = [1, -1, 1, 0, 1]   # A circulation


A*xcirc

s = [1,0,-1,0];  # A source vector
x = [0.6, 0.3, 0.6, -0.1, -0.3];  # A flow vector
A*x + s   # Total incoming flow at each node


v= [1,-1,2,-1] # Potential vector
D = norm(A'*v)^2 # Direchlet evergy


using DSP

a = [1,1];  # coefficients of 1+x
b = [2,-1,1];  # coefficients of 2-x+x^2
c = [1,1,-2];  # coefficients of 1+x-2x^2
d = conv(conv(a,b),c)  # coefficients of product

function toeplinz(b, n)
    m = length(b)
    T = zeros(n+m-1,n)
    for i=1:m
        T[i:m+n:end] .= b[i]
    end
    T
end

Tb = toeplinz(b, length(a))
@test Tb*a == conv(b,a)

t = VMLS.linspace(1, 10, 100)
x = sin.(t)
scene = Scene(resolution = (500,500))
plot(t, x)

smother = [1/3,1/3,1/3]
xs = conv(x,smother)
plot!(t, xs[1:100])

differ = [1,-1]
xd = conv(x,differ)
plot!(t, xd[1:100], color=:blue)

end
