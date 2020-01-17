using Images, TestImages, Colors, ZernikePolynomials, FFTW
using NumberTheoreticTransforms

image_float = channelview(testimage("cameraman"))
image_int = map(x -> x.:i, image_float) .|> Int64

blur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)
blur_float ./= (sum(blur_float))
blur_float = blur_float
blur_int = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> Int64

blur_int = fftshift(blur_int)

@assert sum(blur_int) == 256 # to not change brightness

blurred_image_float = ifft(fft(image_float) .* fft(fftshift(blur_float))) |> real

t = 4
(g, q) = (314, 2^2^t+1)
X = fnt(image_int, g, q)
@assert ifnt(X, g, q) == image_int
H = fnt(blur_int, g, q)
@assert ifnt(H, g, q) == blur_int
Y = mod.((X .* H), q)
y = ifnt(Y, g, q)
blurred_image_int = y / 2^16

using Statistics
@show maximum(abs.(blurred_image_float .- blurred_image_int))
@show mean(abs.(blurred_image_float .- blurred_image_int))
@show var(abs.(blurred_image_float .- blurred_image_int))

save("doc/src/fnt/original.jpg", Images.clamp01nan.(image_float))
save("doc/src/fnt/blurred_fft.jpg", Images.clamp01nan.(Gray.(Normed{UInt8, 8}.(blurred_image_float))))
save("doc/src/fnt/blurred_fnt.jpg", Images.clamp01nan.(Gray.(Normed{UInt8, 8}.(blurred_image_int))))
