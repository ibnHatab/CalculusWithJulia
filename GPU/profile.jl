using CuArrays
using CUDAdrv
using CUDAnative

N = 2^20
x_d = CuArrays.fill(1.0f0, N)
y_d = CuArrays.fill(2.0f0, N)

function gpu_add1(y, x)
    for i in 1:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end

function bench_gpu1(y, x)
    CuArrays.@sync begin
        @cuda gpu_add1(y, x)
    end
end


#CUDAdrv.@profile bench_gpu1(y_d, x_d)

function gpu_add2(y, x)
    index = threadIdx().x
    stride = blockDim().x
    for i in index:stride:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end

function bench_gpu2(y, x)
    CuArrays.@sync begin
        @cuda threads=256 gpu_add2(y,x)
    end
end

# CUDAdrv.@profile bench_gpu2(y_d, x_d)
using BenchmarkTools

#@btime bench_gpu2(y_d, x_d)
#@btime gpu_add1(y_d, x_d)


function gpu_add3!(y, x)
    index = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    stride = blockDim().x * gridDim().x
    for i = index:stride:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end

numblocks = ceil(Int, N/256)

function bench_gpu3!(y, x)
    numblocks = ceil(Int, length(y)/256)
    CuArrays.@sync begin
        @cuda threads=256 blocks=numblocks gpu_add3!(y, x)
    end
end

#@btime bench_gpu3!(y_d, x_d)
#CUDAdrv.@profile bench_gpu3!(y_d, x_d)

function gpu_add2_print!(y, x)
    index = threadIdx().x    # this example only requires linear indexing, so just use `x`
    stride = blockDim().x
    @cuprintf("threadIdx %ld, blockDim %ld\n", index, stride)
    for i = index:stride:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end

@cuda threads=16 gpu_add2_print!(y_d, x_d)
synchronize()

# sudo /usr/local/cuda-10.1/bin/nvprof  --profile-from-start off --print-gpu-trace /home/axadmin/tools/julia-1.1.1/bin/julia profile.jl
