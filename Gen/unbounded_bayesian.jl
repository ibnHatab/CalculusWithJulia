
# Baysian nonparametric model

using Gen

struct Interval
    l::Float64
    u::Float64
end

abstract type Node end

struct InternalNode <: Node
    left::Node
    right::Node
    interval::Interval
end

struct LeafNode <: Node
    value::Float64
    interval::Interval
end

@gen function generate_segments(l:Float64, u::Float64)
    interval = Interval(l, u)
    if @trace(bernoulli(0.7), :isleaf)
        value = @trace(normal(0, 1), :value)
        return LeafNode(value, interval)
    else
        frac = @trace(beta(2,2), :frac)
        mid = l + (u - l) * frac
        left = @trace(generate_segments(l, mid), :left)
        right = @trace(generate_segments(mid, u), :right)
        return InternalNode(left, right, interval)
    end
end

# debug it
using PyPlot

function render_node(node::LeafNode)
    PyPlot.plot([node.interval.l, node.interval.u], [node.value, node.value] )
end

function render_node(node::InternalNode)
    render_node(node.left)
    render_node(node.right)
end

function render_segments_trace(trace)
    node = get_retval(trace)
    render_node(node)
    ax = gca()
    ax[:set_xlim]((0, 1))
    ax[:set_ylim]((-3, 3))
end

function grid(renderer::Function, traces; ncols=6, nrows=3)
    PyPlot.figure(figsize=(16, 8))
    for (i, trace) in enumerate(traces)
        PyPlot.subplot(nrows, ncols, i)
        renderer(trace)
    end
end;

traces = [Gen.simulate(generate_segments, (0., 1.)) for i=1:12];
grid(render_segments_trace, traces)



#test data
xs_dense = collect(range(-5, stop=5, length=50))
ys_simple = fill(1., length(xs_dense)) .+ rand(length(xs_dense)) * 0.1
ys_complex = [Int(floor(abs(x/3))) % 2 == 0 ? 2 : 0 for x in xs_dense] .+
    rand(length(xs_dense)) * 0.2


figure(figsize=(6,3))

subplot(1,2,1)
PyPlot.scatter(xs_dense, ys_simple, color="black", s=10)
gca()[:set_ylim]((-1, 3))

subplot(1,2,2)
PyPlot.scatter(xs_dense, ys_complex, color="black", s=10)
gca()[:set_ylim]((-1, 3))
