using Images, TestImages, Colors, ImageView
using ZernikePolynomials, NumberTheoreticTransforms

image_float = channelview(testimage("cameraman"))
image = map(x -> x.:i, image_float) .|> Int64

# lens abberation blur model
blur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)
blur_float ./= (sum(blur_float))
blur = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> Int64
blur = circshift(blur, (256, 256))

# 2D convolution with FNT
t = 4
(g, q) = (314, 2^2^t+1) # g for N = 512 found with scripts/find-ntt.jl
X = fnt(image, g, q)
H = fnt(blur, g, q)
Y = mod.(X .* H, q)
y = ifnt(Y, g, q)
blurred_image = y .>> 8

imshow(image)
imshow(blurred_image)

(g, q, n) = (255, 65537, 64)
image = image[257:256+n, 257:256+n]

blur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)
blur_float ./= (sum(blur_float))
blur = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> Int64
blur = blur[begin + 224:begin + 287,begin + 224:begin + 287]
blur = circshift(blur, (32, 32))

X = fnt(image, g, q)
H = fnt(blur, g, q)
Y = mod.(X .* H, q)
y = ifnt(Y, g, q)
blurred_image = y

imshow(image)
imshow(blurred_image)


(g, q, n) = (8, 4294967297, 64)
X = fnt(image, g, q)
H = fnt(blur, g, q)
Y = mod.(X .* H, q)
y = ifnt(Y, g, q)
blurred_image = y .>> 24
imshow(image)
imshow(blur)
imshow(blurred_image)