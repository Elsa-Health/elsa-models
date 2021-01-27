<div style="text-align: center;">
<img src="/equal-friends.svg" style="max-width: 600px; margin: auto;"> <br />
<i>Health and wellness for all.</i>
</div>

# Elsa Health Symptom Assessment

![DUB](<https://img.shields.io/badge/Version-0.0.3%20(alpha)-yellow>)

## Description
[Elsa Health](https://elsa.health) Symptom Assessment algorithms are a collection of causal models that can be used for health decision making support at all levels of healthcare providers.

The main intention of these models is to support healthcare workers at the rural (and urban) dispensary level by taking in patient signs, symptoms and risk factors, and calculating the likelihood of one of the covered conditions.

[Elsa Health](https://elsa.health) as an organization is commited to <b>equal access</b> to healthcare for all. We do this the best way we know how, by building technologies to augment the capacity and skills of decision makers (healthcare workers, governments, researchrs, parents, guardians, and individuals) to support optimal decision making. *Disease should be a thing of the past*


#### Goals
- Support developers of health technologies to quickly add symptom assessment capabilities to their technolgies
- Ensure Africa and her specific diseases are included when symptom assessment is being performed.
- Allow developers from all over the world to include African (currently only East African) diseases and their presentations.
- Grow a community of humans that want to leverage technology to make better health decision making is available everywhere technology can reach.

[Learn more about Elsa Health Open Source](https://opensource.elsa.health)

---

## Getting Started
- Check out [the docs](https://opensource.elsa.health/symptom-assessment/getting-started)
- Try the [live demo](https://opensource.elsa.health/symptom-assessment/try-online) (coming soon)



#### Quick Start

##### Install the requirements

1. [Julia](https://julialang.org/) v. 1.4.2 (important: breaks when running on julia 1.5+)
2. [Distributions.jl](https://juliastats.org/Distributions.jl/latest/)
3. [Omega.jl](http://www.zenna.org/Omega.jl/latest/) - Causal & Counterfactual inference
4. To run the server [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl)
5. To visualise results & distributions [UnicodePlots.jl](https://github.com/Evizero/UnicodePlots.jl)
6. To send back results from the server [JSON2.jl](https://github.com/quinnj/JSON2.jl)

##### Quickly launch the server

1. Change directories into this project: `cd path/to/folder`
2. `julia --project=@. ./src/server.jl` to activate the current project and start the server
3. To stop the server simply press `Ctrl+C`

<!-- ##### To install new packages:

1. Change directories into this project: `cd path/to/folder`
2. `julia --project=@.` to activate the current project and enter the REPL
3. `] add PACKAGENAME` to add the package "PACKAGENAME" (replace PACKAGENAME with the package) -->



---

### Want to contribute?

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

If you want to contribute through code or documentation, the [Contributing guide](CONTRIBUTION.md) is the best place to start. If you have questions, feel free to ask.

---
### Dependencies
| Technology / Tool | Description   |
| :-------------    | :----------:  |
|  [Julia](https://julialang.org/)  | A language for scientific and numeric computing - install v. 1.4.2|
| [Distributions.jl](https://juliastats.org/Distributions.jl/latest/) | A package for creating, manipulating and working with various distributions in Julia|
| [Omega.jl](http://www.zenna.org/Omega.jl/latest/)  | Omega is a library for causal and probabilistic inference in Julia.  |
|[HTTP.jl](https://github.com/JuliaWeb/HTTP.jl) | HTTP client and server functionality for Julia  |
|[UnicodePlots.jl](https://github.com/Evizero/UnicodePlots.jl)| Advanced Unicode plotting library designed for use in Julia's REPL. |
|[JSON2.jl](https://github.com/quinnj/JSON2.jl)| Fast JSON for Julia types  |



---
## References

[Improving the accuracy of medical diagnosis with causal machine learning](https://www.nature.com/articles/s41467-020-17419-7)


## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
