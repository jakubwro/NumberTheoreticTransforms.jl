var documenterSearchIndex = {"docs":
[{"location":"api/#","page":"Functions","title":"Functions","text":"DocTestSetup = :(using NumberTheoreticTransforms)","category":"page"},{"location":"api/#Number-Theoretic-Transforms-1","page":"Functions","title":"Number Theoretic Transforms","text":"","category":"section"},{"location":"api/#Number-Theoretic-Transform-1","page":"Functions","title":"Number Theoretic Transform","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.ntt\nNumberTheoreticTransforms.intt","category":"page"},{"location":"api/#NumberTheoreticTransforms.ntt","page":"Functions","title":"NumberTheoreticTransforms.ntt","text":"ntt(x::Array{T,1}, g, q) -> Array{T,1}\n\nThe Number Theoretic Transform transforms data in a similar fashion to DFT, but instead complex roots of unity it uses integer roots with all operation defined in a finite field (modulo an integer number).\n\nntt function implements Number Theoretic Transform directly from the formula, so it is flexible about choosing transformation params but lacks performance.\n\nbarx_k = sum_n=1^Nx_n g^(n-1)(k-1)  mod q\n\nThere is also a few constraints on choosing parameters and input length to ensure that inverse exists and equals to the original input:\n\ng must N-th root of one in modulo q arithmetic\nq-1 mod N must be equal zero\nq must be grater than maximum element present in transformed array\n\nTo find parameter set you may use fint-ntt script.\n\nThe arguments of ntt function are\n\nx: input data, its elements must be smaller than q\ng: transform power base, must have inversion modulo q \nq: defines modulo arithmetic\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.intt","page":"Functions","title":"NumberTheoreticTransforms.intt","text":"intt(y::Array{T,1}, g, q) -> Array{T,1}\n\nInverse Number Theoretic Transform implementation directly from the formula.\n\nx_k = N^-1 sum_n=1^Nbarx_n g^-(n-1)(k-1)  mod q\n\nThe same input parameters constraints as for ntt function must be applied\n\n\n\n\n\n","category":"function"},{"location":"api/#Fermat-Number-Transform-1","page":"Functions","title":"Fermat Number Transform","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.fnt\nNumberTheoreticTransforms.fnt!\nNumberTheoreticTransforms.ifnt\nNumberTheoreticTransforms.ifnt!\nNumberTheoreticTransforms.isfermat\nNumberTheoreticTransforms.modfermat","category":"page"},{"location":"api/#NumberTheoreticTransforms.fnt","page":"Functions","title":"NumberTheoreticTransforms.fnt","text":"fnt(x, g, q)\n\nThe Fermat Number Transform returns the same result as ntt function using more performant algorithm. When q has $ 2^{2^t}+1 $ form the calculation can be performed with O(N*log(N)) operation instead of O(N^2) for ntt.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.fnt!","page":"Functions","title":"NumberTheoreticTransforms.fnt!","text":"fnt!(x, g, q)\n\nIn-place version of fnt. That means it will store result in the x array.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.ifnt","page":"Functions","title":"NumberTheoreticTransforms.ifnt","text":"ifnt(y, g, q)\n\nCalculates inverse of Fermat Number Transform for array y using mod $ 2^{2^t}+1 $ arithmetic.\n\nThe input must be array of integers calculated by fnt function with the same g and q params.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.ifnt!","page":"Functions","title":"NumberTheoreticTransforms.ifnt!","text":"ifnt!(y, g, q)\n\nIn-place version of ifnt. That means it will store result in the y array.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.isfermat","page":"Functions","title":"NumberTheoreticTransforms.isfermat","text":"isfermat(n)\n\nChecks if a given number is a Fermat number $ 2^{2^t}+1 $.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.modfermat","page":"Functions","title":"NumberTheoreticTransforms.modfermat","text":"modfermat(n, q)\n\nEquivalent of mod(n, q) but uses faster algorithm. Constraints:\n\nq must be a Fermat number $ 2^{2^t}+1 $\nn must be smaller or equal to $ (q-1)^2 $\nn must be grater or equal to $ 0 $\n\nIf above constraints are not met, the result is undefined.\n\n\n\n\n\n","category":"function"},{"location":"examples/#Examples-1","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#Image-blurring-1","page":"Examples","title":"Image blurring","text":"","category":"section"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Here is an example of use of Fermat Number Transform to perform image blurring by 2D convolution with a point spread function that models optical aberration.","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"using Images, TestImages, Colors, ImageView\nusing ZernikePolynomials, NumberTheoreticTransforms\n\nimage_float = channelview(testimage(\"cameraman\"))\nimage = map(x -> x.:i, image_float) .|> Int64\n\n# lens abberation blur model\nblur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)\nblur_float ./= (sum(blur_float))\nblur = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> Int64\nblur = circshift(blur, (256, 256))\n\n# 2D convolution with FNT\nt = 4\n(g, q) = (314, 2^2^t+1) # g for N = 512 found with scripts/find-ntt.jl\nX = fnt(image, g, q)\nH = fnt(blur, g, q)\nY = X .* H\ny = ifnt(Y, g, q)\nblurred_image = y .>> 8\n\nimshow(image)\nimshow(blurred_image)","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Original image Blurred image\n(Image: ) (Image: )","category":"page"},{"location":"examples/#Finding-transformation-parameters-1","page":"Examples","title":"Finding transformation parameters","text":"","category":"section"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Input vector length, modulo arithmetic used and exponential base of the transform are tightly coupled. For finding them there is a script prepared.","category":"page"},{"location":"examples/#Finding-parameters-for-given-input-length-1","page":"Examples","title":"Finding parameters for given input length","text":"","category":"section"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Let's say we need to convolve vectors of integers in range 0-10000 of length N=1024.","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"$ julia find-ntt.jl -n 512\n(g, q, n) = (62, 7681, 512)\n(g, q, n) = (10, 10753, 512)\n(g, q, n) = (24, 11777, 512)\n(g, q, n) = (3, 12289, 512)\n(g, q, n) = (27, 12289, 512)\n(g, q, n) = (15, 13313, 512)","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"One of tuples printed is (g, q, n) = (3, 12289, 512), that means for arithmetic modulo 12289 and base 3 vectors of length 512 can be transformed.","category":"page"},{"location":"examples/#Finding-parameters-for-given-finite-field-1","page":"Examples","title":"Finding parameters for given finite field","text":"","category":"section"},{"location":"examples/#","page":"Examples","title":"Examples","text":"To list all possible vector lengths for predefined modulo, parameter -q can be used.","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"$ julia find-ntt.jl -q 17\n(g, q, n) = (2, 17, 8)\n(g, q, n) = (3, 17, 16)\n(g, q, n) = (4, 17, 4)\n(g, q, n) = (16, 17, 2)","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"This shows that possible lengths are 2, 4, 8 and 16.","category":"page"},{"location":"#NumberTheoreticTransforms.jl-1","page":"Home","title":"NumberTheoreticTransforms.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"","category":"page"},{"location":"#","page":"Home","title":"Home","text":"This package provides implementations of general Number Theoretic Transform and its special case: Fermat Number Transform. The latter is computed with a FFT-like radix-2 DIT algorithm, although the goal of this package is not to outperform FFT but rather yield more accurate results solving inverse problems like deconvolution.","category":"page"},{"location":"#Installation-1","page":"Home","title":"Installation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The package is available for Julia versions 1.0 and up.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"To install it, run","category":"page"},{"location":"#","page":"Home","title":"Home","text":"using Pkg\nPkg.add(\"NumberTheoreticTransforms\")","category":"page"},{"location":"#","page":"Home","title":"Home","text":"from the Julia REPL.","category":"page"},{"location":"#Documentation-1","page":"Home","title":"Documentation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The complete manual of NumberTheoreticTransforms.jl is available at https://jakubwro.github.io/NumberTheoreticTransforms.jl/dev.","category":"page"},{"location":"#Development-1","page":"Home","title":"Development","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The package is developed at https://github.com/jakubwro/NumberTheoreticTransforms.jl. There you can submit bug reports, propose new calculation algorithms with pull requests, and make suggestions. ","category":"page"},{"location":"#Credits-1","page":"Home","title":"Credits","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Amazing performance improvements for Fermat Number Transform implementation were suggested by Andrey Oskin in this thread.","category":"page"},{"location":"#License-1","page":"Home","title":"License","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The NumberTheoreticTransforms.jl package is licensed under the MIT License. The original author is Jakub Wronowski. Significant contributions were done by Andrey Oskin.","category":"page"}]
}