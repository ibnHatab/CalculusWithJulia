# /vmls/test  $ julia --project=.. --color=yes runtests.jl

using Revise, Jive
using vmls

trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
    runtests(@__DIR__, skip=["revise.jl"])
end

watch(trigger, @__DIR__, sources=[pathof(vmls)])
trigger("")

Base.JLOptions().isinteractive==0 && wait()
