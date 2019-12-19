# NumberTheoreticTransforms.jl

---

This package provides implementations of general Number Theoretic Transform and
its special case: Fermat Number Transform. The
latter is computed with a FFT-like radix-2 DIT algorithm, although the
goal of this package is not to outperform FFT but rather yield more accurate
results solving inverse problems like [deconvolution](https://github.com/JuliaDSP/Deconvolution.jl).

## Installation

The package is available for Julia versions 1.0 and up.

To install it, run
```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/jakubwro/NumberTheoreticTransforms.jl"))
```
from the Julia REPL.

## Documentation

The complete manual of `NumberTheoreticTransforms.jl` is available at
https://jakubwro.github.io/NumberTheoreticTransforms.jl/dev.

## Development

The package is developed at https://github.com/jakubwro/NumberTheoreticTransforms.jl.
There you can submit bug reports, propose new calculation algorithms with pull
requests, and make suggestions. 

## License

The `NumberTheoreticTransforms.jl` package is licensed under the MIT License.  The
original author is Jakub Wronowski.
