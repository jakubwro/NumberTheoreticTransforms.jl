var documenterSearchIndex = {"docs":
[{"location":"api/#","page":"Functions","title":"Functions","text":"DocTestSetup = :(using NumberTheoreticTransforms)","category":"page"},{"location":"api/#Number-Theoretic-Transforms-1","page":"Functions","title":"Number Theoretic Transforms","text":"","category":"section"},{"location":"api/#Number-Theoretic-Transform-1","page":"Functions","title":"Number Theoretic Transform","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.ntt\nNumberTheoreticTransforms.intt","category":"page"},{"location":"api/#NumberTheoreticTransforms.ntt","page":"Functions","title":"NumberTheoreticTransforms.ntt","text":"ntt(g, q, x)\n\nNumber Theoretic Transform implementation directly from the formula. It is flexible about choosing transformation params but lacks performance.   \n\nbarx_k = sum_n=1^Nx_n g^(n-1)(k-1)  mod q\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.intt","page":"Functions","title":"NumberTheoreticTransforms.intt","text":"intt(g, q, y)\n\nInverse Number Theoretic Transform implementation directly from the formula.\n\nx_k = N^-1 sum_n=1^Nbarx_n g^-(n-1)(k-1)  mod q\n\n\n\n\n\n","category":"function"},{"location":"api/#Mersenne-Transforms-1","page":"Functions","title":"Mersenne Transforms","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.mnt\nNumberTheoreticTransforms.imnt","category":"page"},{"location":"api/#NumberTheoreticTransforms.mnt","page":"Functions","title":"NumberTheoreticTransforms.mnt","text":"mnt(p, x)\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.imnt","page":"Functions","title":"NumberTheoreticTransforms.imnt","text":"imnt(p, y)\n\n\n\n\n\n","category":"function"},{"location":"api/#Fermat-Number-Transform-1","page":"Functions","title":"Fermat Number Transform","text":"","category":"section"},{"location":"api/#","page":"Functions","title":"Functions","text":"NumberTheoreticTransforms.fnt\nNumberTheoreticTransforms.ifnt","category":"page"},{"location":"api/#NumberTheoreticTransforms.fnt","page":"Functions","title":"NumberTheoreticTransforms.fnt","text":"fnt(t, x)\n\nCalculates Fermat Number Transform of x using arithmetic mod $ 2^{2^t}-1 $.\n\nThe input array must contain integer number smaller than (TODO)\n\n\n\n\n\n","category":"function"},{"location":"api/#NumberTheoreticTransforms.ifnt","page":"Functions","title":"NumberTheoreticTransforms.ifnt","text":"ifnt(t, y)\n\nCalculates inverse of Fermat Number Transform for array y using arithmetic mod $ 2^{2^t}-1 $.\n\nThe input must be array of integers caculated with the same t param.\n\n\n\n\n\n","category":"function"},{"location":"#NumberTheoreticTransforms.jl-1","page":"Home","title":"NumberTheoreticTransforms.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"","category":"page"},{"location":"#","page":"Home","title":"Home","text":"This package provides function for calculating number theoretic transforms and their inverses.","category":"page"},{"location":"#Installation-1","page":"Home","title":"Installation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The package is available for Julia versions 1.0 and up.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"To install it, run","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Pkg.add(\"https://github.com/jakubwro/NumberTheoreticTransforms.jl\")","category":"page"},{"location":"#","page":"Home","title":"Home","text":"from the Julia REPL.","category":"page"}]
}
