doc = """NTT parameter finder.

Usage:
  ntt-params.jl --modulo <q> [ --base <g> ]
  ntt-params.jl --length <n> [ --modulo <q> ] [ --base <g> ]
  ntt-params.jl -h | --help

Options:
  -h --help     Show this screen.
  -n --length   Length of input vector.
  -q --modulo   Modulo arithmetic.
  -g --base     Transform exponential base.
"""

using DocOpt, Primes

args = docopt(doc, version=v"2.0.0")

include("find-ntt-methods.jl")

if args["--length"] && args["--modulo"] && args["--base"]
    @show (g, q, n) = (parse(BigInt, args["<g>"]), parse(BigInt, args["<q>"]), parse(Int64, args["<n>"]))
    find_ntt_for_g_q_n(g,q,n)
elseif args["--length"] && args["--modulo"]
    @show (q, n) = (parse(BigInt, args["<q>"]), parse(Int64, args["<n>"]))
    find_ntt_for_q_n(q,n)
elseif args["--length"]
    @show n = parse(Int64, args["<n>"])
    find_ntt_for_n(n)
elseif args["--modulo"] && args["--base"]
    @show (g, q) = (parse(BigInt, args["<g>"]), parse(BigInt, args["<q>"]))
    find_ntt_for_g_q(g,q)
elseif args["--modulo"]
    @show q = parse(BigInt, args["<q>"])
    find_ntt_for_q(q)
else
    println(doc)
end
