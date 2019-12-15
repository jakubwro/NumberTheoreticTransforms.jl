
export fnt, ifnt

"""
Checks if a given number is a Fermat number \$ 2^{2^t}-1 \$.
"""
function isfermat(number::T) where {T<:Integer}
    if !ispow2(number-1)
        return false
    end

    return ispow2(T(ceil(log2(number-1)))) # TODO: avoid operations on float
end

"""
Order input to perform radix-2 structured calculation.
It sorts array by bit-reversed 0-based sample index.
"""
function radix2sort!(data::Array{T, 1}) where {T<:Integer}
    N = length(data)
    @assert ispow2(N)

    l = 1
    for k in 1:N
        if l > k
            data[l], data[k] = data[k], data[l]
        end

        l = l - 1
        m = N
        while l & (m >>= 1) != 0
            l &= ~m
        end
        l = (l | m) + 1
    end

    return data
end

function fnt!(g::T, q::T, x::Array{T, 1}) where {T<:Integer}
    N = length(x)
    @assert ispow2(N)

    radix2sort!(x)

    logN = log2(N) |> ceil |> T

    for M in 2 .^ [0:logN-1;] # TODO: not very readable
        interval = 2M
        for m in 1:M
            for i in m:interval:N
               j = i + M
               W = powermod(g, div(N,interval)*(m-1), q) # TODO: can be moved higher
               x[i], x[j] = x[i] + W * x[j], x[i] - W * x[j]
               x[i] = mod(x[i], q)
               x[j] = mod(x[j], q)
            end
        end
    end

    return x
end

function fnt(g::T, q::T, x::Array{T, 1}) where {T<:Integer}
    return fnt!(g, q, copy(x))
end

function fnt(g::T, q::T, x::Array{T,2}) where {T<:Integer}
    N, M = size(x)
    @assert N == M #TODO: make it work for N != M (need different g for each dim)
    y = zeros(T, size(x))

    for n in 1:N
        y[n, :] = fnt(g, q, x[n, :])
    end

    for m in 1:M
        y[:, m] = fnt(g, q, y[:, m])
    end

    return y
end

"""
    ifnt(t, y)

Calculates inverse of Fermat Number Transform for array `y` using arithmetic
mod \$ 2^{2^t}-1 \$.

The input must be array of integers caculated with the same `t` param.
"""
function ifnt!(g::T, q::T, y::Array{T,1}) where {T<:Integer}
    N = length(y)
    x = fnt!(invmod(g, q), q, y)

    x[1:end] = mod.(invmod(N, q) * x[1:end], q)

    return x   
end

function ifnt(g::T, q::T, y::Array{T,1}) where {T<:Integer}
    return ifnt!(g, q, copy(y))
end

function ifnt(g::T, q::T, y::Array{T,2}) where {T<:Integer}
    N, M = size(y)
    x = zeros(T, size(y))

    for m in 1:M
        x[:, m] = ifnt(g, q, y[:, m])
    end

    for n in 1:N
        x[n, :] = ifnt(g, q, x[n, :])
    end
    
    return x
end
