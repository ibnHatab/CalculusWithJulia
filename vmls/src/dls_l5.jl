module Lecture5
using Test
using LinearAlgebra
using AbstractPlotting, GLMakie

include("src/vmls.jl")
using .VMLS

sc = scene3d()

# Leonhard Euler
h = 0.01; η = 0.02; m = 1
A = [ 1 h;
      0 1-η*h/m ]
B = [ 0; h/m ]
K = 600                         # K*h = 6.0 sec
f = zeros(K); f[50:99] .= 1.0; f[100:139] .= -1.3;
x1 = [0; 0]
X = [x1 zeros(2,K-1)];

for k = 1:K-1
    X[:,k+1] = A*X[:,k] + B*f[k]
end

tm = linspace(0, (K)*h, K);
lines(tm, X[1,:])
lines!(tm, X[2,:], color=:red)
lines!(tm, f, color=:blue)

end
