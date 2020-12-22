using Omega
using UnicodePlots

#= 
Observed
Symptoms: 
    Chest Pain
    Dyspnoea
    Exudate Sputum (productive Cough)
    Fever

    (In general)
    Confusion/Malaise
    Fever/Chills
    Rigor
    Tachycardia
    Tachypnoea/Dyspnoea ✓
    Cough (Productive) ✓
    Vomiting
    Diarrhhea

Risk Factors
    Older than 65 Years
    Smoking (damages the cilia affecting the Mucosciliary apparatus, and also causes increased mucus production)
    Malnourished
    Underlying Lung Disease
    Immunocompromised
    Some Medications
    Recent Respiratory Infections

Investigations
    Full Blood Picture
        Neutrophilia - Increased Neutrophile count in body circulation
            - A strong indicator of bacterial infections
        Increased/Decreased WBC count indicates severity
        Haemolytic anaemia
            - Suggests Mycoplasma Pneumonia as the cause
    Chest Xray (Visual only)
    Sputum Testing (GRAM StAIN)
        - Identify Bacteria
    Urine Antigen Testing
        Identify Bacteria
    Blood Culture
        - Bacterimea, Identify the bacteria =#

#= 
Personal risk factors (Impaired Pulmonary Defenses)
Loss of cough reflex
    comma, anasthesia, state of being intoxicated
Injured Mucosciliary Apparatus
    smoking
Decreased Alveolar Macrophages
    Alcohol and smoking
Pulmonary  Congestion/Oedema
Accumulation of Secretions - Acystic Fibrosis


Bacterial
    Enters the alveoli
    Initiates Immune Response
    Macrophages Recognise bacteria and release cytokines
        Interluken-1 and tnf-alpha
            - Results in vasodiatlation
            - and vascular dialation
                These both cause fluid congestion inside the alveoli

Virus (Similar to Bacteria)
    Virus enters the alveoli
    Infects the Respiratory cells
        (releases genetic material and uses host materials to replicate)
    Infected cells lice (explode) and release the new virues
    Celluar debris in alveoli
    Alveolar Macrophages respond by releasing cytokines
        Interluken-1 and tnf-alpha
            - Results in vasodiatlation
            - and vascular dialation
                These both cause fluid congestion inside the alveoli

Fungal
    Inhale spores into the alveoli
    Grows into a "fungal ball" - visibal from the xray
        consists of fungs, mucus, and cellular debris
        (The environment in the alveoli is perfect for fungal growth)
    Can spread into the blood system and cause system issues =#

#= 
Defense Systems
    Cough Reflex
    Alveolar Macrophages
    Mucosciliary Apparatus
        Cilated cells
        Mucus
        +IgA antibodies
    Mucus Secretions
    gA Antibodies
    MicroFlaura
    Nose Hairs


Causative Agents (more likely to cause problems when the defense systems are compromised)
    Bacteria
        Strep
        Haemophilus Influenza
        Staph
        Mycoplasma
    Viruses
        Influenza
        Respiratory Sensic... Virus
    Fungi (less common in general, more common in Immunocompromised) =#

#= 
Pneumonia
Fluid filled alveoli (consolidation)
    Process that fills the alveoli with fluid, pus, blood, cells resulting in
    lobar diffuse opacities
Narrowing of the Airways
Broncho constriction
Increased mucus production (in broncioles) =#

#= 
Resources
http://dspace.muhas.ac.tz:8080/xmlui/handle/123456789/1138?show=full#:~:text=The%20prevalence%20of%20severe%20pneumonia,prevalence%20of%20hypoxaemia%20was%2025%25.
https://www.youtube.com/watch?v=b8_83UDfbbU
https://www.youtube.com/watch?v=IAQp2Zuqevc =#

#= 
Notes, TODOs and FIXMES:
1. Consider including different types of causes in the models =#


region = uniform([:arusha, :dar, :mwanza, :morogoro])
season = uniform([:wet, :dry])

sex = bernoulli(0.5)

# Age is set to the national average (+/- 5)
age = normal(17, 5)

# has_pneumonia = bernoulli(0.2, Bool)

# Is the patient a smoker?
# is_smoker = bernoulli(0.5, Bool)
function is_smoker_(rng)
    if sex(rng) >= 0.5
        # bernoulli(0.5)
        if age(rng) < 17
            rand(bernoulli(0.5, Bool))
        else
            rand(bernoulli(0.2, Bool))
        end
    else
        # bernoulli(0.25)
        rand(bernoulli(0.25, Bool))
    end
end
is_smoker = ciid(is_smoker_)



# Missing Variables
# Immunocompromised, recent respiratory infection, mulnourished, Underlying lung disease, some Medications

# Injured Mucosciliary Apparatus
function injured_mucosciliary_apparatus_(rng)
    if Bool(is_smoker(rng))
        rand(bernoulli(0.85, Bool))
    else
        rand(bernoulli(0.1, Bool))
    end
end
injured_mucosciliary_apparatus = ciid(injured_mucosciliary_apparatus_)


function has_pneumonia_(rng)
    if Bool(injured_mucosciliary_apparatus(rng))
        rand(bernoulli(0.5, Bool))
    else
        rand(bernoulli(0.25, Bool))
    end
end
has_pneumonia = ciid(has_pneumonia_)


function has_fever_(rng)
    if Bool(has_pneumonia(rng))
        rand(bernoulli(0.95, Bool))
    else
        rand(bernoulli(0.35, Bool))
    end
end
has_fever = ciid(has_fever_)

function has_chest_pain_(rng)
    if Bool(has_pneumonia(rng))
        rand(bernoulli(0.95, Bool))
    else
        rand(bernoulli(0.15, Bool))
    end
end
has_chest_pain = ciid(has_chest_pain_)


function has_dyspnoea_(rng)
    if Bool(has_pneumonia(rng))
        rand(bernoulli(0.95, Bool))
    else
        rand(bernoulli(0.15, Bool))
    end
end
has_dyspnoea = ciid(has_dyspnoea_)

function has_productive_cough_(rng)
    if Bool(has_pneumonia(rng))
        rand(bernoulli(0.95, Bool))
    else
        rand(bernoulli(0.3, Bool))
    end
end
has_productive_cough = ciid(has_productive_cough_)

function has_tachychardia_(rng)
    if Bool(has_pneumonia(rng))
        rand(bernoulli(0.85, Bool))
    else
        rand(bernoulli(0.25, Bool))
    end
end
has_tachychardia = ciid(has_tachychardia_)

# has_dyspnoea_new, has_fever_new, has_tachychardia_new = replace([has_dyspnoea, has_fever, has_tachychardia], has_pneumonia => 1.0)

PneumoniaPresent = true

has_chest_pain_new = replace(has_chest_pain, has_pneumonia => PneumoniaPresent)
has_dyspnoea_new = replace(has_dyspnoea, has_pneumonia => PneumoniaPresent)
has_fever_new = replace(has_fever, has_pneumonia => PneumoniaPresent)
has_tachychardia_new = replace(has_tachychardia, has_pneumonia => PneumoniaPresent)
has_productive_cough_new = replace(has_productive_cough, has_pneumonia => PneumoniaPresent)


samples = rand((has_dyspnoea_new, has_fever_new, has_tachychardia_new, has_chest_pain_new, has_productive_cough_new), 6, alg=RejectionSample)
# samples = rand((has_dyspnoea, has_fever, has_tachychardia, has_chest_pain, has_productive_cough), 6, alg=RejectionSample)
# diffsamples = rand(has_productive_cough_new - has_productive_cough, 10000, alg = RejectionSample)
# mean(diffsamples)
# mean(samples)

# UnicodePlots.histogram([samples...], nbins=3)