
using AbstractPlotting
using StatsMakie
using DataFrames, RDatasets
using StatsMakie: linear, smooth
using Distributions

N = 1000
a = rand(1:2, N);
b = rand(1:2, N);
x = rand(N);
y = @. x * a + 0.8*rand();
z = x .+ y
# http://makie.juliaplots.org/stable/statsmakie.html
scatter(x, y, markersize = 0.02)
scatter(Group(color = a),  x, y, Style(markersize = z ./ 20))

plot!(linear, Group(linestyle = a), x, y)

N = 200
x = 10 .* rand(N)
a = rand(1:2, N)
y = sin.(x) .+ 0.5 .* rand(N) .+ cos.(x) .* a

scatter(Group(a), x, y)
plot!(smooth, Group(a), x, y)

plot(histogram, y)

plot(histogram(nbins=30), x, y)

wireframe(histogram(nbins=30), x, y)

iris = RDatasets.dataset("datasets", "iris")
scatter(Data(iris), Group(:Species), :SepalLength, :SepalWidth)
plot(Position.stack, histogram, Data(iris), Group(:Species), :SepalLength)

wireframe(
    density(trim=true),
    Data(iris), Group(:Species), :SepalLength, :SepalWidth,
    transperence=true, linewidth=0.1
)


mtcars = dataset("datasets", "mtcars")
disallowmissing!.([mtcars, iris])

#kde
plot(
    density,
    Data(mtcars),
    :MPG,
    Group(color = :Cyl)
)

plot(
    histogram,
    Data(mtcars),
    :MPG,
    Group(color = :Cyl)
)

d = rand(Poisson(), 1000)
plot(frequency, d)

xs = 10 .* rand(100)
ys = sin.(xs) .+ 0.5 .* rand.()

scatter(xs,ys)
plot!(smooth, xs, ys)
plot!(linear, xs, ys)

d = dataset("Ecdat", "Fatality")

violin(Data(d), :Year, :Perinc, color = :gray)
boxplot!(Data(d), :Year, :Perinc, color = :black)

help(scatter, extended=true)
help_arguments(stdout, scatter)

text("string")
