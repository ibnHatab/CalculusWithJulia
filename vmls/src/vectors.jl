module vectors

x = [-1.1, 0.0, 3.6, -7.2]

length(x)

y = [-1.1; 0.0; 3.6; -7.2]

z = copy(y)

k = [x;y] # vcat
[x,y] #aoa
hcat(x, y)

[1;x;0]

xᵣₛ = x[2:4]

x[1:3] = [1,2,3]

d = x[2:end] - x[1:end - 1]

x = zeros(3)[2] = 1

eᵢ(i, n) = [zeros(i - 1); 1; zeros(n - i)]

ones(2)
rand(2)
randn(100000)

using Makie

temps = 10 .* ones(30) .+ randn(30)

plot(temps)

[0,7,3] + [1,2,0]
[0,7,3] - [1,2,0]

x = collect(1:10)
2.2x
x * 2.2
x / 1.5
1.5 \ x

[1.1, -3.7, 0.3] .- 1.4

y = 1 ./ (x)
x ./ y
y .\ x
x.^y


w = [1,2,2]; z = [1,2,3];
w == z
w .== z

x = [1.1, .5, -1.5, -0.3]
x[abs.(x) .> 1]
x[2:3] .= 1.3
x

a = [ 1, 2 ]; b = [ 3, 4 ];
α = -0.5; β = 1.5;
c = α*a + β*b;

function lincomb1(coeff, vectors)
    n = length(vectors[1])
    a = zeros(n)
    for i = 1:length(vectors)
        a = a + coeff[i] * vectors[i]
    end
    return a
end

lincomb(( -0.5, 1.5), ([1,2], [3,4]))

################################################################################
using AbstractPlotting, Makie
using ImageFiltering, LinearAlgebra

x = range(-2, stop = 2, length = 21)
y = x
z = x .* exp.(-x .^ 2 .- (y') .^ 2)
scene = contour(x, y, z, levels = 10, linewidth = 3)
u, v = ImageFiltering.imgradients(z, KernelFactors.ando3)
n = vec(norm.(Vec2f0.(u,v)))
arrows!(x, y, u, v, arrowsize = n, arrowcolor = n)

################################################################################
using Test
lincomb(coeff, vectors) = sum(coeff[i] * vectors[i] for i = 1:length(vectors))

va, vb = [1; 2], [3; 4]
vc = lincomb(( -0.5, 1.5), [va, vb])

uw = hcat(va, vb, vc)
u = uw[1,:]
w = uw[2,:]
x = zeros(3)
y = x
arrows(x, y, u, w, arrowcolor = [:yellow, :blue, :green])

a = rand(3)
b = rand(3)
β = rand()
lhs = β*(a+b)
rhs = β*a + β*b
@test lhs == rhs

# inner product
x = [-1, 2, 2]
y = [1, 0, -3]

@test x'*y == y'*x              # commutativity
ν = rand()
@test (ν*x)'*y == ν*(x'*y)      # associativity
z = rand(3)
@test (x+y)'*z == x'*z + y'*z   # distributivity

m = rand(4, 3)
a, b, c, d = m[:,1], m[:,2], m[:,3], m[:,4]
@test (a+b)'*(c+d) ≈ a'*c + a'*d + b'*c + b'*d

eᵢ(i, n) = [zeros(i - 1); 1; zeros(n - i)]

n = length(a)
@test eᵢ(2,n)'a == a[2]         # i-th unit vector
@test sum(a) == ones(n)'*a
@test sum(a.^2) == a'*a

b = rand([0,1],n);
@test sum(a .* b) == b' * a     # select by bitmask

# NPV
c = [0.1, 0.1, 0.1, 1.1];
n = length(c)
r = 0.5
d = (1+r) .^ -(0:n-1);
NVP = c'*d

a = randn(10^5); b = randn(10^5);
@time a'*b

using SparseArrays

a = sparsevec([123456, 123457], [1.0, -1.0], 10^6)
length(a)
nnz(a)
b = randn(10^6)
@time a'*a
@time b'*b
@time a'*b
@time b'*a
@time c = a+b;

diff(x) = [x[i] - x[i+1] for i = 1:length(x)-1]

x = rand(1:10,10)
diff(x)
