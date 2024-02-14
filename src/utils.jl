
import LinearAlgebra: det
function det(matrix::Matrix{Z64{m}}) where m
    LinearAlgebra.det_bareiss(matrix)
end

function adjugate(matrix::Matrix{Z64{m}}) where m
    out = similar(matrix)
    for (col, row) in Iterators.product(axes(matrix)...) 
        d = det(matrix[vcat(begin:col-1, col+1:end), vcat(begin:row-1, row+1:end),])
        res = Z{m}(powermod(m-1, col+row, m)) * d
        out[col, row] = res
    end
    return out
end

function inv(matrix::Matrix{Z64{m}}) where m
    inv(det(matrix)) * adjugate(matrix)
end
