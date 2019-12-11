"""
Shows all possible params for `ntt` function for given q.
"""
function ntt_params(q)
    for g in 2:q
        for n in 1:q
            if powermod(g, n, q) == 1
                @show g, q, n
                break
            end
        end
    end
end

"""
Shows possible input length for `ntt` function for given q and g.
"""
function ntt_params(q, g)
    @assert g >= 0
    @assert g < q
    for n in 1:q
        if powermod(g, n, q) == 1
            @show g, q, n
            break
        end
    end
end

using Primes

function ntt_params_n(n)
    for q in primes(n, 1000000n)
        for g in 2:min(q, 100)
            if mod(q - 1, n) == 0 && powermod(g, n, q) == 1 && !(1 in powermod.(g, 2:n - 1, q))
                @show g, q, n
            end
        end
    end
end