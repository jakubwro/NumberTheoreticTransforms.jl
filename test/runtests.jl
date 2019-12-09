using Test, NumberTheoreticTransforms

@testset "Number Theoretic Transform tests" begin
    g = 2
    q = 31
    x = [1:5;]
    
    @test intt(g, q, ntt(g, q, x)) == x

    g = 3
    q = 257
    x = [1:256;]
    
    @test intt(g, q, ntt(g, q, x)) == x
end
