
export ntt, intt

function ntt(g::Integer, q::Integer, x::Array{T, 1}) where {T<:Integer}
    N = length(x)
    @assert mod(q-1, N) == 0 
    @assert powermod(g, N, q) == 1
    @assert !(1 in powermod.(g, 2:N-1, q))
    @assert gcd(length(x), q) == 1

    t = [powermod(g, n*k, q) for n in 0:N-1, k in 0:N-1]
    return mod.(t * x, q)
end

function intt(g::Integer, q::Integer, y::Array{T, 1}) where {T<:Integer}
    N = length(y)
    @assert mod(q-1, N) == 0
    @assert powermod(g, N, q) == 1
    @assert !(1 in powermod.(g, 2:N-1, q))
    @assert gcd(length(y), q) == 1
    
    inv_g = invmod(g, q)
    inv_N = invmod(N, q)
    t = [ powermod(inv_g, l*k, q) for  k in 0:N-1, l in 0:N-1 ]
    return mod.(inv_N * t * y, q)
end
