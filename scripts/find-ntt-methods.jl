function find_ntt_for_q(q)
    for g in 2:q
        for n in 1:q
            if powermod(g, n, q) == 1
                println("(g, q, n) = ($g, $q, $n)")
                break
            end
        end
    end
end

function find_ntt_for_q_n(q, n)
    for g in 2:q
        if powermod(g, n, q) == 1
            println("(g, q, n) = ($g, $q, $n)")
            break
        end
    end
end

function find_ntt_for_g_q(g, q)
    @assert g >= 0
    @assert g < q
    for n in 1:q
        if powermod(g, n, q) == 1
            println("(g, q, n) = ($g, $q, $n)")
            break
        end
    end
end

function find_ntt_for_g_q_n(g, q, n)
    if mod(q - 1, n) == 0 && powermod(g, n, q) == 1 && !(1 in powermod.(g, 2:n - 1, q))
        println("(g, q, n) = ($g, $q, $n)")
    end
end

function find_ntt_for_n(n)
    for q in primes(n, 1000000n)
        for g in 2:min(q, 100)
            if mod(q - 1, n) == 0 && powermod(g, n, q) == 1 && !(1 in powermod.(g, 2:n - 1, q))
                println("(g, q, n) = ($g, $q, $n)")
            end
        end
    end
end