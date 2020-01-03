using Images, TestImages
using Deconvolution
using FFTW
using Colors
using ZernikePolynomials
using FFTW
using NumberTheoreticTransforms

trim = 225:288 # need to limit size due to O(N^4) complexity 
image_float = channelview(testimage("cameraman"))[trim.-110, trim.+40]
image_int = map(x -> x.:i, image_float) .|> Int64

blur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)
blur_float ./= (sum(blur_float))
blur_float = blur_float[trim, trim]
blur_int = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> Int64

blur_int = fftshift(blur_int)

@assert sum(blur_int) == 256 # to not change brightness

blurred_image_float = ifft(fft(image_float) .* fft(fftshift(blur_float))) |> real

(g, q, n) = (4, 274177, 64)
X = ntt(image_int, g, q)
@assert intt(X, g, q) == image_int
H = ntt( blur_int, g, q)
@assert intt(H, g, q) == blur_int
Y = mod.((X .* H), q)
y = intt(Y, g, q)
blurred_image_int = y / 2^16

using Statistics
@show maximum(abs.(blurred_image_float .- blurred_image_int))
@show mean(abs.(blurred_image_float .- blurred_image_int))
@show var(abs.(blurred_image_float .- blurred_image_int))

save("doc/src/ntt/original.jpg", Images.clamp01nan.(image_float))
save("doc/src/ntt/blurred_fft.jpg", Images.clamp01nan.(Gray.(Normed{UInt8, 8}.(blurred_image_float))))
save("doc/src/ntt/blurred_ntt.jpg", Images.clamp01nan.(Gray.(Normed{UInt8, 8}.(blurred_image_int))))
