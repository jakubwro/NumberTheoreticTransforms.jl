
export fnt, ifnt

"""
    fnt(t, x)

Calculates Fermat Number Transform of `x` using arithmetic mod
\$ 2^{2^t}-1 \$.
    
The input array must contain integer number smaller than (TODO)
"""
function fnt(t::T, x::Array{T,1}) where {T<:Integer}
    q = 2^(2^t)+1
    @assert q != 0 # check overflow TODO: better message
    N = length(x)
    r = [powermod(2, m*k, q) for k in 0:N-1, m in 0:2^(t+1)-1]
    return mod.(r * x, q)
end

function fnt(t::T, x::Array{T,2}) where {T<:Integer}
    N, M = size(x)
    @assert N == M #TODO: make it work for N != M (need different g for each dim)
    y = zeros(T, size(x))

    for n in 1:N
        y[n, :] = fnt(t, x[n, :])
    end

    for m in 1:M
        y[:, m] = fnt(t, y[:, m])
    end

    return y
end

"""
    ifnt(t, y)

Calculates inverse of Fermat Number Transform for array `y` using arithmetic
mod \$ 2^{2^t}-1 \$.

The input must be array of integers caculated with the same `t` param.
"""
function ifnt(t::T, y::Array{T,1}) where {T<:Integer}
    q = 2^(2^t)+1
    @assert q != 0 # check overflow TODO: better message
    N = length(y)
    inv_2 = invmod(2, q)
    r = [powermod(inv_2, m*k, q) for k in 0:N-1, m in 0:2^(t+1)-1]
    c = -(2^(2^t-t-1))
    return mod.(c * r * y, q)
end

function ifnt(t::T, y::Array{T,2}) where {T<:Integer}
    N, M = size(y)
    x = zeros(T, size(y))

    for m in 1:M
        x[:, m] = ifnt(t, y[:, m])
    end

    for n in 1:N
        x[n, :] = ifnt(t, x[n, :])
    end
    
    return x
end
