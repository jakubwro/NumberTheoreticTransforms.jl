### fnt.jl
#
# Copyright (C) 2020 Andrey Oskin.
# Copyright (C) 2020 Jakub Wronowski.
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

export fnt, fnt!, ifnt, ifnt!, modfermat, isfermat

"""
    isfermat(n)

Checks if a given number is a Fermat number \$ 2^{2^t}+1 \$.
"""
function isfermat(number::T) where {T<:Integer}
    if !ispow2(number - one(T))
        return false
    end

    return ispow2(trailing_zeros(number - one(T)))
end

"""
    modfermat(n, q)

Equivalent of mod(n, q) but uses faster algorithm.
Constraints:
-   `q` must be a Fermat number \$ 2^{2^t}+1 \$
-   `n` must be smaller or equal to \$ (q-1)^2 \$
-   `n` must be grater or equal to \$ 0 \$
If above constraints are not met, the result is undefined.
"""
function modfermat(n::T, q::T) where T <: Integer
    x = n & (q - T(2)) - n >>> trailing_zeros(q - T(1)) + q
    x = x >= q ? x - q : x
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
    @assert all(v -> 0 <= v < q, x)

    radix2sort!(x)

    logN = trailing_zeros(N)

    for l in 1:logN
        M = 1 << (l-1) # [1,2,4,8,...,N/2]
        interval = 1 << l # [2,4,8,...,N]
        p = 1 << (logN - l) # [N/2,...,4,2,1]
        gp = powermod(g, p, q)
        W = 1
        for m in 1:M
            for i in m:interval:N
               j = i + M
               xi, xj = x[i], x[j]
               Wxj = modfermat(W * xj, q)
               xi, xj = xi + Wxj, xi - Wxj + q
               xi = xi >= q ? xi - q : xi # mod q
               xj = xj >= q ? xj - q : xj # mod q
               x[i], x[j] = xi, xj
            end
            W = modfermat(W * gp, q)
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
    inv_N = invmod(N, q)
    inv_g = invmod(g, q)

    x = fnt!(y, inv_g, q)
    for i in eachindex(x)
        x[i] = mod(inv_N * x[i], q)
    end

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
