using Documenter, NumberTheoreticTransforms

makedocs(modules = [NumberTheoreticTransforms],
         sitename = "NumberTheoreticTransforms.jl",
         pages = Any[
            "Home" => "index.md",
            "Functions" => "api.md"
        ])

deploydocs(
    repo = "github.com/jakubwro/NumberTheoreticTransforms.jl.git",
    target = "build"
)
