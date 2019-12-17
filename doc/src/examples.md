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
(g, q) = (314, 2^2^t+1) # g for N = 512 found with scripts/find-ntt.jl
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

## Finding transformation parameters

Input vector length, modulo arithmetic used and exponential base of the
transform are tightly coupled. For finding them there is a script prepared.

### Finding parameters for given input length

Let's say we need to convolve vectors of integers in range 0-10000 of length
N=1024.

``` {.sourceCode .bash}
$ julia find-ntt.jl -n 512
(g, q, n) = (62, 7681, 512)
(g, q, n) = (10, 10753, 512)
(g, q, n) = (24, 11777, 512)
(g, q, n) = (3, 12289, 512)
(g, q, n) = (27, 12289, 512)
(g, q, n) = (15, 13313, 512)
```

One of tuples printed is (g, q, n) = (3, 12289, 512), that means for arithmetic
modulo 12289 and base 3 vectors of length 512 can be transformed.

### Finding parameters for given finite field

To list all possible vector lengths for predefined modulo, parameter -q can be
used.

``` {.sourceCode .bash}
$ julia find-ntt.jl -q 17
(g, q, n) = (2, 17, 8)
(g, q, n) = (3, 17, 16)
(g, q, n) = (4, 17, 4)
(g, q, n) = (16, 17, 2)
```

This shows that possible lengths are 2, 4, 8 and 16.
