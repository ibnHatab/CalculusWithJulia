
# Simple calculation on CPU

N = 2^20
x = fill(1.0f0, N)
y = fill(2.0f0, N)

y .+= x

using Test
@test all(y .== 3.0f0)

# Paralelize on CPU

function sequential_add!(y, x)
    for i in eachindex(y,x)
        @inbounds y[i] += x[i]
    end
    return nothing
end

fill!(y, 2)
sequential_add!(y,x)
@test all(y .== 3.0f0)

function paralel_add!(y,x)
    Threads.@threads for i in eachindex(y,x)
        @inbounds y[i] += x[i]
    end
    return nothing
end

fill!(y, 2)
paralel_add!(y,x)
@test all(y .== 3.0f0)

using BenchmarkTools
@btime sequential_add!($y, $x)

@btime paralel_add!($y, $x)

# Parallelization on the GPU

using CuArrays

x_d = CuArrays.fill(1.0f0, N)
y_d = CuArrays.fill(2.0f0, N)

y_d .+= x_d
@test all(y_d .== 3.0f0)

function add_broadcast!(y, x)
    CuArrays.@sync y .+= x
    return
end

@btime add_broadcast!(y_d, x_d)

# with kernel
function gpu_add1(y, x)
    for i in 1:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end

using CUDAnative
fill!(y_d, 2.0f0)
@cuda gpu_add1(y_d, x_d)
@test all(Array(y_d) .== 3.0f0)

function bench_gpu1(y, x)
    CuArrays.@sync begin
        @cuda gpu_add1(y, x)
    end
end

@btime bench_gpu1(y_d, x_d)

# modprobe nvidia NVreg_RestrictProfilingToAdminUsers=0
using CUDAdrv
CUDAdrv.@profile bench_gpu1!(y_d, x_d)
