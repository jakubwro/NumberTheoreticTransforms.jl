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
