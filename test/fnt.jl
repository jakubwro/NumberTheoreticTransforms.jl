
@testset "1D Number Theoretic Transform" begin
    t = 2
    x = [1:8;]
    @test ifnt(t, fnt(t, x)) == x
end