using Omega
using Distributions

δ = 0.5

include("./riskfactors.jl")

# categories [<4weeks, 1mo - 1yr, 1yr - 3yrs, 3yrs - 6yrs, 6yrs - 12yrs, 12yrs - 18yrs, 18rs to 59yrs 59+ ]
age_categories = [:neonatal, :infant, :toddler, :preschool, :school, :adolescent, :adult, :elderly]
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

function purpura_(rng)
    if (Bool(sepsis(rng)))
        return rand(bernoulli(0.05)) # TODO: Find reference
    end
    return rand(0.01)
end
purpura = ciid(purpura_)
push!(conditions, "purpura" => purpura)

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

diabetes = bernoulli(0.1)
push!(conditions, "diabetes" => diabetes)

influenza = bernoulli(0.1)
push!(conditions, "influenza" => influenza)

tonsillitis = bernoulli(0.075)
push!(conditions, "tonsillitis" => tonsillitis)

laryngitis = bernoulli(0.075)
push!(conditions, "laryngitis" => laryngitis)

hiv = bernoulli(0.075)
push!(conditions, "hiv" => hiv)

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

function anaemia_(rng)
    if (Bool(gastritis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(dysentery(rng)))
        return rand(bernoulli(0.4))
    elseif (Bool(malaria(rng)))
        return rand(bernoulli(0.5)) # TODO: not in matrices, confirm value
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.05))
end
anaemia = ciid(anaemia_)
push!(conditions, "anaemia" => anaemia)

gastritis = bernoulli(0.075)
push!(conditions, "gastritis" => gastritis)

otitis_media = bernoulli(0.075)
push!(conditions, "otitis_media" => otitis_media)

trichuriasis = bernoulli(0.075)
push!(conditions, "trichuriasis" => trichuriasis)

conjunctivitis = bernoulli(0.075)
push!(conditions, "conjunctivitis" => conjunctivitis)

urinary_tract_infection = bernoulli(0.075)
push!(conditions, "urinary_tract_infection" => urinary_tract_infection)

dysentery = bernoulli(0.075)
push!(conditions, "dysentery" => dysentery)

function malnutrition_(rng)
    if (Bool(dysentery(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.075))
end
malnutrition = ciid(malnutrition_)
push!(conditions, "malnutrition" => malnutrition)


function sepsis_(rng)
    if (Bool(onphalitis(rng)))
        return rand(bernoulli(0.25))
    end
    return rand(bernoulli(0.075))
end
sepsis = ciid(sepsis_)
push!(conditions, "sepsis" => sepsis)

oral_thrush = bernoulli(0.075)
push!(conditions, "oral_thrush" => oral_thrush)

# NOTE: This is only on the body, when on head/genitals its different
# NEXT: depends on age
tinea_corporis = bernoulli(0.075)
push!(conditions, "tinea_corporis" => tinea_corporis)

stomatitis = bernoulli(0.075)
push!(conditions, "stomatitis" => stomatitis)

# anaemia = bernoulli(0.075) # both symptom and disease
# push!(conditions, "anaemia" => anaemia)

# NEXT: depends on age and geography
scabies = bernoulli(0.075)
push!(conditions, "scabies" => scabies)

pediatric_aids = bernoulli(0.075)
push!(conditions, "pediatric_aids" => pediatric_aids)

function dehydration_(rng)
    if (Bool(acute_watery_diarrhoea(rng)))
        return rand(bernoulli(0.70))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.1))
    end
    return rand(bernoulli(0.1))
end
dehydration = ciid(dehydration_)
push!(conditions, "dehydration" => dehydration)

bacteraemia = bernoulli(0.075)
push!(conditions, "bacteraemia" => bacteraemia)

hematoma = bernoulli(0.075)
push!(conditions, "hematoma" => hematoma)


# NOTE: this is combined bollous and nonbollous (current focus)
function impetigo_(rng)
    if Bool(diabetes(rng))
        return rand(bernoulli(0.1))
    elseif Bool(hiv(rng))
        return rand(bernoulli(0.1))
    elseif Bool(scabies(rng))
        return rand(bernoulli(0.20))
    end
    return rand(bernoulli(0.05))
end
impetigo = ciid(impetigo_)
push!(conditions, "impetigo" => impetigo)

meningitis = bernoulli(0.075)
push!(conditions, "meningitis" => meningitis)

# NEXT: this is dependent on environmental factors (temperature, geography, socioeconomic status)
# NEXT: dependent on age
heat_rash = bernoulli(0.075)
push!(conditions, "heat_rash" => heat_rash)

syphillis = bernoulli(0.075)
push!(conditions, "syphillis" => syphillis)


# LARGELY Depends on location of birth (LMIC vs Developed)
function onphalitis_(rng)
    if (rand(age) === :neonatal)
        return rand(bernoulli(0.20))
    end
    return rand(constant(0))
end
onphalitis = ciid(onphalitis_)
push!(conditions, "onphalitis" => onphalitis)

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

function hypoxemia_(rng)
    if (Bool(sepsis(rng)))
        return rand(bernoulli(0.07))
    end
    return rand(bernoulli(0.05))
end
hypoxemia = ciid(hypoxemia_)
push!(conditions, "hypoxemia" => hypoxemia)

##########################################################
# =============== SYMPTOM SPACE ===============
##########################################################
symptoms = Dict{String,Omega.URandVar}()

function abdominal_discomfort_(rng)
    if (Bool(ascariasis(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.05))
end
abdominal_discomfort = ciid(abdominal_discomfort_)
push!(symptoms, "abdominal_discomfort" => abdominal_discomfort)

function abdominal_guarding_(rng)
    if (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.20))
    end
    return rand(bernoulli(0.03))
end
abdominal_guarding = ciid(abdominal_guarding_)
push!(symptoms, "abdominal_guarding" => abdominal_guarding)

# TODO: Investigate the sampling process for age
function abdominal_pain_(rng)
    if (Bool(tonsillitis(rng)) && rand(age) !== :adolescent)
        return rand(bernoulli(0.95))
    elseif (Bool(acute_watery_diarrhoea(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.85))
    elseif (Bool(ascariasis(rng)))
        return rand(bernoulli(0.90))
    elseif (Bool(gastritis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(dysentery(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.9))
    elseif (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.1))
end
abdominal_pain = ciid(abdominal_pain_)
push!(symptoms, "abdominal_pain" => abdominal_pain)

function abdominal_pain_radiates_to_back_(rng)
    if (Bool(gastritis(rng)))
        return rand(bernoulli(0.20))
    end
    return rand(bernoulli(0.01))
end
abdominal_pain_radiates_to_back = ciid(abdominal_pain_radiates_to_back_)
push!(symptoms, "abdominal_pain_radiates_to_back" => abdominal_pain_radiates_to_back)

function abdominal_tenderness_(rng)
    if (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.7))
    elseif (Bool(gastritis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.05))
end
abdominal_tenderness = ciid(abdominal_tenderness_)
push!(symptoms, "abdominal_tenderness" => abdominal_tenderness)


function altered_mental_status_(rng)
    if (Bool(sepsis(rng)))
        return rand(bernoulli(0.25))
    end
    return rand(bernoulli(0.05))
end
altered_mental_status = ciid(altered_mental_status_)
push!(symptoms, "altered_mental_status" => altered_mental_status)

function back_pain_(rng)
    if (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.1))
end
back_pain = ciid(back_pain_)
push!(symptoms, "back_pain" => back_pain)

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
        return rand(constant(0.0))
    elseif (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(sepsis(rng)))
        if (rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
            return rand(bernoulli(0.4))
        end
        return rand(bernoulli(0.6))
    end
    return rand(bernoulli(0.05))
end
blood_stained_sputum = ciid(blood_stained_sputum_)
push!(symptoms, "blood_stained_sputum" => blood_stained_sputum)

function blood_stained_stool_(rng)
    if (Bool(dysentery(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.01))
end
blood_stained_stool = ciid(blood_stained_stool_)
push!(symptoms, "blood_stained_stool" => blood_stained_stool)

function body_weakness_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.1))
end
body_weakness = ciid(body_weakness_)
push!(symptoms, "body_weakness" => body_weakness)

function bradycardia_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.3))
    elseif (Bool(sepsis(rng)) && rand(age) in [:neonatal, :infant])
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
bradycardia = ciid(bradycardia_)
push!(symptoms, "bradycardia" => bradycardia)

function brown_skin_patches_(rng)
    if !Bool(skin_patches(rng))
        return rand(constant(0.0))
    end

    if Bool(tinea_nigra(rng))
        return rand(constant(1.0))
    end
    return rand(bernoulli(0.02))
end
brown_skin_patches = ciid(brown_skin_patches_)
push!(symptoms, "brown_skin_patches" => brown_skin_patches)

function central_cyanosis_(rng)
    return rand(bernoulli(0.1))
end
central_cyanosis = ciid(central_cyanosis_)
push!(symptoms, "central_cyanosis" => central_cyanosis)

function chest_pain_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.7))
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
    elseif (Bool(malaria(rng)))
        return rand(bernoulli(0.65))
    end
    return rand(bernoulli(0.1))
end
chills = ciid(chills_)
push!(symptoms, "chills" => chills)

function coma_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.35))
    elseif (Bool(dysentery(rng)))
        return rand(bernoulli(0.2))
    elseif (Bool(sepsis(rng)) && rand(age) === :neonatal)
        return rand(bernoulli(0.80))
    end
    return rand(bernoulli(0.03))
end
coma = ciid(coma_)
push!(symptoms, "coma" => coma)

function confusion_(rng)
    if (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.1))
    end
    return rand(bernoulli(0.05))
end
confusion = ciid(confusion_)
push!(symptoms, "confusion" => confusion)

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
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.10))
    end
    return rand(bernoulli(0.07))
end
cough = ciid(cough_)
push!(symptoms, "cough" => cough)

function convulsions_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(sepsis(rng))) 
        if (rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
            return rand(bernoulli(0.90))
        end
        return rand(bernoulli(0.1))
    end
    return rand(bernoulli(0.1))
end
convulsions = ciid(convulsions_)
push!(symptoms, "convulsions" => convulsions)

function cotton_feeling_in_mouth_(rng)
    if (Bool(oral_thrush(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.1))
end
cotton_feeling_in_mouth = ciid(cotton_feeling_in_mouth_)
push!(symptoms, "cotton_feeling_in_mouth" => cotton_feeling_in_mouth)

function crackles_(rng)
    if (Bool(pneumonia(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.01))
end
crackles = ciid(crackles_)
push!(symptoms, "crackles" => crackles)

function dark_urine_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.4))
    end
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
    if (Bool(influenza(rng)))
        if (rand(age) !== :adolescent)
            return rand(bernoulli(0.4))
        end
        return rand(bernoulli(0.2))
    elseif (Bool(acute_watery_diarrhoea(rng)))
        return rand(bernoulli(0.99))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.90))
    elseif (Bool(ascariasis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(dysentery(rng)))
        return rand(bernoulli(0.99))
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(sepsis(rng)))
        if (rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
            return rand(bernoulli(0.8))
        end
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.05))
end
diarrhea = ciid(diarrhea_)
push!(symptoms, "diarrhea" => diarrhea)

function dry_mouth_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.1))
end
dry_mouth = ciid(dry_mouth_)
push!(symptoms, "dry_mouth" => dry_mouth)

function dysuria_(rng)
    if (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.1))
end
dysuria = ciid(dysuria_)
push!(symptoms, "dysuria" => dysuria)

function ear_pain_(rng)
    if (Bool(otitis_media(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.03))
end
ear_pain = ciid(ear_pain_)
push!(symptoms, "ear_pain" => ear_pain)

function ear_discharge_(rng)
    if (Bool(otitis_media(rng)))
        return rand(bernoulli(0.3))
    end
    return rand(bernoulli(0.03))
end
ear_discharge = ciid(ear_discharge_)
push!(symptoms, "ear_discharge" => ear_discharge)

function epigastric_pain_(rng)
    if (Bool(gastritis(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.1))
end
epigastric_pain = ciid(epigastric_pain_)
push!(symptoms, "epigastric_pain" => epigastric_pain)

function excessive_thirst_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.05))
end
excessive_thirst = ciid(excessive_thirst_)
push!(symptoms, "excessive_thirst" => excessive_thirst)

function eye_discharge_(rng)
    if (Bool(conjunctivitis(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.05))
end
eye_discharge = ciid(eye_discharge_)
push!(symptoms, "eye_discharge" => eye_discharge)

function multiple_daily_stools_(rng)
    if (Bool(acute_watery_diarrhoea(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.1))
end
multiple_daily_stools = ciid(multiple_daily_stools_)
push!(symptoms, "multiple_daily_stools" => multiple_daily_stools)

function difficulty_swallowing_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.80))
    elseif (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(oral_thrush(rng)))
        return rand(bernoulli(0.6))
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
        return rand(constant(0.0))
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
    if (Bool(sepsis(rng)))
        # FIXME: Test this method to see that it works
        if (rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
            return rand(bernoulli(0.99))
        end
        return rand(bernoulli(0.90))
    elseif (Bool(pneumonia(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(malaria(rng)))
        return rand(bernoulli(0.92))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.15))
    elseif (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.6))
    elseif (Bool(otitis_media(rng)))
        return rand(bernoulli(0.4))
    elseif (Bool(dysentery(rng)))
        return rand(bernoulli(0.55))
    elseif (Bool(conjunctivitis(rng)))
        return rand(bernoulli(0.25))
    elseif (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.8))
    elseif Bool(impetigo(rng))
        return rand(bernoulli(0.95))
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

function frequent_urination_(rng)
    if (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.1))
end
frequent_urination = ciid(frequent_urination_)
push!(symptoms, "frequent_urination" => frequent_urination)

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
    elseif (Bool(malaria(rng)))
        return rand(bernoulli(0.6))
    elseif (Bool(otitis_media(rng)))
        return rand(bernoulli(0.3))
    end
    return rand(bernoulli(0.1))
end
headache = ciid(headache_)
push!(symptoms, "headache" => headache)

function hematemesis_(rng)
    if (Bool(gastritis(rng)) && Bool(vomiting(rng)))
        return rand(bernoulli(0.3))
    end
    return rand(bernoulli(0.1))
end
hematemesis = ciid(hematemesis_)
push!(symptoms, "hematemesis" => hematemesis)

function high_grade_fever_(rng)
    if !Bool(fever(rng))
        return rand(constant(0.0))
    end

    if (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.8))
    elseif Bool(impetigo(rng))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.1))
end
high_grade_fever = ciid(high_grade_fever_)
push!(symptoms, "high_grade_fever" => high_grade_fever)

function hypoglycaemia_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.5))
    end
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
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.4))
    elseif (Bool(sepsis(rng)) && rand(age) !== :neonatal)
        return rand(bernoulli(0.21))
    end
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

function irritable_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.7))
    elseif (Bool(gastroenteritis(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
irritable = ciid(irritable_)
push!(symptoms, "irritable" => irritable)

function irregular_skin_patches_(rng)
    if !Bool(skin_patches)
        return rand(constant(0.0))
    end

    if (Bool(tinea_nigra(rng)))
        return rand(constant(1.0))
    end
    return rand(bernoulli(0.05))
end
irregular_skin_patches = ciid(irregular_skin_patches_)
push!(symptoms, "irregular_skin_patches" => irregular_skin_patches)

function itchy_eyes_(rng)
    if (Bool(conjunctivitis(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.05))
end
itchy_eyes = ciid(itchy_eyes_)
push!(symptoms, "itchy_eyes" => itchy_eyes)

function jaundice_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.4))
    end
    return rand(bernoulli(0.1))
end
jaundice = ciid(jaundice_)
push!(symptoms, "jaundice" => jaundice)

function laboured_breathing_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.25))
    end
    return rand(bernoulli(0.1))
end
laboured_breathing = ciid(laboured_breathing_)
push!(symptoms, "laboured_breathing" => laboured_breathing)

function lethargy_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.85))
    elseif (Bool(acute_watery_diarrhoea(rng)))
        return rand(bernoulli(0.4))
    elseif (Bool(dehydration(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(dysentery(rng)))
        return rand(bernoulli(0.55))
    elseif (Bool(sepsis(rng)) && rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
        return rand(bernoulli(0.99))
    end
    return rand(bernoulli(0.5))
end
lethargy = ciid(lethargy_)
push!(symptoms, "lethargy" => lethargy)

function loss_of_appetite_(rng)
    if (Bool(malnutrition(rng)))
        return rand(bernoulli(0.80))
    elseif (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(ascariasis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.1))
end
loss_of_appetite = ciid(loss_of_appetite_)
push!(symptoms, "loss_of_appetite" => loss_of_appetite)

function loss_of_consciousness_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.3))
    end
    return rand(bernoulli(0.01))
end
loss_of_consciousness = ciid(loss_of_consciousness_)
push!(symptoms, "loss_of_consciousness" => loss_of_consciousness)

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
    if !Bool(fever(rng))
        return rand(constant(0.0))
    end

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

# function malaise_(rng)
#     if (Bool(tuberculosis(rng)))
#         return rand(bernoulli(0.9))
#     end
#     return rand(bernoulli(0.1))
# end
# malaise = ciid(malaise_)
# push!(symptoms, "malaise" => malaise)

function malaise_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
malaise = ciid(malaise_)
push!(symptoms, "malaise" => malaise)

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
    if (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.93))
    elseif (Bool(ascariasis(rng)))
        return rand(bernoulli(0.65))
    elseif (Bool(gastritis(rng)))
        return rand(bernoulli(0.6))
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.75))
    end
    return rand(bernoulli(0.05))
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

function oliguria_(rng)
    if (Bool(sepsis(rng)))
        if (rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
            return rand(bernoulli(0.85))
        end
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.05))
end
oliguria = ciid(oliguria_)
push!(symptoms, "oliguria" => oliguria)

function pallor_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.8))
    elseif (Bool(sepsis(rng) && rand(age) === :neonatal))
        return rand(bernoulli(0.7))
    end
    return rand(bernoulli(0.1))
end
pallor = ciid(pallor_)
push!(symptoms, "pallor" => pallor)

function palpitations_(rng)
    if (Bool(sepsis(rng)) && rand(age) in [:adolescent, :adult, :elderly])
        return rand(bernoulli(0.7))
    end
    return rand(bernoulli(0.1))
end
palpitations = ciid(palpitations_)
push!(symptoms, "palpitations" => palpitations)

function papules_(rng)
    if (Bool(heat_rash(rng)))
        return rand(bernoulli(0.7))
    elseif (Bool(scabies(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.05))
end
papules = ciid(papules_)
push!(symptoms, "papules" => papules)

function extremity_papules_(rng)
    if !(Bool(papules(rng))) 
        return constant(0)
    end

    if (Bool(scabies(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.05))
end
extremity_papules = ciid(extremity_papules_)
push!(symptoms, "extremity_papules" => extremity_papules)

function genital_papules_(rng)
    if !(Bool(papules(rng))) 
        return constant(0)
    end

    if (Bool(scabies(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.05))
end
genital_papules = ciid(genital_papules_)
push!(symptoms, "genital_papules" => genital_papules)


function poor_feeding_(rng)
    if (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.8)) # TODO: check if this is age specific
    elseif (Bool(sepsis(rng)) && rand(age) === :neonatal)
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
poor_feeding = ciid(poor_feeding_)
push!(symptoms, "poor_feeding" => poor_feeding)

function productive_cough_(rng)
    if (!Bool(cough(rng)))
        return rand(constant(0.0))
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
        return rand(constant(0.0))
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

function pruritus_(rng)
    if (Bool(heat_rash(rng)))
        return rand(bernoulli(0.60))
    elseif (Bool(scabies(rng)))
        return rand(constant(1.0))
    elseif (Bool(tinea_corporis(rng)))
        return rand(bernoulli(0.8))
    elseif Bool(impetigo(rng))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.03))
end
pruritus = ciid(pruritus_)
push!(symptoms, "pruritus" => pruritus)

function pruritus_worse_at_night_(rng)
    if (Bool(scabies(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.03))
end
pruritus_worse_at_night = ciid(pruritus_worse_at_night_)
push!(symptoms, "pruritus_worse_at_night" => pruritus_worse_at_night)

function rectal_prolapse_(rng)
    if (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.3))
    end
    return rand(bernoulli(0.01))
end
rectal_prolapse = ciid(rectal_prolapse_)
push!(symptoms, "rectal_prolapse" => rectal_prolapse)

function prolonged_capillary_refill_time_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.7))
    end
    return rand(bernoulli(0.1))
end
prolonged_capillary_refill_time = ciid(prolonged_capillary_refill_time_)
push!(symptoms, "prolonged_capillary_refill_time" => prolonged_capillary_refill_time)

function red_eyes_(rng)
    if (Bool(conjunctivitis(rng)))
        return rand(bernoulli(0.98))
    end
    return rand(bernoulli(0.075))
end
red_eyes = ciid(red_eyes_)
push!(symptoms, "red_eyes" => red_eyes)

function red_skin_(rng)
    if (Bool(heat_rash(rng)))
        return rand(bernoulli(0.99))
    end
    return rand(bernoulli(0.075))
end
red_skin = ciid(red_skin_)
push!(symptoms, "red_skin" => red_skin)

function reduced_skin_turgor_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.7))
    end
    return rand(bernoulli(0.1))
end
reduced_skin_turgor = ciid(reduced_skin_turgor_)
push!(symptoms, "reduced_skin_turgor" => reduced_skin_turgor)

# kids cant speak
function refusal_to_eat_(rng)
    if (Bool(tonsillitis(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.5))
    elseif (Bool(sepsis(rng)) && rand(age) in [:infant, :toddler, :preschool, :school])
        return rand(bernoulli(0.75))
    end
    return rand(bernoulli(0.1))
end
refusal_to_eat = ciid(refusal_to_eat_)
push!(symptoms, "refusal_to_eat" => refusal_to_eat)

function restless_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.1))
end
restless = ciid(restless_)
push!(symptoms, "restless" => restless)

function rhinorrhea_(rng)
    if (Bool(coryza(rng)))
        return rand(bernoulli(0.85))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.8))
    elseif (Bool(sinusitis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.10))
    elseif (Bool(conjunctivitis(rng)))
        return (rand(bernoulli(0.3)))
    end
    return rand(bernoulli(0.1))
end
rhinorrhea = ciid(rhinorrhea_)
push!(symptoms, "rhinorrhea" => rhinorrhea)

function ring_shaped_skin_patches_(rng)
    if (Bool(tinea_corporis(rng)))
        return rand(constant(1.0))
    end
    return rand(bernoulli(0.05))
end
ring_shaped_skin_patches = ciid(ring_shaped_skin_patches_)
push!(symptoms, "ring_shaped_skin_patches" => ring_shaped_skin_patches)

function seizures_(rng)
    if (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.10))
    end
    return rand(bernoulli(0.01))
end
seizures = ciid(seizures_)
push!(symptoms, "seizures" => seizures)

function skin_burrows_(rng)
    if (Bool(scabies(rng)))
        return rand(bernoulli(0.75))
    end
    return rand(bernoulli(0.05))
end
skin_burrows = ciid(skin_burrows_)
push!(symptoms, "skin_burrows" => skin_burrows)

function skin_crusts_(rng)
    if (Bool(scabies(rng)))
        return rand(bernoulli(0.15))
    elseif Bool(impetigo(rng))
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.05))
end
skin_crusts = ciid(skin_crusts_)
push!(symptoms, "skin_crusts" => skin_crusts)

function yellow_skin_crusts_(rng) 
    if !Bool(skin_crusts(rng))
        return rand(constant(0.0))
    end

    if Bool(impetigo(rng))
        return rand(bernoulli(0.99))
    end
    return rand(bernoulli(0.05))
end
yellow_skin_crusts = ciid(yellow_skin_crusts_)
push!(symptoms, "yellow_skin_crusts" => yellow_skin_crusts)

function skin_patches_(rng)
    if (Bool(tinea_corporis(rng)))
        return rand(constant(1.0))
    elseif Bool(tinea_nigra(rng))
        return rand(constant(1.0))
    end
    return rand(bernoulli(0.05))
end
skin_patches = ciid(skin_patches_)
push!(symptoms, "skin_patches" => skin_patches)


function skin_rash_(rng)
    if (Bool(heat_rash(rng)))
        return rand(bernoulli(0.99))
    end
    return rand(bernoulli(0.05))
end
skin_rash = ciid(skin_rash_)
push!(symptoms, "skin_rash" => skin_rash)

function skin_ulcers_(rng)
    if Bool(impetigo(rng))
        return rand(bernoulli(0.1))
    end
    return rand(bernoulli(0.01))
end
skin_ulcers = ciid(skin_ulcers_)
push!(symptoms, "skin_ulcers" => skin_ulcers)


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
        return rand(bernoulli(0.75))
    elseif (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.95))
    elseif (Bool(coryza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(influenza(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(bronchitis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.10))
    elseif (Bool(conjunctivitis(rng)))
        return rand(bernoulli(0.3))
    end
    return rand(bernoulli(0.1))
end
sore_throat = ciid(sore_throat_)
push!(symptoms, "sore_throat" => sore_throat)

function sunken_eyes_(rng)
    if (Bool(dehydration(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.05))
end
sunken_eyes = ciid(sunken_eyes_)
push!(symptoms, "sunken_eyes" => sunken_eyes)

function swollen_eyes_(rng)
    if (Bool(conjunctivitis(rng)))
        return rand(bernoulli(0.8))
    end
    return rand(bernoulli(0.05))
end
swollen_eyes = ciid(swollen_eyes_)
push!(symptoms, "swollen_eyes" => swollen_eyes)

function swollen_tongue_(rng)
    if (Bool(oral_thrush(rng)))
        return rand(bernoulli(0.2))
    end
    return rand(bernoulli(0.1))
end
swollen_tongue = ciid(swollen_tongue_)
push!(symptoms, "swollen_tongue" => swollen_tongue)

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
    elseif (Bool(dehydration(rng)))
        return rand(bernoulli(0.3))
    elseif (Bool(sepsis(rng)))
        if (rand(age) === :neonatal)
            return rand(bernoulli(0.99))
        end
        return rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.01))
end
tachypnea = ciid(tachypnea_)
push!(symptoms, "tachypnea" => tachypnea)

function tachycardia_(rng)
    if (Bool(sepsis(rng)) && !(rand(age) in [:neonatal, :infant]))
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.04))
end
tachycardia = ciid(tachycardia_)
push!(symptoms, "tachycardia" => tachycardia)

function tender_anterior_neck_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.85))
    end
    return rand(bernoulli(0.1))
end
tender_anterior_neck = ciid(tender_anterior_neck_)
push!(symptoms, "tender_anterior_neck" => tender_anterior_neck)

function unable_to_drink_(rng)
    if (Bool(oral_thrush(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.6))
    end
    return rand(bernoulli(0.1))
end
unable_to_drink = ciid(unable_to_drink_)
push!(symptoms, "unable_to_drink" => unable_to_drink)

function unable_to_feed_(rng)
    if (Bool(malaria(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.8))
    elseif (Bool(oral_thrush(rng)) && (rand(age) == :neonatal || rand(age) === :infant || rand(age) === :toddler))
        return rand(bernoulli(0.6))
    end
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

function vesicles_(rng)
    if (Bool(heat_rash(rng)))
        return rand(bernoulli(0.6))
    elseif Bool(impetigo(rng))
        constant(1.0)
    end
    return rand(bernoulli(0.05))
end
vesicles = ciid(vesicles_)
push!(symptoms, "vesicles" => vesicles)

function painful_vesicles_(rng)
    if !(Bool(vesicles(rng)))
        return rand(constant(0.0))
    end

    if Bool(impetigo(rng))
        rand(bernoulli(0.95))
    end
    return rand(bernoulli(0.05))
end
painful_vesicles = ciid(painful_vesicles_)
push!(symptoms, "painful_vesicles" => painful_vesicles)


function voice_hoarseness_(rng)
    if (Bool(laryngitis(rng)))
        return rand(bernoulli(0.85))
    elseif (Bool(tonsillitis(rng)))
        return rand(bernoulli(0.5))
    end
    return rand(bernoulli(0.03))
end
voice_hoarseness = ciid(voice_hoarseness_)
push!(symptoms, "voice_hoarseness" => voice_hoarseness)

function vomiting_(rng)
    if (Bool(malaria(rng)))
        return rand(bernoulli(0.8))
    elseif (Bool(gastroenteritis(rng)))
        return rand(bernoulli(0.90))
    elseif (Bool(gastritis(rng)))
        return rand(bernoulli(0.5))
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.2))
    elseif (Bool(urinary_tract_infection(rng)))
        return rand(bernoulli(0.4))
    elseif (Bool(sepsis(rng)))
        if (rand(age) in [:neonatal, :infant, :toddler, :preschool, :school])
            return rand(bernoulli(0.70))
        end
        return rand(bernoulli(0.6))
    end
    return rand(bernoulli(0.1))
end
vomiting = ciid(vomiting_)
push!(symptoms, "vomiting" => vomiting)

function weak_cry_(rng)
    if (Bool(altered_mental_status(rng)) && rand(age) in [:neonatal, :infant]) 
        return rand(bernoulli(0.9))
    end
    return rand(bernoulli(0.01))
end
weak_cry = ciid(weak_cry_)
push!(symptoms, "weak_cry" => weak_cry)

function wheals_(rng)
    if (Bool(heat_rash(rng)))
        return rand(bernoulli(0.90))
    end
    return rand(bernoulli(0.05))
end
wheals = ciid(wheals_)
push!(symptoms, "wheals" => wheals)

function weight_loss_(rng)
    if (Bool(tuberculosis(rng)))
        return rand(bernoulli(0.9))
    elseif (Bool(malnutrition(rng)))
        return rand(bernoulli(0.9))
    elseif (Bool(malaria(rng)))
        return rand(bernoulli(0.8))
    elseif (Bool(ascariasis(rng)))
        return rand(bernoulli(0.50))
    elseif (Bool(trichuriasis(rng)))
        return rand(bernoulli(0.4))
    elseif (Bool(sepsis(rng)) && rand(age) === :neonatal)
        return rand(bernoulli(0.6))
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

function white_patches_in_mouth_(rng)
    if (Bool(oral_thrush(rng)))
        return rand(constant(1.0))
    end
    return rand(bernoulli(0.1))
end
white_patches_in_mouth = ciid(white_patches_in_mouth_)
push!(symptoms, "white_patches_in_mouth" => white_patches_in_mouth)

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

        # function checker(a, b)
        #     @show a, b
        #     a - b
        # end

        # function simple_sample(symptom)
        #     println("$symptom")
        #     pres, abs = rand(symptom[1] - symptom[2], sample_counts, alg=RejectionSample)
        #     @show pres, abs
        #     pres - abs
        # end

    Δs = map(symptom -> max.(rand(symptom[1] - symptom[2], sample_counts, alg=RejectionSample), 0), symptoms_do_condition)
    # Δs = map(symptom -> simple_sample(symptom), symptoms_do_condition)
    # Δs = map(symptom -> rand(symptom[1] - symptom[2], sample_counts, alg=RejectionSample), symptoms_do_condition)

    # @show Δs

    # @show condition
    # Refer to the paper, section: Principles for diagnostic reasoning
    # @show fit.(Normal, Δs)
    mean.(Δs)
end

function treatment_sim(condition, present_symptoms, sample_counts=5000, age_group=:toddler)
    symptoms_treated_condition = map(symptom -> replace(symptoms["$symptom"], conditions["$condition"] => false, age => age_group), present_symptoms)
    symptoms_treated_condition_pres = map(symptom -> replace(symptoms["$symptom"], conditions["$condition"] => true, age => age_group), present_symptoms)

    
    @time symptom_samples = collect.(rand(tuple(symptoms_treated_condition...), sample_counts, alg=RejectionSample))
    # @time symptom_samples_pres = rand(tuple(symptoms_treated_condition_pres...), sample_counts, alg=RejectionSample)

    # Soln 1
    # reshaped_samples = hcat(symptom_samples...)
    # [fit(Bernoulli, sample_data) for sample_data in eachrow(reshaped_samples)]

    sum(sum(symptom_samples)) / (sample_counts * length(present_symptoms))
    # sum(symptom_samples)
    # []
end

function raw_samples_evaluate_condition(condition, present_symptoms, sample_counts=500)
    # TODO: Take in age and depend on it


    symptoms_do_condition = map(symptom -> (replace(symptoms["$symptom"], conditions["$condition"] => true),
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

# println(collect(keys(conditions)))

# @show length(conditions)

# symps = ["fever", "sore_throat", "difficulty_swallowing", "voice_hoarseness"]
# conds = ["malaria", "gastroenteritis", "tonsillitis", "pneumonia", "otitis_media", "laryngitis"]
# USAGE
# @time patient_assessment(:adolescent, ["cough", "prologned_cough", "chest_pain", "night_sweats", "fever", "weight_loss", "blood_stained_sputum", "malaise"], [], [], [], ["malaria", "gastroenteritis", "tonsillitis", "pneumonia", "otitis_media", "tuberculosis"])
# @time assess_symptoms(["cough", "prologned_cough", "night_sweats", "fever", "weight_loss", "blood_stained_sputum", "malaise", "tachypnea", "voice_hoarseness"], [], ["tuberculosis"])
# @time patient_assessment(:adolescent, symps, [], [], collect(keys(conditions)))
# @time patient_assessment(:adolescent, collect(keys(symptoms))[1:10], [], [], [])

# no_cond = collect.(rand(tuple(map(sym -> symptoms["$sym"], symps)...), 5000, alg=RejectionSample))
# reshaped_samples = hcat(no_cond...)
# @show mean([fit(Bernoulli, sample_data).p for sample_data in eachrow(reshaped_samples)])
# 
# @time map(condition -> (treatment_sim(condition, symps), condition), ["malaria", "gastritis", "tonsillitis", "pneumonia", "otitis_media", "laryngitis"])
# @time map(condition -> sim -> sim.p, treatment_sim(condition, symps), condition), conds)

# raw_samples_evaluate_condition

# TODO: 
# - Add support for taking in co-morbidities and current conditions (These are different from risk factors!)


# TODO: EXPERIMENT with not turning on the symptom space and just looking at the difference between patient presentation and other patient simulations from absent disease