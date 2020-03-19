module MExamples


include("vmls.jl")
using .VMLS

using Test
using AbstractPlotting

scene = Scene(resolution = (500,500))

orts = Point3f0[[1,0,0], [0,1,0], [0,0,1]]
arrows!(scene, fill(Point3f0(0), length(orts)), orts,
        arrowcolor=:red,
        arrowsize=0.1,
        linecolor=:red)

vector(p, color) = arrows!(scene, [Point3f0(0)], [p], arrowcolor=:red, arrowsize=0.1, linecolor=color)


p = Point3f0(1,2,3)
vector(p, :red)

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
