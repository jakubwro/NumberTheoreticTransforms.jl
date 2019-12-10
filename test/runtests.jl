using Test, NumberTheoreticTransforms

@testset "Number Theoretic Transform" begin
    g = 2
    q = 31
    x = [1:5;]
    @test intt(g, q, ntt(g, q, x)) == x

    g = 3
    q = 257
    x = [1:256;]
    @test intt(g, q, ntt(g, q, x)) == x
end

@testset "Convolution with NTT" begin
    using DSP

    g = 2
    q = 257
    # padding inputs with zeros to get non circular convolution
    x = [1:8; zeros(Int64, 8);]
    h = [1:8; zeros(Int64, 8);]

    X = ntt(g, q, x)
    H = ntt(g, q, h)
    Y = X .* H

    y = intt(g, q, Y)
    
    @test y[1:15] == conv(1:8, 1:8)
end

@testset "Number Theoretic Transform 2D" begin
    g = 2
    q = 257
    x = reshape([1:16;] , (4,4))
    y = ntt(g, q, x)
    @test intt(g, q, y) == x

    g = 3
    q = 17
    x = reshape([1:16;] , (4,4))
    y = ntt(g, q, x)
    @test intt(g, q, y) == x

    g = 5
    q = 19
    x = reshape([1:9;] , (3,3))
    y = ntt(g, q, x)
    @test intt(g, q, y) == x
end