

using InvertedIndices # for cleaner code, you can remove this if you really want to.
function cofactor(A::AbstractMatrix, T = Int64)
    ax = axes(A)
    out = similar(A, T, ax)
    for col in ax[1]
        for row in ax[2]
            out[col, row] = (T(-1))^(T(col) + T(row)) * LinearAlgebra.det_bareiss(A[Not(col), Not(row)])
        end
    end
    return out
end

# mod 17
q = 17
T = [1 1 1 1; 1 4 16 13; 1 16 1 16; 1 13 16 4]

d = LinearAlgebra.det_bareiss(T)
d_inv = invmod(d, q)

A = mod.(cofactor(T, Int64), q)
T_inv = mod.(d_inv * A, q)

@assert mod.(T * T_inv, q) == I(4)


using Mods

T = [1 1 1 1; 1 4 16 13; 1 16 1 16; 1 13 16 4] .|> Mod{17}
inv(T)
