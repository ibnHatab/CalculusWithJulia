using Test
using vmls

@test_skip greet() == nothing
@test_skip great_alien() == nothing


@testset "Vectors" begin
    @info "testing vectors"

    function g()
        for i=1:10
            @debug ">> $i"
        end
        return true
    end

    @test g()
end

# f(a) = a > 1 ? 1 : 1.0
# typeof(f(0))
# @code_warntype f(2)


# @inferred f(2)
