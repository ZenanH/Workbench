using Pkg

function installation()
    PKG_NOCUDA = [
        "BenchmarkTools", "CSV", "CairoMakie", "Dash", "DataFrames", "Documenter",
        "FileIO", "IJulia", "Meshes", "OhMyREPL", "PackageCompiler",
        "Pardiso", "PyCall", "Revise", "TimerOutputs", "Plots", "WriteVTK",
        "SparseArrays", "DelimitedFiles", "Distributed", "LinearAlgebra", "Printf",
        "Random", "Cthulhu"
    ]
    
    Pkg.update()
    for i in PKG_NOCUDA
        Pkg.add("$i")
    end
    Pkg.build()
    Pkg.precompile()
    Pkg.gc()
    Pkg.update()
end

installation()