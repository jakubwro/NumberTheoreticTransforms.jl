var documenterSearchIndex = {"docs":
[{"location":"api/#","page":"Functions","title":"Functions","text":"DocTestSetup = :(using NumberTheoreticTransforms)","category":"page"},{"location":"api/#Number-Theoretic-Transforms-1","page":"Functions","title":"Number Theoretic Transforms","text":"","category":"section"},{"location":"api/#Number-Theoretic-Transform-1","page":"Functions","title":"Number Theoretic Transform","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.ntt\nNumberTheoreticTransforms.intt","category":"page"},{"location":"api/#NumberTheoreticTransforms.ntt","page":"Functions","title":"NumberTheoreticTransforms.ntt","text":"ntt(x::Array{T,1}, g, q) -> Array{T,1}\n\nThe Number Theoretic Transform transforms data in a similar fashion to DFT, but instead complex roots of unity it uses integer roots with all operation defined in a finite field (modulo an integer number).\n\nntt function implements Number Theoretic Transform directly from the formula, so it is flexible about choosing transformation params but lacks performance.\n\nbarx_k = sum_n=1^Nx_n g^(n-1)(k-1)  mod q\n\nThere is also a few constraints on choosing parameteres and input length to ensure that inverse exists and equals to the original input. (TODO: list constraints)\n\nThe arguments of ntt function are\n\nx: input data, its elements must be smaller than q\ng: transform power base, must have inversion modulo q \nq: defines modulo arithmetic (all operations are done 'mod q')\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.intt","page":"Functions","title":"NumberTheoreticTransforms.intt","text":"intt(y::Array{T,1}, g, q) -> Array{T,1}\n\nInverse Number Theoretic Transform implementation directly from the formula.\n\nx_k = N^-1 sum_n=1^Nbarx_n g^-(n-1)(k-1)  mod q\n\nThe same input parameters constraints as for ntt function must be applied\n\n\n\n\n\n","category":"function"},{"location":"api/#Fermat-Number-Transform-1","page":"Functions","title":"Fermat Number Transform","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.fnt\nNumberTheoreticTransforms.fnt!\nNumberTheoreticTransforms.ifnt\nNumberTheoreticTransforms.ifnt!","category":"page"},{"location":"api/#NumberTheoreticTransforms.fnt","page":"Functions","title":"NumberTheoreticTransforms.fnt","text":"fnt(x, g, q)\n\nThe Fermat Number Transform returns the same result as ntt function using more performant algorithm. When q has $ 2^{2^t}-1 $ form the calculation can be performed with O(N*log(N)) operation instead of O(N^2) for ntt.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.fnt!","page":"Functions","title":"NumberTheoreticTransforms.fnt!","text":"fnt!(x, g, q)\n\nIn-place version of fnt. That means it will store result in the x array.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.ifnt","page":"Functions","title":"NumberTheoreticTransforms.ifnt","text":"ifnt(y, g, q)\n\nCalculates inverse of Fermat Number Transform for array y using mod $ 2^{2^t}-1 $ arithmetic.\n\nThe input must be array of integers caculated by fnt function with the same g and q params.\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.ifnt!","page":"Functions","title":"NumberTheoreticTransforms.ifnt!","text":"ifnt!(x, g, q)\n\nIn-place version of ifnt. That means it will store result in the x array.\n\n\n\n\n\n","category":"function"},{"location":"examples/#Examples-1","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#Image-blurring-1","page":"Examples","title":"Image blurring","text":"","category":"section"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Here is an example of use of Fermat Number Transform to perform image blurring by 2D convolution with a point spread function that models optical aberration.","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"using Images, TestImages, Colors, ImageView\nusing ZernikePolynomials, NumberTheoreticTransforms\n\nimage_float = channelview(testimage(\"cameraman\"))\nimage = map(x -> x.:i, image_float) .|> Int64\n\n# lens abberation blur model\nblur_float = evaluateZernike(LinRange(-41,41,512), [12, 4, 0], [1.0, -1.0, 2.0], index=:OSA)\nblur_float ./= (sum(blur_float))\nblur = blur_float .|> Normed{UInt8, 8} .|> x -> x.:i .|> Int64\nblur = circshift(blur, (256, 256))\n\n# 2D convolution with FNT\nt = 4\n(g, q) = (314, 2^2^t+1) # g for N = 512 fund with scripts/ntt-params.jl\nX = fnt(image, g, q)\nH = fnt(blur, g, q)\nY = X .* H\ny = ifnt(Y, g, q)\nblurred_image = y .>> 8\n\nimshow(image)\nimshow(blurred_image)","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Original image Blurred image\n(Image: ) (Image: )","category":"page"},{"location":"#NumberTheoreticTransforms.jl-1","page":"Home","title":"NumberTheoreticTransforms.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"","category":"page"},{"location":"#","page":"Home","title":"Home","text":"This package provides implementations of general Number Theoretic Transform and its special case: Fermat Number Transform. The last one can be computed with a FFT-like radix-2 DIT algorithm. The aim of this package isn't beating FFT with performance but rather accuracy in solving inverse problems like deconvolution.","category":"page"},{"location":"#Installation-1","page":"Home","title":"Installation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The package is available for Julia versions 1.0 and up.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"To install it, run","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Pkg.add(\"https://github.com/jakubwro/NumberTheoreticTransforms.jl\")","category":"page"},{"location":"#","page":"Home","title":"Home","text":"from the Julia REPL.","category":"page"},{"location":"#Documentation-1","page":"Home","title":"Documentation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The complete manual of NumberTheoreticTransforms.jl is available at https://jakubwro.github.io/NumberTheoreticTransforms.jl/dev.","category":"page"},{"location":"#Development-1","page":"Home","title":"Development","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The package is developed at https://github.com/jakubwro/NumberTheoreticTransforms.jl. There you can submit bug reports, propose new calculation algorithms with pull requests, and make suggestions. ","category":"page"},{"location":"#License-1","page":"Home","title":"License","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The NumberTheoreticTransforms.jl package is licensed under the MIT License.  The original author is Jakub Wronowski.","category":"page"}]
}
