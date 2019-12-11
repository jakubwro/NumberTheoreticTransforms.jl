@testset "1D Number Theoretic Transform" begin
    g = 2
    q = 31
    x = [1:5;]
    @test intt(g, q, ntt(g, q, x)) == x

    g = 3
    q = 257
    x = [1:256;]
    @test intt(g, q, ntt(g, q, x)) == x
end

@testset "1D convolution with NTT" begin
    using DSP

    g = 9
    q = 271
    # padding inputs with zeros to get non circular convolution
    x = [1:8; zeros(Int64, 7);]
    h = [1:8; zeros(Int64, 7);]

    X = ntt(g, q, x)
    H = ntt(g, q, h)
    Y = X .* H

    y = intt(g, q, Y)
    
    @test y == DSP.conv(1:8, 1:8)
end

@testset "2D Number Theoretic Transform" begin
    g = 16
    q = 257
    x = reshape([1:16;] , (4,4))
    y = ntt(g, q, x)
    @test intt(g, q, y) == x

    g = 4
    q = 17
    x = reshape([1:16;] , (4,4))
    y = ntt(g, q, x)
    @test intt(g, q, y) == x

    g = 7
    q = 19
    x = reshape([1:9;] , (3,3))
    y = ntt(g, q, x)
    @test intt(g, q, y) == x
end

@testset "2D convolution with NTT" begin
    using DSP

    (g, q, n) = (7, 4733, 7)
   
    #zero padding to get non circular convolution
    x = reshape([1:16;] , (4,4))
    x_padded = zeros(Int64, 7, 7)
    x_padded[1:4, 1:4] = x
    
    h = reshape([4 3 2 0; 4 1 0 0; 0 0 1 2; 0 0 2 3] , (4,4))
    h_padded = zeros(Int64, 7, 7)
    h_padded[1:4, 1:4] = h

    X = ntt(g, q, x_padded)
    H = ntt(g, q, h_padded)
    Y = X .* H

    y = intt(g, q, Y)
    
    @test y == DSP.conv(x, h)
end