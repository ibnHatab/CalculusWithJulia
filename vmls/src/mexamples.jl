module MExamples

using Test
using AbstractPlotting, GLMakie
using LinearAlgebra

include("src/vmls.jl")
using .VMLS

sc = scene3d()
orts3d(sc)

a = [ -1 1 -1
      -1 3 -1
       1 3 5 ]
vector3d(sc, a)

toAoA(a) = mapslices(x->[x], a, dims=2)[:]
orta = gram_schmidt(toAoA(a))
aa = hcat(orta...)
vector3d(sc, aa, :blue)

ang(aa[1,:], aa[2,:]) |> degree
ang(a, aa)


Scaling = 3 * eye(3)                  # Scaling
ps = Scaling * p |> Point3f0
vector(ps, :blue)

Dilation = diagm([1, 0.2, -1])
pd = Dilation * p |> Point3f0
vector(pd, :green)

Rot(theta) = [cos(theta) -sin(theta);
              sin(theta) cos(theta)];
Rotation = Rot(pi/3)
pr = [Rotation * p[1:2]; p[3]] |> Point3f0
vector(pr, :yellow)


scene = Scene(resolution = (500,500))

points = [ [1,0], [1.5,0], [2,0], [1,0.25], [1.5, 0.25],[1,.5] ];
rpoints = [ Rotation*p for p in points ];

scatter([c[1] for c in points], [c[2] for c in points], color=:red)
scatter!([c[1] for c in rpoints], [c[2] for c in rpoints], color=:blue)

end
