using ElsaPediatrics
using Test
# using Distributions: kldivergence


present_sym_matrix = Dict(
    "pneumonia" => ["cough", "productive_cough", "fever", "chest_pain", "dyspnoea", "crackles"],
    "laryngitis" => ["voice_hoarseness", "difficulty_swallowing", "loss_of_voice", "sore_throat"],
    "sinusitis" => ["facial_pain", "nasal_congestion", "rhinorrhea", "loss_of_smell", "fatigue"],
    "asthma" => ["wheezing", "chest_tightness", "cough", "dyspnoea", "barrel_chest"],
    "tuberculosis" => ["cough", "prologned_cough", "night_sweats", "fever", "weight_loss", "blood_stained_sputum"],
    "gastroenteritis" => ["abdominal_pain", "diarrhea", "vomiting", "nausea", "irritable"],
    "dysentery" => ["diarrhea", "blood_stained_stool"],
    "impetigo" => ["fever", "pruritus", "skin_crusts", "yellow_skin_crusts"],
    "tinea_corporis" => ["skin_patches", "ring_shaped_skin_patches", "pruritus"],
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
        @test prob > 0.5
    end
end



# TODO: Edge Case Tests
# 1. Hallmark signs & Symptoms