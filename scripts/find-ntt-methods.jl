
Maybe{T} = Union{T, Nothing}

struct FindNTT{G<:Maybe{BigInt}, Q<:Maybe{BigInt}, N<:Maybe{Int}}
    g::G
    q::Q
    n::N
end

function (params::FindNTT{Nothing, Nothing, Int})()
    n = params.n
    for q in primes(n, 1000000n)
        for g in 2:min(q, 100)
            if mod(q - 1, n) == 0 && powermod(g, n, q) == 1 && !(1 in powermod.(g, 2:n - 1, q))
                println("(g, q, n) = ($g, $q, $n)")
            end
        end
    end
end

function (params::FindNTT{Nothing, BigInt, Nothing})()
    q = params.q
    for g in 2:q
        for n in 1:q
            if powermod(g, n, q) == 1
                println("(g, q, n) = ($g, $q, $n)")
                break
            end
        end
    end
end

function (params::FindNTT{BigInt, BigInt, Nothing})()
    (g, q) = (params.g, params.q)
    @assert g >= 0
    @assert g < q
    for n in 1:q
        if powermod(g, n, q) == 1
            println("(g, q, n) = ($g, $q, $n)")
            break
        end
    end
end

function (params::FindNTT{Nothing, BigInt, Int})()
    (q, n) = (params.q, params.n)
    for g in 2:q
        if powermod(g, n, q) == 1
            println("(g, q, n) = ($g, $q, $n)")
            break
        end
    end
end

function (params::FindNTT{BigInt, BigInt, Int})()
    g, q, n = params.g, params.q, params.n
    if mod(q - 1, n) == 0 && powermod(g, n, q) == 1 && !(1 in powermod.(g, 2:n - 1, q))
        println("(g, q, n) = ($g, $q, $n)")
    end
end
