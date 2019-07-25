
using Gen

@gen function foo(prob::Float64)
    z1 = @trace(bernoulli(prob), :a)
    z2 = @trace(bernoulli(prob), :b)
    return z1 || z2
end

trace = Gen.simulate(foo, (0.7,))

Gen.get_args(trace)
choices = Gen.get_choices(trace)
choices[:a]
choices[:b]
