#TODO: implement mnt and imnt here

export mnt, imnt

function mnt(p::T, x::Array{T,1}) where {T <: Integer}
    N = length(x)
    q = 2^p - 1
    y = zeros(T, N)

    @assert N == 2p

    t = [powermod(-2, m*k, q) for m in 0:2p-1, k in 0:2p-1]

    return mod.(t * x, q)
end

function imnt(p::T, y::Array{T,1}) where {T <: Integer}
    N = length(y)
    q = 2^p - 1
    x = zeros(T, N)

    @assert N == 2p

    inv_2p = invmod(2p, q)
    t = [powermod(-2, (2p-1)*m*k, q) for m in 0:2p-1, k in 0:2p-1]

    return mod.(inv_2p * t * y, q)
end
