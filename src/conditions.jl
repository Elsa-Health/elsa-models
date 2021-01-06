using Omega

include("./riskfactors.jl")

# categories [<4weeks, 1mo - 1yr, 1yr - 3yrs, 3yrs - 6yrs, 6yrs - 12yrs, 12yrs - 18yrs]
age_categories = [:neonatal, :infant, :toddler, :preschool, :school, :adolescent]
function age_(rng)
    return age_categories[rand(categorical([0.25, 0.25, 0.2, 0.1, 0.1, 0.1]))]
end
age = ciid(age_)

# male = 1 & female = 0 | with equal likelihood
sex = bernoulli(0.5)


# region = [:dar_es_salaam, :arusha]


# Add dependency on age and sex
# Condition Definitions
conditions = Dict{String,Union{Omega.Prim.Bernoulli,Omega.URandVar}}()

pneumonia = bernoulli(0.1)
push!(conditions, "pneumonia" => pneumonia)

asthma = bernoulli(0.075)
push!(conditions, "asthma" => asthma)

function bronchitis_(rng)
    if (Bool(smoker(rng)))
        return rand(bernoulli(0.25))
    end
    return rand(bernoulli(0.075))
end
bronchitis = ciid(bronchitis_)
push!(conditions, "bronchitis" => bronchitis)


chronic_obstructive_pulmonary_disease = bernoulli(0.075)
push!(conditions, "chronic_obstructive_pulmonary_disease" => chronic_obstructive_pulmonary_disease)

coryza = bernoulli(0.1)
push!(conditions, "coryza" => coryza)

influenza = bernoulli(0.1)
push!(conditions, "influenza" => influenza)

tonsillitis = bernoulli(0.075)
push!(conditions, "tonsillitis" => tonsillitis)

laryngitis = bernoulli(0.075)
push!(conditions, "laryngitis" => laryngitis)

sinusitis = bernoulli(0.175)
push!(conditions, "sinusitis" => sinusitis)

tuberculosis = bernoulli(0.075)
push!(conditions, "tuberculosis" => tuberculosis)

malaria = bernoulli(0.075)
push!(conditions, "malaria" => malaria)

acute_watery_diarrhoea = bernoulli(0.075)
push!(conditions, "acute_watery_diarrhoea" => acute_watery_diarrhoea)

gastroenteritis = bernoulli(0.075)
push!(conditions, "gastroenteritis" => gastroenteritis)

ascariasis = bernoulli(0.075)
push!(conditions, "ascariasis" => ascariasis)

gastritis = bernoulli(0.075)
push!(conditions, "gastritis" => gastritis)

otitis_media = bernoulli(0.075)
push!(conditions, "otitis_media" => otitis_media)

trichuriasis = bernoulli(0.075)
push!(conditions, "trichuriasis" => trichuriasis)

conjunctivitis = bernoulli(0.075)
push!(conditions, "conjunctivitis" => conjunctivitis)

urinary_tract_infections = bernoulli(0.075)
push!(conditions, "urinary_tract_infections" => urinary_tract_infections)

dysentery = bernoulli(0.075)
push!(conditions, "dysentery" => dysentery)

malnutrition = bernoulli(0.075)
push!(conditions, "malnutrition" => malnutrition)

septicaemia = bernoulli(0.075)
push!(conditions, "septicaemia" => septicaemia)

oral_thrush = bernoulli(0.075)
push!(conditions, "oral_thrush" => oral_thrush)

tinea_corporis = bernoulli(0.075)
push!(conditions, "tinea_corporis" => tinea_corporis)

stomatitis = bernoulli(0.075)
push!(conditions, "stomatitis" => stomatitis)

# anaemia = bernoulli(0.075) # both symptom and disease
# push!(conditions, "anaemia" => anaemia)

scabies = bernoulli(0.075)
push!(conditions, "scabies" => scabies)

bacterial_skin_infection = bernoulli(0.075)
push!(conditions, "bacterial_skin_infection" => bacterial_skin_infection)

pediatric_aids = bernoulli(0.075)
push!(conditions, "pediatric_aids" => pediatric_aids)

dehydration = bernoulli(0.075)
push!(conditions, "dehydration" => dehydration)

bacteraemia = bernoulli(0.075)
push!(conditions, "bacteraemia" => bacteraemia)

hematoma = bernoulli(0.075)
push!(conditions, "hematoma" => hematoma)

meningitis = bernoulli(0.075)
push!(conditions, "meningitis" => meningitis)

heat_rash = bernoulli(0.075)
push!(conditions, "heat_rash" => heat_rash)

syphillis = bernoulli(0.075)
push!(conditions, "syphillis" => syphillis)

umbilical_cord_infections = bernoulli(0.075)
push!(conditions, "umbilical_cord_infections" => umbilical_cord_infections)

epilepsy = bernoulli(0.075)
push!(conditions, "epilepsy" => epilepsy)

gerd = bernoulli(0.075)
push!(conditions, "gerd" => gerd)

typhoid = bernoulli(0.075)
push!(conditions, "typhoid" => typhoid)

cholera = bernoulli(0.075)
push!(conditions, "cholera" => cholera)

tinea_nigra = bernoulli(0.075)
push!(conditions, "tinea_nigra" => tinea_nigra)




# =============== SYMPTOM SPACE ===============
symptoms = Dict{String,Omega.URandVar}()

function abdominal_pain_(rng)
    if (Bool(rand(tonsillitis)) && rand(age) !== :adolescent)
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.1))
end
abdominal_pain = ciid(abdominal_pain_)
push!(symptoms, "abdominal_pain" => abdominal_pain)

function anaemia_(rng)
    return rand(bernoulli(0.1))
end
anaemia = ciid(anaemia_)
push!(symptoms, "anaemia" => anaemia)

function barrel_chest_(rng)
    if (Bool(asthma(rng)))
        return rand(bernoulli(0.25))
    end
    return rand(bernoulli(0.05))
end
barrel_chest = ciid(barrel_chest_)
push!(symptoms, "barrel_chest" => barrel_chest)

function blood_stained_sputum_(rng)
    if (!Bool(cough(rng)))
        return rand(constant(0))
    end

    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
blood_stained_sputum = ciid(blood_stained_sputum_)
push!(symptoms, "blood_stained_sputum" => blood_stained_sputum)

function body_weakness_(rng)
    return rand(bernoulli(0.1))
end
body_weakness = ciid(body_weakness_)
push!(symptoms, "body_weakness" => body_weakness)

function central_cyanosis_(rng)
    return rand(bernoulli(0.1))
end
central_cyanosis = ciid(central_cyanosis_)
push!(symptoms, "central_cyanosis" => central_cyanosis)

function chest_pain_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.60))
    end
    return rand(bernoulli(0.01))
end
chest_pain = ciid(chest_pain_)
push!(symptoms, "chest_pain" => chest_pain)

function chest_tightness_(rng)
    if (Bool(asthma(rng)))
        return rand(bernoulli(0.92))
    end
    return rand(bernoulli(0.03))
end
chest_tightness = ciid(chest_tightness_)
push!(symptoms, "chest_tightness" => chest_tightness)

function chills_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.7))
    end
    return rand(bernoulli(0.1))
end
chills = ciid(chills_)
push!(symptoms, "chills" => chills)

function coma_(rng)
    return rand(bernoulli(0.1))
end
coma = ciid(coma_)
push!(symptoms, "coma" => coma)

# NOTE: add a pneumonia dependency ???
function cough_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.35))
    elseif (Bool(asthma(rng)))
        # noctornal & seasonal
        # TODO: add timings
        return rand(bernoulli(0.9))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.9))
    elseif (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.07))
end
cough = ciid(cough_)
push!(symptoms, "cough" => cough)

function convulsions_(rng)
    return rand(bernoulli(0.1))
end
convulsions = ciid(convulsions_)
push!(symptoms, "convulsions" => convulsions)

function crackles_(rng)
    if (Bool(pneumonia(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.01))
end
crackles = ciid(crackles_)
push!(symptoms, "crackles" => crackles)

function dark_urine_(rng)
    return rand(bernoulli(0.1))
end
dark_urine = ciid(dark_urine_)
push!(symptoms, "dark_urine" => dark_urine)

function decreased_breath_sounds_(rng)
    return rand(bernoulli(0.1))
end
decreased_breath_sounds = ciid(decreased_breath_sounds_)
push!(symptoms, "decreased_breath_sounds" => decreased_breath_sounds)

function dental_pain_(rng)
    if (Bool(sinusitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
dental_pain = ciid(dental_pain_)
push!(symptoms, "dental_pain" => dental_pain)

function deviated_septum_(rng)
    if (Bool(sinusitis(rng)))
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.1))
end
deviated_septum = ciid(deviated_septum_)
push!(symptoms, "deviated_septum" => deviated_septum)

function diarrhea_(rng)
    if (Bool(influenza(rng)) && rand(age) !== :adolescent)
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.1))
end
diarrhea = ciid(diarrhea_)
push!(symptoms, "diarrhea" => diarrhea)

function difficulty_swallowing_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.80))
    elseif (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.1))
end
difficulty_swallowing = ciid(difficulty_swallowing_)
push!(symptoms, "difficulty_swallowing" => difficulty_swallowing)

# children who cannot speak
function drooling_(rng)
    if (Bool(tonsillitis(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
drooling = ciid(drooling_)
push!(symptoms, "drooling" => drooling)

function dry_cough_(rng)
    if (!Bool(cough(rng)))
        return rand(constant(0))
    end
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.50))
    end
    return rand(bernoulli(0.1))
end
dry_cough = ciid(dry_cough_)
push!(symptoms, "dry_cough" => dry_cough)

function dyspnoea_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.6))
    elseif (Bool(asthma(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.05))
end
dyspnoea = ciid(dyspnoea_)
push!(symptoms, "dyspnoea" => dyspnoea)

function dyspnoea_upon_exertion_(rng)
    return rand(bernoulli(0.1))
end
dyspnoea_upon_exertion = ciid(dyspnoea_upon_exertion_)
push!(symptoms, "dyspnoea_upon_exertion" => dyspnoea_upon_exertion)

function facial_pain_(rng)
    if (Bool(sinusitis(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.05))
end
facial_pain = ciid(facial_pain_)
push!(symptoms, "facial_pain" => facial_pain)

function fatigue_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.8))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.20))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.1))
end
fatigue = ciid(fatigue_)
push!(symptoms, "fatigue" => fatigue)

function fever_(rng)
    if (Bool(pneumonia(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(malaria(rng)))
        return rand(bernoulli(0.85))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.15))
    elseif (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.3))
end
fever = ciid(fever_)
push!(symptoms, "fever" => fever)

function finger_clubbing_(rng)
    return rand(bernoulli(0.1))
end
finger_clubbing = ciid(finger_clubbing_)
push!(symptoms, "finger_clubbing" => finger_clubbing)

function halitosis_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.20))
    end
    return rand(bernoulli(0.1))
end
halitosis = ciid(halitosis_)
push!(symptoms, "halitosis" => halitosis)

function headache_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.2))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.6))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
headache = ciid(headache_)
push!(symptoms, "headache" => headache)

function high_grade_fever_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(influenza))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.1))
end
high_grade_fever = ciid(high_grade_fever_)
push!(symptoms, "high_grade_fever" => high_grade_fever)

function hypoglycaemia_(rng)
    return rand(bernoulli(0.1))
end
hypoglycaemia = ciid(hypoglycaemia_)
push!(symptoms, "hypoglycaemia" => hypoglycaemia)

function hypopnea_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
hypopnea = ciid(hypopnea_)
push!(symptoms, "hypopnea" => hypopnea)

function hypotension_(rng)
    return rand(bernoulli(0.1))
end
hypotension = ciid(hypotension_)
push!(symptoms, "hypotension" => hypotension)

function increased_resonance_on_percussion_(rng)
    return rand(bernoulli(0.1))
end
increased_resonance_on_percussion = ciid(increased_resonance_on_percussion_)
push!(symptoms, "increased_resonance_on_percussion" => increased_resonance_on_percussion)

function intercostal_drawing_(rng)
    if (Bool(pneumonia(rng)))
        # if (rand(age) !== :adolescent)
        #     return rand(bernoulli)
        return rand(bernoulli(0.65))
    end
    return rand(bernoulli(0.1))
end
intercostal_drawing = ciid(intercostal_drawing_)
push!(symptoms, "intercostal_drawing" => intercostal_drawing)

function jaundice_(rng)
    return rand(bernoulli(0.1))
end
jaundice = ciid(jaundice_)
push!(symptoms, "jaundice" => jaundice)

function laboured_breathing_(rng)
    return rand(bernoulli(0.1))
end
laboured_breathing = ciid(laboured_breathing_)
push!(symptoms, "laboured_breathing" => laboured_breathing)

function lethargy_(rng)
    return rand(bernoulli(0.1))
end
lethargy = ciid(lethargy_)
push!(symptoms, "lethargy" => lethargy)

function loss_of_appetite_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
loss_of_appetite = ciid(loss_of_appetite_)
push!(symptoms, "loss_of_appetite" => loss_of_appetite)

function loss_of_smell_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.7))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.80))
    end
    return rand(bernoulli(0.03))
end
loss_of_smell = ciid(loss_of_smell_)
push!(symptoms, "loss_of_smell" => loss_of_smell)

function loss_of_voice_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.1))
end
loss_of_voice = ciid(loss_of_voice_)
push!(symptoms, "loss_of_voice" => loss_of_voice)

function low_grade_fever_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
low_grade_fever = ciid(low_grade_fever_)
push!(symptoms, "low_grade_fever" => low_grade_fever)

function lymphadenopathy_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
lymphadenopathy = ciid(lymphadenopathy_)
push!(symptoms, "lymphadenopathy" => lymphadenopathy)

function malaise_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
malaise = ciid(malaise_)
push!(symptoms, "malaise" => malaise)

function malnutrition_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.1))
end
malnutrition = ciid(malnutrition_)
push!(symptoms, "malnutrition" => malnutrition)

function myalgia_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.7))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.1))
end
myalgia = ciid(myalgia_)
push!(symptoms, "myalgia" => myalgia)

function nasal_congestion_(rng)
    if (Bool(sinusitis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(pneumonia(rng)) && rand(age) !== :adolescent)
        return rand(bernoulli(0.25))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.05))
end
nasal_congestion = ciid(nasal_congestion_)
push!(symptoms, "nasal_congestion" => nasal_congestion)

function nasal_flaring_(rng)
    if (Bool(pneumonia(rng)))
        return rand(bernoulli(0.25))
    end
    return rand(bernoulli(0.05))
end
nasal_flaring = ciid(nasal_flaring_)
push!(symptoms, "nasal_flaring" => nasal_flaring)

function nasal_polyps_(rng)
    if (Bool(sinusitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
nasal_polyps = ciid(nasal_polyps_)
push!(symptoms, "nasal_polyps" => nasal_polyps)

function nausea_(rng)
    return rand(bernoulli(0.1))
end
nausea = ciid(nausea_)
push!(symptoms, "nausea" => nausea)

function night_sweats_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
night_sweats = ciid(night_sweats_)
push!(symptoms, "night_sweats" => night_sweats)

function pallor_(rng)
    return rand(bernoulli(0.1))
end
pallor = ciid(pallor_)
push!(symptoms, "pallor" => pallor)

function productive_cough_(rng)
    if (!Bool(cough(rng)))
        return rand(constant(0))
    end
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.1))
end
productive_cough = ciid(productive_cough_)
push!(symptoms, "productive_cough" => productive_cough)

# defined as > 2 weeks or 5 days
function prologned_cough_(rng)
    if (!Bool(cough(rng)))
        return rand(constant(0))
    end
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.1))
end
prologned_cough = ciid(prologned_cough_)
push!(symptoms, "prologned_cough" => prologned_cough)

function rectal_prolapse_(rng)
    return rand(bernoulli(0.1))
end
rectal_prolapse = ciid(rectal_prolapse_)
push!(symptoms, "rectal_prolapse" => rectal_prolapse)

# kids cant speak
function refusal_to_eat_(rng)
    if (Bool(tonsillitis(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
refusal_to_eat = ciid(refusal_to_eat_)
push!(symptoms, "refusal_to_eat" => refusal_to_eat)

function rhinorrhea_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.85))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.8))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
rhinorrhea = ciid(rhinorrhea_)
push!(symptoms, "rhinorrhea" => rhinorrhea)

function sneezing_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.1))
end
sneezing = ciid(sneezing_)
push!(symptoms, "sneezing" => sneezing)

function sore_throat_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.55))
    elseif (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
sore_throat = ciid(sore_throat_)
push!(symptoms, "sore_throat" => sore_throat)

function swollen_tonsils_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.1))
end
swollen_tonsils = ciid(swollen_tonsils_)
push!(symptoms, "swollen_tonsils" => swollen_tonsils)

function tachypnea_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(asthma(rng)))
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.01))
end
tachypnea = ciid(tachypnea_)
push!(symptoms, "tachypnea" => tachypnea)

function tender_anterior_neck_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.1))
end
tender_anterior_neck = ciid(tender_anterior_neck_)
push!(symptoms, "tender_anterior_neck" => tender_anterior_neck)

function unable_to_feed_(rng)
    return rand(bernoulli(0.1))
end
unable_to_feed = ciid(unable_to_feed_)
push!(symptoms, "unable_to_feed" => unable_to_feed)

function unable_to_sit_upright_(rng)
    return rand(bernoulli(0.1))
end
unable_to_sit_upright = ciid(unable_to_sit_upright_)
push!(symptoms, "unable_to_sit_upright" => unable_to_sit_upright)

function unusual_fussiness_(rng)
    if (Bool(tonsillitis(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
unusual_fussiness = ciid(unusual_fussiness_)
push!(symptoms, "unusual_fussiness" => unusual_fussiness)

function use_of_accessory_muscles_(rng)
    return rand(bernoulli(0.1))
end
use_of_accessory_muscles = ciid(use_of_accessory_muscles_)
push!(symptoms, "use_of_accessory_muscles" => use_of_accessory_muscles)

function voice_hoarseness_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.80))
    elseif (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
voice_hoarseness = ciid(voice_hoarseness_)
push!(symptoms, "voice_hoarseness" => voice_hoarseness)

function vomiting_(rng)
    return rand(bernoulli(0.1))
end
vomiting = ciid(vomiting_)
push!(symptoms, "vomiting" => vomiting)

function weight_loss_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
weight_loss = ciid(weight_loss_)
push!(symptoms, "weight_loss" => weight_loss)

function wheezing_(rng)
    if (Bool(asthma(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.08))
end
wheezing = ciid(wheezing_)
push!(symptoms, "wheezing" => wheezing)

function white_patches_on_tonsils_(rng)
    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.1))
end
white_patches_on_tonsils = ciid(white_patches_on_tonsils_)
push!(symptoms, "white_patches_on_tonsils" => white_patches_on_tonsils)

# # FIXME: breaks when the symptom is not in the symptoms list


function evaluate_condition1(condition, present_symptoms, sample_counts=10)
    symptoms_condition_true = map(symptom -> replace(symptoms["$symptom"], conditions["$condition"] => true), present_symptoms)
    symptoms_condition_false = map(symptom -> replace(symptoms["$symptom"], conditions["$condition"] => false), present_symptoms)

    # @show present_symptoms

    results_condition_true = rand(tuple(symptoms_condition_true...), sample_counts, alg=RejectionSample)
    results_condition_false = rand(tuple(symptoms_condition_false...), sample_counts, alg=RejectionSample)

    # @show map(ix -> results_condition_true[ix] .- results_condition_false[ix], 1:sample_counts)

    # @show results_condition_true, results_condition_false
end


function evaluate_condition(condition, present_symptoms, sample_counts=1000, age_group=:toddler)
    symptoms_do_condition = map(symptom -> (replace(symptoms["$symptom"], conditions["$condition"] => true, age => age_group), 
        replace(symptoms["$symptom"], conditions["$condition"] => false)), present_symptoms)


    # Refer to the paper, section: Principles for diagnostic reasoning
    mean.(map(symptom -> rand(symptom[1] - symptom[2], sample_counts, alg=RejectionSample), symptoms_do_condition))
end

function raw_samples_evaluate_condition(condition, present_symptoms, sample_counts=500)
    # TODO: Take in age and depend on it


    symptoms_do_condition = map(symptom -> (
        # Make the condition true, and return the symptom dependencies
        replace(symptoms["$symptom"], conditions["$condition"] => true),
        # Make the condition false, and return the symptom dependencies 
        replace(symptoms["$symptom"], conditions["$condition"] => false)),
        present_symptoms)


    # Refer to the paper, section: Principles for diagnostic reasoning
    map(symptom -> rand(symptom[1] - symptom[2], sample_counts, alg=RejectionSample), symptoms_do_condition)
end

function condition_prior(condition="", present_risk_factors=[], absent_risk_factors=[])
    # do_factor = map(factor -> replace(riskfactors["$factor"]), present_risk_factors)
    condition_do_factor = replace(conditions["$condition"], Dict(map(factor -> riskfactors["$factor"] => true, present_risk_factors)))

    rand(condition_do_factor, 1000, alg=RejectionSample)
end

function conditions_prior(conditions, present_risk_factors=[], absent_risk_factors=[])
    map(condition -> mean(condition_prior(condition, present_risk_factors, absent_risk_factors)), conditions)
    # priors = Dict{String,Float32}(map(condition -> condition_prior(condition, present_risk_factors, absent_risk_factors), conditions))
    # for condition in conditions
        # condition_do_factor = replace(conditions["$condition"], Dict(map(factor -> riskfactors["$factor"] => true, present_risk_factors)))
    # end
end

function assess_symptoms(present_symptoms=[], absent_symptoms=[], condition_options=collect(keys(conditions)))
    symptom_mean_effects = map(condition -> evaluate_condition(condition, present_symptoms), condition_options)
    # @show sum(sum(symptom_mean_effects))
    condition_probabilities = 
            Dict{String,Float32}(condition => mean(symptom_mean_effects[idx]) for (idx, condition) in enumerate(condition_options))
end


"""
Patient Assessment Method

    Given: A -> B
    Questions:
        - What is the effect of treating A on B

    parameters: 
        - age
        - present_symptoms
        - absent_symptoms
        - present_risk_factors
        - absent_risk_factors
        - condition_options

    steps:
    1. Find the 3rd principle (Diseases that explain a greater number of the patient’s symptoms should be more likely) value/distribtion
    2. 
"""
function patient_assessment(age=:toddler, present_symptoms=[], absent_symptoms=[], present_risk_factors=[], absent_risk_factors=[], condition_options=collect(keys(conditions)))
    symptom_mean_effects = map(condition -> evaluate_condition(condition, present_symptoms), condition_options)

    # @show conditions_prior(condition_options, present_risk_factors, absent_risk_factors)
    # @show symptom_mean_effects

    condition_probabilities = 
            Dict{String,Float32}(condition => mean(symptom_mean_effects[idx]) for (idx, condition) in enumerate(condition_options))
end

# USAGE
# patient_assessment(:adolescent, ["fever", "cough", "dyspnoea", "tachypnea", "intercostal_drawing"], [], ["obesity"], [], ["pneumonia", "bronchitis"])

# raw_samples_evaluate_condition

#TODO: 
# - Add support for taking in co-morbidities and current conditions (These are different from risk factors!)