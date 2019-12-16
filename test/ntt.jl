@testset "NTT 1D" begin
    g = 2
    q = 31
    x = [1:5;]
    @test intt(ntt(x, g, q), g, q) == x

    g = 3
    q = 257
    x = [1:256;]
    @test intt(ntt(x, g, q), g, q) == x
end

@testset "NTT 1D convolution" begin
    using DSP

    g = 9
    q = 271
    # padding inputs with zeros to get non circular convolution
    x = [1:8; zeros(Int64, 7);]
    h = [1:8; zeros(Int64, 7);]

    X = ntt(x, g, q)
    H = ntt(h, g, q)
    Y = X .* H

    y = intt(Y, g, q)
    
    @test y == DSP.conv(1:8, 1:8)
end

@testset "NTT 2D" begin
    g = 16
    q = 257
    x = reshape([1:16;] , (4,4))
    y = ntt(x, g, q)
    @test intt(y, g, q) == x

    g = 4
    q = 17
    x = reshape([1:16;] , (4,4))
    y = ntt(x, g, q)
    @test intt(y, g, q) == x

    g = 7
    q = 19
    x = reshape([1:9;] , (3,3))
    y = ntt(x, g, q)
    @test intt(y, g, q) == x
end

@testset "NTT 2D convolution" begin
    using DSP

    (g, q, n) = (7, 4733, 7)
   
    #zero padding to get non circular convolution
    x = reshape([1:16;] , (4,4))
    x_padded = zeros(Int64, 7, 7)
    x_padded[1:4, 1:4] = x
    
    h = reshape([4 3 2 0; 4 1 0 0; 0 0 1 2; 0 0 2 3] , (4,4))
    h_padded = zeros(Int64, 7, 7)
    h_padded[1:4, 1:4] = h

    X = ntt(x_padded, g, q)
    H = ntt(h_padded, g, q)
    Y = X .* H

    y = intt(Y, g, q)
    
    @test y == DSP.conv(x, h)
end