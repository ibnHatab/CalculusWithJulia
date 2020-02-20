module Dependence

using LinearAlgebra

r = 0.5
e₁ = [1,0,0]
l₁ = [1, -(1+r), 0]
l₂ = [0,1, -(1+r)]

c = [1,2,-3]
α₃ = -c[3]/(1+r)
α₂ = -c[2]/(1+r) - c[3]/(1+r)^2
α₁ = c[1] + c[2]/(1+r) + c[3]/(1+r)^2

α₁*e₁ + α₂*l₁ + α₃*l₂

# ortonormal vectors
a₁ = [0,0,1]
a₂ = [1,1,0] ./ sqrt(2)
a₃ = [1,-1,0] ./ sqrt(2)

norm(a₁), norm(a₂), norm(a₃)
a₁'*a₂, a₁'*a₃, a₂'*a₃

x = [1,2,3]
β₁ = a₁'*x; β₂ = a₂'*x; β₃ = a₃'*x

x̃ = β₁*a₁ + β₂*a₂ + β₃*a₃

using Test
@test x ≈ x̃

function gram_schmidt(a; tol = 1e-10)
    q = []
    for i = 1:length(a)
        q̃ = a[i]
        for j = 1:i-1
            q̃ -= (q[j]'*a[i]) * q[j]
        end
        if norm(q̃) < tol
            return (false, q)
        end
        push!(q, q̃/norm(q̃))
    end;
    return true, q
end


a = [ [-1, 1, -1, 1], [-1, 3, -1, 3], [1, 3, 5, 7] ]
independent, q = gram_schmidt(a)
@test norm(q[1]) == 1
@test q[1]'*q[2] == 0
independent, twice = gram_schmidt(q)
@test q == twice

b = [ a[1], a[2], 1.3*a[1] + 0.5*a[2] ]
independent, q = gram_schmidt(b)
@test independent == false

# any  three  2-vectors must be dependen
three_two_vectors = [ [1,1], [1,2], [-1,1] ]
independent, q = gram_schmidt(three_two_vectors)
@test independent == false

end
