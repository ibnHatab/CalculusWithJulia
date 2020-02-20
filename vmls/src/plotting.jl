module Plotting


using Makie
using AbstractPlotting

scene = Scene()


x = rand(10)
y = rand(10)

colors = rand(10);
scene = scatter(x,y, color = colors)

x = 1:10
y = 1:10
sizevec = [s for s = 1:length(x)] ./10
scene = scatter(x, y, markersize = sizevec)

x = range(0, stop=2π, length=40)
f(x) = sin.(x)
y = f(x)
scene = lines(x, y, color = :blue)

f2(x) = exp.(-x) .* cos.(2π*x)
y2 = f2(x)
scatter!(scene, x, y2, color = :red, markersize = 0.1)
lines!(scene, x, y2, color = :black)
scatter!(scene, x, y, color = :green, marker = :utriangle, markersize = 0.1)

axis = scene[Axis]


axis = scene[Axis] # get the axis object from the scene
axis[:grid][:linecolor] = ((:red, 0.5), (:blue, 0.5))
axis[:names][:textcolor] = ((:red, 1.0), (:blue, 1.0))
axis[:names][:axisnames] = ("x", "y = cos(x)")


y = x
limits = FRect(-5, -10, 20, 30)
scene = lines(x,y, color = :blue, limits = limits)


end # Plotting
