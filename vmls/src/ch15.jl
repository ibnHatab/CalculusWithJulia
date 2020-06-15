module Chapter13_17
using Test
using LinearAlgebra
using AbstractPlotting, GLMakie

include("vmls.jl")
using .VMLS

# Linear quadratic contril

H = randn(2,2)
kron(eye(3), H)
cat([H for k=1:3]..., dims=(1,2))

"""
   lqr(A,B,C,x_init,x_des,T,ρ)

Least quadratic controll solver.
Returns x, u - optimal solution for state and input and  yᵢ = Cxᵢ
"""
function lqr(A,B,C,x_init,x_des,T,ρ)
    n = size(A, 1)
    m = size(B, 2)
    p = size(C, 1)
    q = size(x_init, 2)

    Ã = [ kron(eye(T), C) zeros(p*T, m*(T-1));
          zeros(m(T-1), n*T) sqrt(ρ)*eye(m*(T-1)) ]

    b̃ = zeros(p*T + m*(T-1), q)

    C̃₁₁ = [ kron(eye(T-1), A) zeros(n(T-1), n) ] -
        [ zeros(n*(T-1), n) eye(n*(T-1)) ]
    C̃₁₂ = [ kron(n*(T-1), B) ]
    C̃₂₁ = [ eye(n)            zeros(n, n*(T-1));
            zeros(n, n*(T-1)) eye(n)]
    C̃₂₂ = zeros(2*n, m*(T-1))

    C̃ = [ C̃₁₁ C̃₁₂ C̃₂₁ C̃₂₂ ]

    d̃ = [ zeros(n*(T-1), q);
          x_init;
          x_des ]

    z = cls_solve(Ã, b̃, C̃, d̃)
    x = [ z[(i-1)*n+1 : i*n, :] for i=1:T ]
    u = [ z[n*T+(i-1)*m+1 : n*T+i*m, :] for i=1:(T-1) ]
    y = [ C*xt for xt in x ]

    return x, u, y
end;


A = [ 0.855 1.161 0.667;
      0.015 1.073 0.053;
      -0.084 0.059 1.022 ]
B = [ -0.076; -0.139; 0.342 ]
C = [ 0.218 03.507 -1.683 ]
n = 3; p = 1; m = 1;
x_init = [ 0.496; -0.745; 1.304 ]
x_des = zeros(n, 1)

T = 100
yol = zeros(T, 1)
Xol = [ x_init zeros(n, T-1) ];
for k=1:T-1
    Xol[:,k+1] = A*Xol[:,k]
end

yol = C*Xol;
lines(1:T, yol'[:])

ρ = 0.2
x, u, y = lqr(A,B,C,x_init,x_des,T,ρ)



end
