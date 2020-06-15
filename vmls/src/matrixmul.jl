module MatrixMultiplication

using Test
using LinearAlgebra

a=[1, 2, 3]; b= [4, 5, 6];

@test a'*b == b'*a              # inner product
@test a*b' != b*a'              # outer product


A = rand(Int8, 3,4)
@test A*I == I*A == A           # identity
I(3)                            # diagonal Bool
B = rand(Int8, 4,5)
A*B                             # 3x5 []
C = rand(Int8, 4, 5)

@test A*(B+C) == A*B + A*C      # distributive +

@test (A*B)' == B'*A'           # transpose of product


end
