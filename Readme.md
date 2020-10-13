# Elsa Health Models
**Version 0.0.1**

A collection of (mainly causal) models for different health conditions written in Julia, Turing.jl, Distributions.jl, and Omega.jl.


---
#### Getting Started

Please install all the requeirments listed in the requirements section then:

To run the server
1. Change directories into this project: `cd path/to/folder`
2. `julia --project=@. server.jl` to activate the current project and start the server
3. To stop the server simply press `Ctrl+C`

To install new packages:
1. Change directories into this project: `cd path/to/folder`
2. `julia --project=@.` to activate the current project and enter the REPL
3. `] add PACKAGENAME` to add the package "PACKAGENAME" (replace PACKAGENAME with the package)


Some information about adherence:
The file adherence.jl is a causal model that supports counterfactuals. Its still very manual interaction wise, but plans to add support for API access are comming.

---

#### Requirements
1. [Julia](https://julialang.org/) v. 1.4.2 (important: breaks when running on julia 1.5+)
2. [Turing.jl](https://turing.ml/)
3. [Distributions.jl](https://juliastats.org/Distributions.jl/latest/)
4. [Omega.jl](http://www.zenna.org/Omega.jl/latest/) - Causal & Counterfactual inference
5. To run the server [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl)
6. To visualise results & distributions [UnicodePlots.jl](https://github.com/Evizero/UnicodePlots.jl)
7. To send back results from the server [JSON2.jl](https://github.com/quinnj/JSON2.jl)

---

#### Contribution
Please do not push any changes directly to the master branch. Create a new branch with the following naming conventions

When creating a new feature: `feature/feature-name`
When fixing a bug: `bug/bug-name`
When making an improvement: `improvement/improvement-name`

Then push your code to Github and make a pull request for a merge.