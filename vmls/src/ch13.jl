module Chapter13_DataFeeting
using Test
using LinearAlgebra
using AbstractPlotting, GLMakie

include("vmls.jl")
using .VMLS

# linear feet
consumption = petroleum_consumption_data();
n = length(consumption)
A = [ ones(n) 1:n ]
x = A \ consumption

plot(1980:2013, consumption, color = :red, markersize = 1)
plot!(1980:2013, A*x)

# periodic with const grows component
vmt = vehicle_miles_data();
m = 15*12
A = [ 0:(m-1) vcat([eye(12) for i = 1:15]...)]
b = reshape(vmt', m, 1)
x = A \b
plot(1:m, b[:], markersize = 2, color=:red)
plot!(1:m, (A*x)[:], color=:green)

# polynomial feet
m = 100;
t = -1 .+ 2*rand(m,1)           # [-1..1]
y = t.^3 - t + 0.4 ./ (1 .+ 25*t.^2) + 0.10*rand(m,1)

polyfit(t, y, p) = vandermonde(t, p) \ y

θ₂ = polyfit(t,y,3)
θ₆ = polyfit(t,y,7)
θ10  = polyfit(t,y,11)
θ15 = polyfit(t,y,16)

polyeval(θ, x) = vandermonde(x, length(θ))*θ

scatter(t[:],y[:], markersize = 0.01)

t_plot = linspace(-1, 1, 1000)
plot!(t_plot, polyeval(θ₂, t_plot)[:], color=:red)
plot!(t_plot, polyeval(θ₆, t_plot)[:], color=:blue)
plot!(t_plot, polyeval(θ10, t_plot)[:], color=:red)
plot!(t_plot, polyeval(θ15, t_plot)[:], color=:green)

# piece-wise linear feet
m = 100
x = -2 .+ 4*rand(m, 1)
y = 1 .+ 2*(x.-1) - 3*max.(x.+1, 0) + 4*max.(x.-1, 0) + 0.3*rand(m,1)
θ = [ ones(m) x max.(x.+1, 0) max.(x.-1, 0)] \ y
t = [-2.1, -1, 1, 2.1]
ŷ= θ[1] .+ θ[2]*t + θ[3]*max.(t.+1, 0) + θ[4]*max.(t.-1, 0)
scatter(x[:],y[:])
plot!(t, ŷ, color=:red)


D = house_sales_data();
area = D["area"]
beds = D["beds"]
price = D["price"]
m = length(price)
A = [ ones(m) area beds ]
x = A \ price
rmse = rms(price - A*x)
std = stdev(price)

# autoregression
t = temperature_data();
N = length(t)
stdev(t)
rms(t[2:end] - t[1:end-1])      # next hour
rms(t[25:end] - t[1:end-24])    # previous day

M = 8
y = t[M+1:end]
A = hcat([t[i:i+N-M-1] for i = M:-1:1]...)
θ = A \ y
ypred = A*θ
rms(y - ypred)
nplot = 24*5
scatter(1:nplot, t[1:nplot], markersize=1)
plot!(M+1:nplot, ypred[1:nplot-M])

# validation
m = 100
t_test = -1 .+ 2*rand(m,1)
y_test = t_test.^3 - t_test + 0.4 ./ (1 .+ 25*t_test.^2) + 0.10*rand(m, 1)
error_train = zeros(21)
error_test = zeros(21)
# for p = 1:21
#     p = 2
#     A = vandermonde(t, p)
#     θ = A \ y
#     error_train[p] = norm(A*θ - y) / norm(y)
#     error_test[p] = norm(vandermonde(t_test, p)*θ-y_test) / norm(y_test)
# end
