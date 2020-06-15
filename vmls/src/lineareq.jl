module LinearEq

using Test

A = [-0.1 2.8 -1.6; 2.3 -0.6 -3.6]
f(x) = A*x

x = [1, 2, 3];  y = [-3, -1, 2];
α = 0.5; β = -1.6;

lhs = f(α*x+β*y)
rhs = α*f(x)+β*f(y)
@test lhs ≈ rhs

@test DSP.rms(lhs-rhs) ≈ VMLS.rms(lhs-rhs)

f(x) = [ norm(x-a), norm(x-b) ]
Df(z) = [ (z-a)' / norm(z-a); (z-b)' / norm(z-b)]
f̂(x) = f(z) + Df(z)*(x-z);
a = [1, 0]; b = [1, 1]; z = [0, 0];

@test norm(f([0.1, 0.1]) - f̂([0.1, 0.1])) < 0.01


h = 0.01; m = 1; η = 1;


end
