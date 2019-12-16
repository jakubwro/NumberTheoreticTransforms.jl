
@testset "1D Fermat Number Transform" begin
    for t in BigInt.(1:10) #TODO: increase range when fnt optimized, should handle t = 20
        x = [1:2^(t+1);] .|> BigInt
        g = 2 |> BigInt
        q = 2^2^t + 1 |> BigInt
        @test ifnt(fnt(x, g, q), g, q) == x
    end
end

@testset "FNT and NTT coherence checks" begin
    # FNT is special case with faster implementation of general NTT and should
    # give the same results 
    t = 2
    F_t = 2^2^t + 1 #a Fermat number
    x = [1:8;]

    @test fnt(x, 2, F_t) == ntt(x, 2, F_t)
end

@testset "1D convolution with FNT" begin
    using DSP

    t = 3
    q = 2^2^t + 1
    g = 2
    # padding inputs with zeros to get non circular convolution
    x = [1:8; zeros(Int, 8);]
    h = [1:8; zeros(Int, 8);]
    X = fnt(x, g, q)
    H = fnt(h, g, q)
    Y = X .* H
    y = ifnt(Y, g, q)
    
    @test y[1:15] == DSP.conv(1:8, 1:8)
end

@testset "2D Fermat Number Transform" begin
    t = 2
    q = 2^2^t + 1
    g = 2
    x = mod.(rand(Int, 8, 8), q)
    @test ifnt(fnt(x, g, q), g, q) == x

    t = 4
    q = 2^2^t + 1
    g = 314
    x = mod.(rand(Int, 512, 512), q)
    @test ifnt(fnt(x, g, q), g, q) == x
end

@testset "2D convolution with FNT" begin
    using DSP

    t = 3
    q = 2^2^t + 1
    g = 2
    x = mod.(rand(Int, 8, 8), 5)
    x_padded = zeros(Int64, 16, 16)
    x_padded[1:8, 1:8] = x
    h = mod.(rand(Int, 8, 8), 3)
    h_padded = zeros(Int64, 16, 16)
    h_padded[1:8, 1:8] = h
    X = fnt(x_padded, g, q)
    H = fnt(h_padded, g, q)
    Y = X .* H
    y = ifnt(Y, g, q)
    
    @test y[1:15, 1:15] == DSP.conv(x, h)
end
