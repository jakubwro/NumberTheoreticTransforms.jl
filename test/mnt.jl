using Test, NumberTheoreticTransforms

@testset "1D Mersenne Number Transform" begin
    p = 7
    x = [1:2p;]
    @test imnt(p, mnt(p, x)) == x

    p = BigInt(67)
    x = BigInt.([1:2p;])
    @test imnt(p, mnt(p, x)) == x
end
