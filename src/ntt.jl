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
Constraints on NTT params to ensure that inverse can be computed
"""
function validate(N, g, q)
    @assert mod(q - 1, N) == 0 
    @assert powermod(g, N, q) == 1
    @assert !(1 in powermod.(g, 2:N-1, q)) # this may be redundant
    @assert gcd(N, q) == 1
end

"""
    ntt(x::Array{T,1}, g, q) -> Array{T,1}

The [Number Theoretic Transform](https://en.wikipedia.org/wiki/Discrete_Fourier_transform_(general)#Number-theoretic_transform)
transforms data in a similar fashion to DFT, but instead complex roots of unity
it uses integer roots with all operation defined in a finite field (modulo an
integer number).

`ntt` function implements Number Theoretic Transform directly from the formula,
so it is flexible about choosing transformation params but lacks performance.

``\\bar{x}_k = \\sum_{n=1}^N{x_n g^{(n-1)(k-1)} } \\mod q``

There is also a few constraints on choosing parameters and input length to
ensure that inverse exists and equals to the original input:
-   ``g`` must ``N``-th root of one in modulo ``q`` arithmetic
-   ``q-1`` mod ``N`` must be equal zero
-   ``q`` must be grater than maximum element present in transformed array

To find parameter set you may use fint-ntt script.

The arguments of `ntt` function are

-   `x`: input data, its elements must be smaller than q
-   `g`: transform power base, must have inversion modulo q 
-   `q`: defines modulo arithmetic
"""
function ntt(x::Array{T,1}, g::T, q::T) where {T<:Integer}
    N = length(x)
    #TODO: more validation of p,q, decompose it to struct
    #TODO: create transform object that validates input in the constructor

    validate(N, g, q)
    (lo, hi) = extrema(x)
    @assert lo >= 0
    @assert hi <= q-1


    t = [powermod(g, n * k, q) for n in 0:N-1, k in 0:N-1]
    #TODO: make result of ntt a struct that will hold infrmation about g
    return mod.(t * x, q)
end

# TODO: change implementation to handle any number of dimensions
# it can be done calling N-1 dimensional transform in a loop

function ntt(x::Array{T,2}, g::T, q::T) where {T<:Integer}
    N, M = size(x)
    @assert N == M #TODO: make it work for N != M (need different g for each dim)
    y = zeros(T, size(x))

    for n in 1:N
        y[n, :] = ntt(x[n, :], g, q)
    end

    for m in 1:M
        y[:, m] = ntt(y[:, m], g, q)
    end

    return y
end

"""
    intt(y::Array{T,1}, g, q) -> Array{T,1}

Inverse Number Theoretic Transform implementation directly from the formula.

``x_k = N^{-1} \\sum_{n=1}^N{\\bar{x}_n g^{-(n-1)(k-1)} } \\mod q``

The same input parameters constraints as for `ntt` function must be applied
"""
function intt(y::Array{T,1}, g::T, q::T) where {T<:Integer}
    N = length(y)
   
    validate(N, g, q)
    
    inv_g = invmod(g, q)
    inv_N = invmod(N, q)
    t = [powermod(inv_g, l * k, q) for k in 0:N-1, l in 0:N-1]
    return mod.(inv_N * t * y, q)
end

function intt(y::Array{T,2}, g::T, q::T) where {T<:Integer}
    N, M = size(y)
    x = zeros(T, size(y))

    for m in 1:M
        x[:, m] = intt(y[:, m], g, q)
    end

    for n in 1:N
        x[n, :] = intt(x[n, :], g, q)
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
