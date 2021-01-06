using Omega

riskfactors = Dict{String,Union{Omega.Prim.Bernoulli,Omega.URandVar}}()

immunocompromised = bernoulli(0.2)
push!(riskfactors, "immunocompromised" => immunocompromised)

smoker = bernoulli(0.01) # depends on age and gender
push!(riskfactors, "smoker" => smoker)

frequent_smoke_inhalation = bernoulli(0.2) # might depend on gender and age?? Depends on smoker
push!(riskfactors, "frequent_smoke_inhalation" => frequent_smoke_inhalation)

household_crowding = bernoulli(0.1)
push!(riskfactors, "household_crowding" => household_crowding)

malnutrition = bernoulli(0.1)
push!(riskfactors, "malnutrition" => malnutrition)

recent_hospitalization = bernoulli(0.1)
push!(riskfactors, "recent_hospitalization" => recent_hospitalization)


recent_antibiotic_use = bernoulli(0.1)
push!(riskfactors, "recent_antibiotic_use" => recent_antibiotic_use)

frequent_antibiotic_use = bernoulli(0.1)
push!(riskfactors, "frequent_antibiotic_use" => frequent_antibiotic_use)

history_of_urti = bernoulli(0.1)
push!(riskfactors, "history_of_urti" => history_of_urti)

exposure_to_fumes = bernoulli(0.1)
push!(riskfactors, "exposure_to_fumes" => exposure_to_fumes)


obesity = bernoulli(0.1)
push!(riskfactors, "obesity" => obesity)

asthma_inhaler_use = bernoulli(0.1)
push!(riskfactors, "asthma_inhaler_use" => asthma_inhaler_use)


frequent_alcohol_intake = bernoulli(0.1) # might depend on age and gender (??)
push!(riskfactors, "frequent_alcohol_intake" => frequent_alcohol_intake)

frequent_child_contact = bernoulli(0.1)
push!(riskfactors, "frequent_child_contact" => frequent_child_contact)