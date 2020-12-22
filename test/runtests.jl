using ElsaModels
using Test
# using Distributions: kldivergence


present_sym_matrix = Dict(
    "pneumonia" => ["cough", "productive_cough", "fever", "chest_pain", "dyspnoea", "crackles"],
    "laryngitis" => ["voice_hoarseness", "difficulty_swallowing", "loss_of_voice", "sore_throat"],
    "sinusitis" => ["facial_pain", "nasal_congestion", "rhinorrhea", "loss_of_smell", "fatigue"],
    "asthma" => ["wheezing", "chest_tightness", "cough", "dyspnoea", "barrel_chest"]
)

@show keys(present_sym_matrix)

@testset "Testing the modules" begin
    for (cause, effect) in present_sym_matrix
        # @show cause, effect
        prob = assess_symptoms(effect, [], ["$cause"])["$cause"]
        @show cause, prob
        @test prob > 0.5
    end
end