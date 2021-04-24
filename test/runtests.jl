using ElsaPediatrics
using Test
# using Distributions: kldivergence


present_sym_matrix = Dict(
    "pneumonia" => ["cough", "productive_cough", "fever", "chest_pain", "dyspnoea", "crackles"],
    "laryngitis" => ["voice_hoarseness", "difficulty_swallowing", "loss_of_voice", "sore_throat"],
    "sinusitis" => ["facial_pain", "nasal_congestion", "rhinorrhea", "loss_of_smell", "fatigue"],
    "asthma" => ["wheezing", "chest_tightness", "cough", "dyspnoea", "barrel_chest"],
    "tuberculosis" => ["cough", "prologned_cough", "night_sweats", "fever", "weight_loss", "blood_stained_sputum"],
    # "tuberculosis" => ["night_sweats", "blood_stained_sputum"]
)

# @show keys(present_sym_matrix)

# assess_symptoms()

# prob = assess_symptoms(["wheezing", "chest_tightness", "cough", "dyspnoea", "barrel_chest", "malaise", "blood_stained_sputum", "tachypnea", "sore_throat", "crackles", "fever"], [], ["tuberculosis"])["tuberculosis"]
# @test prob > 0.0

for (cause, effect) in present_sym_matrix
    @testset "Testing the $cause disease algorithm" begin
        # @show cause, effect
        prob = assess_symptoms(effect, [], ["$cause"])["$cause"]
        @show cause, prob
        @test prob > 0.0
    end
end


# TODO: Edge Case Tests
# 1. Hallmark signs & Symptoms