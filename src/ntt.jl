
export ntt, intt, ntt2

function ntt(g::T, q::T, x::Array{T,1}) where {T <: Integer}
    N = length(x)
    #TODO: more validation of p,q, decompose it to struct
    @assert mod(q - 1, N) == 0 
    @assert powermod(g, N, q) == 1
    @assert !(1 in powermod.(g, 2:N-1, q))
    @assert gcd(length(x), q) == 1

    t = [powermod(g, n * k, q) for n in 0:N-1, k in 0:N-1]
    #TODO: make result of ntt a struct that will hold infrmation about g
    return mod.(t * x, q)
end

function intt(g::T, q::T, y::Array{T,1}) where {T <: Integer}
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

# those implementations are incorrect but transform results were interesing anyway
# TODO: check if those calculations are useful

# function ntt(g::T, q::T, x::Array{T,N}) where {T <: Integer,N}
#     return reshape(ntt(g, q, reshape(x, length(x))), size(x))
# end

# function intt(g::T, q::T, y::Array{T,N}) where {T <: Integer,N}
#     return reshape(intt(g, q, reshape(y, length(y))), size(y))
# end

function ntt(g::T, q::T, x::Array{T,2}) where {T <: Integer}
    N, M = size(x)
    @assert N == M
    y = ones(T, size(x))

    for n in 1:N
        y[n, :] = ntt(g, q, x[n, :])
    end

    for m in 1:M
        y[:, m] = ntt(g, q, y[:, m])
    end

    return y
end

function intt(g::T, q::T, y::Array{T,2}) where {T <: Integer}
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