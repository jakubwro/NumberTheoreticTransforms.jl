# Examples

## Image blurring

Here is an example of use of Fermat Number Transform to perform image
blurring by 2D convolution with a point spread function that models optical
aberration.

``` {.sourceCode .julia}
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
(g, q) = (314, 2^2^t+1) # g for N = 512 fund with scripts/ntt-params.jl
X = fnt(image, g, q)
H = fnt(blur, g, q)
Y = X .* H
y = ifnt(Y, g, q)
blurred_image = y .>> 8

imshow(image)
imshow(blurred_image)
```

| Original image                     | Blurred image                    |
| :--------------------------------- | :------------------------------- |
| ![](fnt/original.jpg)             | ![](fnt/blurred_fnt.jpg)            |

