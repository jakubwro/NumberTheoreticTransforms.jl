### fnt.jl
#
# Copyright (C) 2019 Jakub Wronowski.
#
# Maintainer: Jakub Wronowski <jakubwro@users.noreply.github.com>
# Keywords: number theoretic transform, fermat number transform
#
# This file is a part of NumberTheoreticTransforms.jl.
#
# License is MIT.
#
### Commentary:
#
# This file contains implementation of Fermat Number Transform.
#
### Code:

export fnt, fnt!, ifnt, ifnt!

"""
Checks if a given number is a Fermat number \$ 2^{2^t}+1 \$.
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

function fnt!(x::Array{T, 1}, g::T, q::T) where {T<:Integer}
    N = length(x)
    @assert ispow2(N)
    @assert isfermat(q)

    radix2sort!(x)

    logN = log2(N) |> ceil |> T

    for M in 2 .^ [0:logN-1;] # TODO: not very readable
        interval = 2M
        for m in 1:M
            p = div(N,interval)
            for i in m:interval:N
               j = i + M
               W = powermod(g, p*(m-1), q)
               Wxj = W * x[j]
               x[i], x[j] = x[i] + Wxj, x[i] - Wxj
               x[i] = mod(x[i], q)
               x[j] = mod(x[j], q)
            end
        end
    end

    return x
end

"""
    fnt!(x, g, q)

In-place version of `fnt`. That means it will store result in the `x` array.
"""
function fnt!(x::Array{T,2}, g::T, q::T) where {T<:Integer}
    N, M = size(x)
    @assert N == M #TODO: make it work for N != M (need different g for each dim)

    for n in 1:N
        x[n, :] = fnt!(x[n, :], g, q)
    end

    for m in 1:M
        x[:, m] = fnt!(x[:, m], g, q)
    end

    return x
end

"""
    fnt(x, g, q)

The Fermat Number Transform returns the same result as `ntt` function using
more performant algorithm. When `q` has \$ 2^{2^t}+1 \$ form the calculation
can be performed with O(N*log(N)) operation instead of O(N^2) for `ntt`.
"""
function fnt(x::Array{T}, g::T, q::T) where {T<:Integer}
    return fnt!(copy(x), g, q)
end

"""
    ifnt!(y, g, q)

In-place version of `ifnt`. That means it will store result in the `y` array.
"""
function ifnt!(y::Array{T,1}, g::T, q::T) where {T<:Integer}
    N = length(y)
    x = fnt!(y, invmod(g, q), q)

    x[1:end] = mod.(invmod(N, q) * x[1:end], q)

    return x   
end

function ifnt!(y::Array{T,2}, g::T, q::T) where {T<:Integer}
    N, M = size(y)

    for m in 1:M
        y[:, m] = ifnt!(y[:, m], g, q)
    end

    for n in 1:N
        y[n, :] = ifnt!(y[n, :], g, q)
    end
    
    return y
end

"""
    ifnt(y, g, q)

Calculates inverse of Fermat Number Transform for array `y` using
mod \$ 2^{2^t}+1 \$ arithmetic.

The input must be array of integers calculated by `fnt` function with the same
`g` and `q` params.
"""
function ifnt(y::Array{T}, g::T, q::T) where {T<:Integer}
    return ifnt!(copy(y), g, q)
end
