doc = """NTT parameter finder.

Usage:
  ntt-params.jl --modulus <q> [ --base <g> ]
  ntt-params.jl --length <n> [ --modulus <q> ] [ --base <g> ]
  ntt-params.jl -h | --help

Options:
  -h --help     Show this screen.
  -n --length   Length of input vector.
  -q --modulus  Modulo arithmetic.
  -g --base     Transform exponential base.
"""

using DocOpt, Primes

args = docopt(doc, version=v"2.0.0")
args_parse(T, key) = args[key] === nothing ? nothing : parse(T, args[key])
(g, q, n) = args_parse(BigInt, "<g>"), args_parse(BigInt, "<q>"), args_parse(Int64, "<n>")

include("find-ntt-methods.jl")
findntt = FindNTT(g, q, n)
findntt()
