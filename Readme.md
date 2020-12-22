# Elsa Health Models
**Version 0.0.1**

A collection of (mainly causal) models for different health conditions written in Julia, Turing.jl, Distributions.jl, and Omega.jl.


---
#### Getting Started

Please install all the requeirments listed in the requirements section then:

##### To run the server
1. Change directories into this project: `cd path/to/folder`
2. `julia --project=@. ./src/server.jl` to activate the current project and start the server
3. To stop the server simply press `Ctrl+C`

##### To install new packages:
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
We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

#### We Develop with Github
We use github to host code, to track issues and feature requests, have discussions, as well as accept pull requests.


Then push your code to Github and make a pull request for a merge.

#### We Use [Github Flow](https://guides.github.com/introduction/flow/index.html), So All Code Changes Happen Through Pull Requests
Pull requests are the best way to propose changes to the codebase (we use [Github Flow](https://guides.github.com/introduction/flow/index.html)). We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

#### Report bugs using Github's [issues](https://github.com/Elsa-Health/elsa-models/issues)
We use GitHub issues to track public bugs. Report a bug by [opening a new issue](); it's that easy!

**Great Bug Reports** tend to have:
- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can. (TODO: Add Example)
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

People *love* thorough bug reports. I'm not even kidding.



### References

[Improving the accuracy of medical diagnosis with causal machine learning](https://www.nature.com/articles/s41467-020-17419-7)
This document was adapted from [Brandk's](https://gist.github.com/briandk/3d2e8b3ec8daf5a27a62) awesome adaptation of the open-source contribution guidelines for [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md)