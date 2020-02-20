module Norm

using Test
using VMLS

v₂(x) = sqrt(x'*x)              # norm

x = rand(10)
v₂(x)
β = rand()
@test v₂(β.*x) == β*v₂(x)       # Nonnegative homogeneity
y = rand(10)
@test v₂(x+y) ≤ v₂(x) + v₂(y)   # Triangle inequality
@test v₂(x) ≥ 0                 # Nonnegativity
@test v₂(zeros(10)) == 0        # Definiteness

rms̃(x) = v₂(x)/sqrt(length(x))

t = 0:0.01:1;
x = cos.(8*t) - 2*sin.(11*t);
avg(x)
rms(x)

using Makie

plot(t,x)
plot!(t, avg(x)*ones(length(x)))
plot!(t, (avg(x)+rms(x))*ones(length(x)), color = :green)
plot!(t, (avg(x)-rms(x))*ones(length(x)), color = :green)

@test v₂(x + y) == sqrt(v₂(x)^2 + 2x'*y + v₂(y)^2)

a = 0.5
k = sum(x.>a)
n = length(x)
x = rand(100)
@test k/n ≤ (rms(x)/a)^2        # Chebyshev
che(x,a) = floor(v₂(x)^2/a)
a = 1.5
che(x,a)
sum(abs.(x) .>= a)

dist(x,y) = v₂(x-y)
norm = v₂

nearest_neighbor(x, z) = z[argmin([norm(x-y) for y in z])]
z = ( [2,1], [7,2], [5.5,4], [4,8], [1,5], [9,6] );
nearest_neighbor([5,6], z)

de_mean(x) = x .- avg(x)
x̃ = de_mean(x)
avg(x̃)
plot!(t, x̃)

std(x) = sqrt(sum(de_mean(x).^2)/length(x)) # RMS value of the de-mean
@test std(x) == rms(de_mean(x))

μ = avg                         # mean
σ = std                         # STD

@test rms(x)^2 ≈ μ(x)^2 + σ(x)^2

x = rand(100);
α = rand()
@test σ(α .+ x) == σ(x)          # adding a constant
@test σ(α .* x) == abs(α) * σ(x) # multiplying by a constant

Z(x) = 1 ./ σ(x) * (x .- μ(x))      # standartization with mean 0 and std 1
Z(x)

t = 1:length(x)
plot(t, x)
plot!(t, Z(x), color = :red)
plot!(t, de_mean(x), color = :green)
plot!(t, μ(x) .* ones(length(x)))

function standartize(x)
    x̃ = x .- avg(x)
    return x̃ / rms(x̃)
end

z = standartize(x)
@test avg(z) ≤ eps()
@test rms(z) ≈ 1

ang(x,y) = acos(x'*y/(norm(x)*norm(y)))

a = [1,2,-1]; b = [2,0,-3];
degree(r) = r * (360/(2*π))
degree(ang(a,b))

################################################################################
using Makie
using LinearAlgebra

function spher2cart(r::T, θ::T, ϕ::T ) where T<:AbstractArray
    x= @.r*sin(θ)*cos(ϕ)
    y= @.r*sin(θ)*sin(ϕ)
    z= @.r*cos(θ)
    Point3f0.(x,y,z)
end

n = 100^2
r = ones(n);
θ = acos.(1 .- 2 .* rand(n));
ϕ = 2π * rand(n);
pts = spher2cart(r, θ, ϕ);

arrows(pts, (normalize.(pts) .* 0.1f0), arrowsize = 0.02,
       linecolor = :red, arrowcolor = :darkblue)

using Statistics

function correl(a,b)
    ã = a .- avg(a)
    b̃ = b .- avg(a)
    (ã'*b̃)/(norm(ã)*norm(b̃))
end

a = [4.4, 9.4, 15.4, 12.4, 10.4, 1.4, -4.6, -5.6, -0.6, 7.4];
b = [6.2, 11.2, 14.2, 14.2, 8.2, 2.2, -3.8, -4.8, -1.8, 4.2];

correl(a,b)

using Test
@test correl(a,a) == 1
