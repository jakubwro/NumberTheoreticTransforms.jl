using Documenter, NumberTheoreticTransforms

makedocs(modules = [NumberTheoreticTransforms],
         sitename = "NumberTheoreticTransforms.jl")

deploydocs(
    repo = "github.com/jakubwro/NumberTheoreticTransforms.jl.git",
    target = "build"
)
