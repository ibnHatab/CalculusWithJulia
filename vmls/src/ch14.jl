module Chapter13_DataFeeting
using Test
using LinearAlgebra
using AbstractPlotting, GLMakie

include("vmls.jl")
using .VMLS


tf2mp(b::Bool) = 2*b-1

tp(y,yhat) = sum((y .== true ) .& (yhat .== true))
tn(y,yhat) = sum((y .== false) .& (yhat .== false))
fp(y,yhat) = sum((y .== false) .& (yhat .== true))
fn(y,yhat) = sum((y .== true ) .& (yhat .== false))

error_rate(y, yhat) = (fn(y, yhat) + fp(y, yhat)) / length(y)
confusion_matrix(y, yhat) = [ tp(y, yhat) fn(y, yhat);
                              fp(y, yhat) tn(y, yhat)]

y = rand(Bool, 100); yhat = rand(Bool, 100);
error_rate(y, yhat)
confusion_matrix(y, yhat)

f̃(x) = x'*β .+ v
fhat(x) = f̃(x) > 0
