using Test, NumberTheoreticTransforms

@testset "Number Theoretic Transform tests" begin
    g = 2
    q = 31
    x = [1, 2, 3, 4, 5]
    
    @test intt(g, q, ntt(g, q, x)) == x
end
