
@testset "1D Number Theoretic Transform" begin
    t = 2
    x = [1:8;]
    @test ifnt(t, fnt(t, x)) == x
end

@testset "2D Number Theoretic Transform" begin
    t = 2
    limit = 2^(2^t)+1
    x = mod.(rand(Int, 8, 8), limit)
    @test ifnt(t, fnt(t, x)) == x
end
