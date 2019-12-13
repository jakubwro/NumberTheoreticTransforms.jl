### ntt.jl
#
# Copyright (C) 2019 Jakub Wronowski.
#
# Maintainer: Jakub Wronowski <jakubwro@users.noreply.github.com>
# Keywords: number theoretic transform
#
# This file is a part of NumberTheoreticTransforms.jl.
#
# License is MIT.
#
### Commentary:
#
# This file contains implementation of general Number Theoretic Transform.
#
### Code:

export ntt, intt

"""
    ntt(g, q, x::Array{T,1}) -> Array{T,1}

The [Number Theoretic Transform](https://en.wikipedia.org/wiki/Discrete_Fourier_transform_(general)#Number-theoretic_transform)
transforms data in a similar fashion to DFT, but instead complex roots of unity
it uses integer roots with all operation defined in a finite field (modulo an
integer number).

`ntt` function implements Number Theoretic Transform directly from the formula,
so it is flexible about choosing transformation params but lacks performance.

``\\bar{x}_k = \\sum_{n=1}^N{x_n g^{(n-1)(k-1)} } \\mod q``

There is also a few constraints on choosing parameteres and input length to
ensure that inverse exists and equals to the original input. (TODO: list constraints)

The arguments of `ntt` function are

-   `g`: transform power base, must have inversion modulo q 
-   `q`: defines modulo arithmetic (all operations are done 'mod q')
-   `x`: input data, its elements must be smaller than q
"""
function ntt(g::T, q::T, x::Array{T,1}) where {T<:Integer}
    N = length(x)
    #TODO: more validation of p,q, decompose it to struct
    #TODO: create transform object that validates input in the constructor

    (lo, hi) = extrema(x)
    @assert lo >= 0
    @assert hi <= q-1

    @assert mod(q - 1, N) == 0 
    @assert powermod(g, N, q) == 1
    @assert !(1 in powermod.(g, 2:N-1, q))
    @assert gcd(length(x), q) == 1

    t = [powermod(g, n * k, q) for n in 0:N-1, k in 0:N-1]
    #TODO: make result of ntt a struct that will hold infrmation about g
    return mod.(t * x, q)
end

function ntt(g::T, q::T, x::Array{T,2}) where {T<:Integer}
    N, M = size(x)
    @assert N == M #TODO: make it worl for N != M (need different g for each dim)
    y = zeros(T, size(x))

    for n in 1:N
        y[n, :] = ntt(g, q, x[n, :])
    end

    for m in 1:M
        y[:, m] = ntt(g, q, y[:, m])
    end

    return y
end

"""
    intt(g, q, y::Array{T,1}) -> Array{T,1}

Inverse Number Theoretic Transform implementation directly from the formula.

``x_k = N^{-1} \\sum_{n=1}^N{\\bar{x}_n g^{-(n-1)(k-1)} } \\mod q``

The same input parameters constraints as for `ntt` function must be applied
"""
function intt(g::T, q::T, y::Array{T,1}) where {T<:Integer}
    N = length(y)
    @assert mod(q - 1, N) == 0
    @assert powermod(g, N, q) == 1
    @assert !(1 in powermod.(g, 2:N-1, q))
    @assert gcd(length(y), q) == 1
    
    inv_g = invmod(g, q)
    inv_N = invmod(N, q)
    t = [powermod(inv_g, l * k, q) for k in 0:N-1, l in 0:N-1]
    return mod.(inv_N * t * y, q)
end

function intt(g::T, q::T, y::Array{T,2}) where {T<:Integer}
    N, M = size(y)
    x = zeros(T, size(y))

    for m in 1:M
        x[:, m] = intt(g, q, y[:, m])
    end

    for n in 1:N
        x[n, :] = intt(g, q, x[n, :])
    end
    
    return x
end


# those implementations are incorrect but transform results were interesing anyway
# TODO: check if those calculations are useful

# function ntt(g::T, q::T, x::Array{T,N}) where {T <: Integer,N}
#     return reshape(ntt(g, q, reshape(x, length(x))), size(x))
# end

# function intt(g::T, q::T, y::Array{T,N}) where {T <: Integer,N}
#     return reshape(intt(g, q, reshape(y, length(y))), size(y))
# end

# TODO: change implementation to handle any number of dimensions
# it can be done calling N-1 dimensional transform in a loop

