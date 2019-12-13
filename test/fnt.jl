
@testset "1D Fermat Number Transform" begin
    t = 2
    x = [1:8;]
    @test ifnt(t, fnt(t, x)) == x
end

@testset "1D convolution with FNT" begin
    using DSP

    t = 3
    # padding inputs with zeros to get non circular convolution
    x = [1:8; zeros(Int, 8);]
    h = [1:8; zeros(Int, 8);]
    X = fnt(t, x)
    H = fnt(t, h)
    Y = X .* H
    y = ifnt(t, Y)
    
    @test y[1:15] == DSP.conv(1:8, 1:8)
end

@testset "2D Fermat Number Transform" begin
    t = 2
    limit = 2^(2^t)+1
    x = mod.(rand(Int, 8, 8), limit)
    @test ifnt(t, fnt(t, x)) == x
end

@testset "2D convolution with FNT" begin
    using DSP

    t = 3
    x = mod.(rand(Int, 8, 8), 5)
    x_padded = zeros(Int64, 16, 16)
    x_padded[1:8, 1:8] = x
    h = mod.(rand(Int, 8, 8), 3)
    h_padded = zeros(Int64, 16, 16)
    h_padded[1:8, 1:8] = h
    X = fnt(t, x_padded)
    H = fnt(t, h_padded)
    Y = X .* H
    y = ifnt(t, Y)
    
    @test y[1:15, 1:15] == DSP.conv(x, h)
end
