module Chapter10
using Test
using LinearAlgebra

include("src/vmls.jl")
using .VMLS


A = [ -1.5   3.0  4.0
       1.0  -1.0  0.0]
B = [-1  -1
      0  -2
      1   0 ]

C = A*B

A = rand(10,3);

G = A'*A;                       # 3x3
@test G[2, 2] ≈ norm(A[:,2])^2
@test G[1,3] ≈ A[:,1]'*A[:,3]

Q, R = qr(A)
@test Matrix(Q)*R ≈ A
norm(A - Matrix(Q)*R)

@test Q'*Q ≈ I                  # ortogonal coluint ⟹ left inverse




end
