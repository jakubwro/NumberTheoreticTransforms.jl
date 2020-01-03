# NumberTheoreticTransforms.jl

[![Build Status](https://travis-ci.org/jakubwro/NumberTheoreticTransforms.jl.svg?branch=master)](https://travis-ci.org/jakubwro/NumberTheoreticTransforms.jl)
[![Coverage Status](https://coveralls.io/repos/github/jakubwro/NumberTheoreticTransforms.jl/badge.svg)](https://coveralls.io/github/jakubwro/NumberTheoreticTransforms.jl)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://jakubwro.github.io/NumberTheoreticTransforms.jl/dev)

This package provides implementations of general Number Theoretic Transform and
Fermat Number Transform which is a special case of NTT. The
latter is computed with a FFT-like radix-2 DIT algorithm, although the
goal of this package is not to outperform FFT but rather yield more accurate
results solving inverse problems like
[deconvolution](https://github.com/JuliaDSP/Deconvolution.jl).

## Installation

The package is available for Julia versions 1.0 and up.

To install it, run
```julia
using Pkg
Pkg.add("NumberTheoreticTransforms")
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
