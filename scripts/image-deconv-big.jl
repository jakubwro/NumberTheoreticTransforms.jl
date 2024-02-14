using Images, TestImages, Colors, ImageView
using ZernikePolynomials, NumberTheoreticTransforms

image_float = channelview(testimage("cameraman"))
image = map(x -> x.:i, image_float) .|> BigInt

blur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)
blur_float ./= (sum(blur_float))
blur = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> BigInt
blur = blur[begin + 224:begin + 287,begin + 224:begin + 287]
blur = circshift(blur, (32, 32))

(g, q, n) = BigInt.((2, 4294967297, 64))
image = image[257:256+n, 257:256+n]
image = image[256+32+begin:256-32+begin+127, 256+64+begin:256+begin+127]

X = fnt(image, g, q)
H = fnt(blur, g, q)
Y = mod.(X .* H, q)
y = ifnt(Y, g, q)
blurred_image = y .>> 8

imshow(UInt8.(image))
imshow(UInt8.(blurred_image))
