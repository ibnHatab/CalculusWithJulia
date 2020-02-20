module LinearFunction

using Test
using AbstractPlotting, Makie
using LinearAlgebra

# Homogenity  ∀ α, x, f(αx) = αf(x)
# Additivity ∀ x, y, f(x+y) = f(x) + f(y)

# Afine f(αx + βy) = αf(x) + βf(y) and α + β = 1

f(x) = x[1] + x[2] - x[4]^2
x = rand(4)
f(x)

a = [-2,0,1,-3]
f(x) = a'*x
x = [2,2,-1,1]; y = [0,1,-1,0];

α = 1.5; β = -3.7;

@test f(α*x+β*y) == α*f(x) + β*f(y)

using Statistics
avg(x) = (ones(length(x)) / length(x))'*x;
@test avg(x) == mean(x)

# Taylor
f(x) = x[1] + exp(x[2]-x[1]);
∇f(z) = [1-exp(z[2]-z[1]), exp(z[2]-z[1])];
z = [1,2];
f̂(x) = f(z) + ∇f(z)'*(x-z)

@test f̂([1,2]) ≈ f([1,2])

# regression model
β = [148.7251, -18.8534]; v = 54.4017;
ŷ(x) = x'*β + v;
x = [0.846,1]; y = 115;
ŷ(x), y

using VMLS
D = house_sales_data()
price = D["price"];
area = D["area"];
beds = D["beds"];
predicted = v .+ β[1]*area + β[2]*beds;

using Makie
scatter(price, predicted, markersize = 5)
plot!([0,800],[0,800])
