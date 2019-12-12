
export fnt, ifnt

"""
    fnt(t, x)

Calculates Fermat Number Transform of `x` using arithmetic mod
\$ 2^{2^t}-1 \$.
    
The input array must contain integer number smaller than (TODO)
"""
function fnt(t::Integer, x::Array{T,1}) where {T<:Integer}

end

"""
    ifnt(t, y)

Calculates inverse of Fermat Number Transform for array `y` using arithmetic
mod \$ 2^{2^t}-1 \$.

The input must be array of integers caculated with the same `t` param.
"""
function ifnt(t::Integer, y::Array{T,1}) where {T<:Integer}

end