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

diagnosis_present_in_household = bernoulli(0.1)
push!(riskfactors, "diagnosis_present_in_household" => diagnosis_present_in_household)

similiar_complaint_in_household = bernoulli(0.1)
push!(riskfactors, "similiar_complaint_in_household" => similiar_complaint_in_household)

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


unhygienic_living_conditions = bernoulli(0.1)
push!(riskfactors, "unhygienic_living_conditions" => unhygienic_living_conditions)

sharing_clothes = bernoulli(0.1)
push!(riskfactors, "sharing_clothes" => sharing_clothes)

humid_environment = bernoulli(0.1)
push!(riskfactors, "humid_environment" => humid_environment)

low_socioeconomic_status = bernoulli(0.1)
push!(riskfactors, "low_socioeconomic_status" => low_socioeconomic_status)

manual_labour = bernoulli(0.1)
push!(riskfactors, "manual_labour" => manual_labour)
