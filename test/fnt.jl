
@testset "FNT 1D" begin
    for t in BigInt.(1:13)
        x = [1:2^(t+1);] .|> BigInt
        g = 2 |> BigInt
        q = 2^2^t + 1 |> BigInt
        @time  @test ifnt(fnt(x, g, q), g, q) == x
    end
end

@testset "FNT and NTT coherence" begin
    # FNT is special case with faster implementation of general NTT and should
    # give the same results 
    t = 2
    F_t = 2^2^t + 1 #a Fermat number
    x = [1:8;]

    @test fnt(x, 2, F_t) == ntt(x, 2, F_t)
end

@testset "FNT 1D convolution" begin
    using DSP

    t = 3
    q = 2^2^t + 1
    g = 2
    # padding inputs with zeros to get non circular convolution
    x = [1:8; zeros(Int, 8);]
    h = [1:8; zeros(Int, 8);]
    X = fnt(x, g, q)
    H = fnt(h, g, q)
    Y = mod.(X .* H, q)
    y = ifnt(Y, g, q)
    
    @test y[1:15] == DSP.conv(1:8, 1:8)
end

@testset "FNT 2D" begin
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

@testset "FNT 2D convolution" begin
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
    Y = mod.(X .* H, q)
    y = ifnt(Y, g, q)
    
    @test y[1:15, 1:15] == DSP.conv(x, h)
end

@testset "FNT in-place" begin
    t = 2
    q = 2^2^t + 1
    g = 2

    x = mod.(rand(Int, 8), q)
    y = fnt(x, g, q)
    @test x != y
    fnt!(x, g, q)
    @test x == y

    x = mod.(rand(Int, 8, 8), q)
    y = fnt(x, g, q)
    @test x != y
    fnt!(x, g, q)
    @test x == y

end

@testset "FNT fails for non fermat modulus" begin
    (g, q, n) = (2, 31, 5)
    x = [1:n;]
    @test_throws AssertionError fnt(x, g, q)

    (g, q, n) = (2, 33, 10)
    x = [1:n;]
    @test_throws AssertionError fnt(x, g, q)
end

@testset "isfermat() tests" begin
    known = map(n->2^2^n+1, [0:4;])
    expected = map(v -> v in known, [1:maximum(known);])
    actual = isfermat.([1:maximum(known);])

    @test expected == actual
end

@testset "modfermat() tests" begin
   
    for t in 0:3
        q = 2^2^t+1
        x = 0:(q-1)^2
        @test mod.(x, q) == modfermat.(x, q)
    end

    for t in 0:10
        q = BigInt(2)^2^t+1
        limit = (q-1)^2
        x = mod.(rand(0:limit, 1000), (q-1)^2)
        @test mod.(x, q) == modfermat.(x, q)
    end
end

@testset "multidimensional fnt timings" begin

    for i in 1:2
        (g, q, n) = (2255, 65537, 65536)
        
        rnd = rand(0:16, n);
        x = copy(rnd);
        y1, tm1 = @timed fnt(x, g, q);
        cmplx1 = n * log2(n);


        (g, q, n) = (2256, 65537, 256);
        x = reshape(copy(rnd), (n, n));
        y2, tm2 = @timed fnt(x, g, q);
        cmplx2 = 2*n* n*log2(n);

        n = 65536^(1/3);
        cmplx3 =  3*n * 2*n* n*log2(n);
        
        (g, q, n) = (1024, 65537, 16);
        x = reshape(copy(rnd), (n, n, n, n));
        y4, tm4 = @timed fnt(x, g, q);

        (g, q, n) = (256, 65537, 4);
        x = reshape(copy(rnd), (n, n, n, n, n, n, n, n));
        y8, tm8 = @timed fnt(x, g, q); # 0.03 s

        @show tm1 tm2 tm4 tm8
    end

    (g, q, n) = (233, 65537, 4096)    
    rnd = rand(0:16, n, n);
    x = copy(rnd);
    y1, tm1 = @timed fnt(x, g, q);
    cmplx1 = n * log2(n);

    (g, q, n) = (255, 65537, 64)   
    rnd = rand(0:16, n, n, n, n);
    x = copy(rnd);
    y2, tm2 = @timed fnt(x, g, q);

    @show tm1 tm2
end