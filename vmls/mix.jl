using Revise
using Jive

watch($dir; sources=[normpath(joinpath($dir, "..", "src"))]) do path
    @info "File changed" path
    revise()
    include("runtests.jl") # uses Jive.runtests() to run tests
end
