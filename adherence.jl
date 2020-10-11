using Omega
using Distributions

#= 
Stigma (Internalized/External)	Yes/ No	Presence leads to not disclosing status
Marital status	Married, Divorced, Single	Having a life partner makes it likely to have a support system in place and disclosing status
Has dependents /children	Yes/ No	Having dependent gives motivation to work on your health
Disclosed status	Yes/ No	Disclosing makes you have a support system in place who are aware of what you are going through and thus offer help
HIV-infected person(s) in household	Yes/ No	Helps to add on support system but also can mean sharing drugs
Share drugs	Yes/ No	Sharing drugs with another PLHIV
Support System	Yes/ No	Provides support emotionally, physically + reminders 
Motivation	High/ Low	Gives reason to adhere
Gender	Male/ Female	Identifies as what gender
Pregnancy	Yes/ No	Pregnancy provides motivation to adhere
Delivery of HIV- newborn 	Yes/ No	Mothers are less motivated to adhere after safe delivery
Age	Continous variable	Age determines dependency (employment/income generation) and education level
Education level	No education, primary, secondary, tertiary	Educated can mean ability to follow instructions related to the treatment
Employment status	Not employed, employed, retired	Determines ability to generate income, nature of employment determines travel and work times
Income	High/ Low	Affording costs related to staying on treatment
Has cellphone (Direct contact means)	Yes/ No	CTC can contact for reminders
Reminders	Yes/ No	Alarms, messages for next appointments, support system effort
Forget dosage	Yes/ No	Not taking dosage due to forgetfulness
Travel	Yes/ No	Going far from registered CTC can cause missing appointments and running out of pills when away
Run out of pills	Yes/ No	Not enough pills to finish dosage either due to exceeding dosage time (days) or having shared them
Transport cost / distance to treatment sites	High/ Low	Not affording related costs to reach CTC
CTC service satisfaction	Yes/ No	How the patient feels about the service given by CTC caregivers, nurses, doctors
Attends next CTC appointment/ Drug refill	Yes/ No	Going to CTC for therapy and/or drug refill (missed appoinetments)
Knowledge on ART use	Yes/ No	Has knowledge on the how's, why's, what's & when with respect to ART (dosage & therapy)
Food insecurity	Yes/ No	Can afford and follows the required dietary requirement
Alcohol intake	Yes/ No	Drinks alcohol
Drug use	Yes/ No	Uses drugs
Regimen Type	Various	The type of regimen administered
Pill count (Dose fatigue)	High/ Low	The number of pills required to take
Side effects	Yes/ No	Experiences effects caused by the medication given
Perceived harmfulness	High/ Low	The feelings that the medication is harmful to self
Religion (Belief system)	Yes/ No	Belongs to a certain belief system 
Use of alternative medications	Yes/ No	Using other medications, remedies or methods to combat HIV
Perceived effectiveness	High/ Low	The feelings that the medication is working
CD4 count	Continous variable	Determines the robustness of the immune system
Physical wellbeing	Good/ Bad	Feeling stronger or weaker physically  than before
Duration on ART	Time - No. of Days	Time since start of ART
Time taken to report to CTC after testing	Time - No. of Days	Time taken from positive diagnosis to starting ART =#


# "Cauchy distribution with parameters μ, σ"
# struct OCauchy{A, B, ID} <: RandVar
#   μ::A
#   σ::B
#   id::ID
#   OCauchy(μ::A, σ::B, id = uid()) where {A, B, ID} = new{A, B, ID}(μ, σ, id)
# end
# cauchy(μ, σ) = Cauchy(μ, σ)

# Stigma (Internalized/External)	Yes/ No	Presence leads to not disclosing status
stigma = uniform([:no, :yes])


# Marital status	Married, Divorced, Single	Having a life partner makes it likely to have a support system in place and disclosing status
marital_status = uniform([:married, :divorced, :single])

# Has dependents /children	Yes/ No	Having dependent gives motivation to work on your health
has_dependents = uniform([:yes, :no])

# Gender	Male/ Female	Identifies as what gender
sex = uniform([:male, :female])

# Distr

# Age	Continous variable	Age determines dependency (employment/income generation) and education level
# age = truncated(Cauchy(17, 5), 0, 100) # age is set to a cauchy distribution with mean age 17, sd 5 and goes from 0 to 100
age_ = normal(25, 15)
age = cond(age_, age_ > 0.0)


# CTC service satisfaction	Yes/ No	How the patient feels about the service given by CTC caregivers, nurses, doctors
ctc_service_satisfaction = bernoulli(0.5)


# Disclosed status	Yes/ No	Disclosing makes you have a support system in place who are aware of what you are going through and thus offer help
function disclosed_status_(rng)
    if stigma(rng) == :no
        # if the patient has dependents and is in a relationship
        if has_dependents(rng) == :yes && marital_status(rng) == :married
            return rand(bernoulli(0.8))
        end
        
        if has_dependents(rng) == :yes || marital_status(rng) == :married
            return rand(bernoulli(0.6))
        end

        if has_dependents(rng) == :no && marital_status(rng) != :married
            return rand(bernoulli(0.15))
        end
    else
        # if the patient has dependents and is in a relationship
        if has_dependents(rng) == :yes && marital_status(rng) == :married
            return rand(bernoulli(0.7))
        end
        
        if has_dependents(rng) == :yes || marital_status(rng) == :married
            return rand(bernoulli(0.5))
        end

        if has_dependents(rng) == :no && marital_status(rng) != :married
            return rand(bernoulli(0.1))
        end
    end
end
disclosed_status = ciid(disclosed_status_)


# HIV-infected person(s) in household	Yes/ No	Helps to add on support system but also can mean sharing drugs
# function 


# Motivation	High/ Low	Gives reason to adhere
# function is_motivated()

# Pregnancy	Yes/ No	Pregnancy provides motivation to adhere
function is_pregnant_(rng)
    if sex(rng) == :male
        return constant(0)
    end

    # TODO: probability of pregnancy has to be a function f(age) -> p
    # To account for ages of fertility, and ages of hightened sexual activity
    return rand(bernoulli(0.5))

    # if age(rng) > 10
end
is_pregnant = ciid(is_pregnant_)


# Delivery of HIV- newborn 	Yes/ No	Mothers are less motivated to adhere after safe delivery
# function recently_delivered_negative_child(rng)

# Support System	Yes/ No	Provides support emotionally, physically + reminders 
function has_support_system_(rng)
    if Bool(disclosed_status(rng))
        return rand(bernoulli(0.8))
    else
        return rand(bernoulli(0.2))
    end
end
has_support_system = ciid(has_support_system_)


# Education level	No education, primary, secondary, tertiary	Educated can mean ability to follow instructions related to the treatment
# NOTE: 1/4 of girls graduate secondary school in tanzania source: WHO
# Parents: age, sex
# outcomes: :primary :secondary, :tertiary, :none
function education_level_(rng)
    if age(rng) < 12
        # ASSUMPTION: under 12 its assumed girls and boys have equal chance of being in primary school
        rand(uniform([:primary, :none]))
    elseif age(rng) < 19
        rand(uniform([:primary, :seconday, :none]))
    else
        # TODO: Account for sex given 1/4 of girls graduate secondary school in tanzania source: WHO
        return rand(uniform([:secondary, :teriary, :none]))
        # if sex(rng) == :male
        #     return rand(uniform([:secondary, :teriary, :none]))
        # else
        #     return rand(uniform([:secondary, :teriary, :none]))
        # end
        
    end
end
education_level = ciid(education_level_)

# Employment status	Not employed, employed, retired	Determines ability to generate income, nature of employment determines travel and work times
# returns [:unemployed, :employed, :retired]
function employment_status_(rng)
    age_ = age(rng)
    emp_category = 1
    if age_ >= 16 && age_ <= 60
        emp_category = rand(categorical([0.3, 0.65, 0.05]))
    elseif age_ >= 60
        emp_category = rand(categorical([0.05, :0.15, :0.8]))
    else # age_ < 16
        emp_category = rand(categorical([0.9, 0.1, 0]))
    end

    return [:unemployed, :employed, :retired][emp_category]
        # uniform()
end
employment_status = ciid(employment_status_)

# Income	High/ Low	Affording costs related to staying on treatment
# returns [:high, :medium, :low]
function income_(rng)
    # const emp_st = 
    if employment_status(rng) == :unemployed
        return rand(constant(:low))
    elseif employment_status(rng) == :retired
        return rand(uniform([:low, :medium]))
    else
        return rand(uniform([:medium, :high]))
    end
end
income = ciid(income_)


# Has cellphone (Direct contact means)	Yes/ No	CTC can contact for reminders
function has_cellphone_(rng)
    inc = income(rng)
    if inc == :high || inc == :medium
        return rand(bernoulli(0.8))
    else
        return rand(bernoulli(0.15))
    end
end
has_cellphone = ciid(has_cellphone_)

# Reminders	Yes/ No	Alarms, messages for next appointments, support system effort
# PARENTS: cellphone and support system
function has_reminders_(rng)
    if Bool(has_cellphone(rng)) && Bool(has_support_system(rng))
        return rand(bernoulli(0.8))
    elseif Bool(has_cellphone(rng)) || Bool(has_support_system(rng))
        return rand(bernoulli(0.7))
    else
        return rand(bernoulli(0.1))
    end
end
has_reminders = ciid(has_reminders_)


# Alcohol intake	Yes/ No	Drinks alcohol
# PARENTS: income, age, sex
# returns: [:none, :rarely, :often, :extreme] here extreme referes to either bein an acloholic or consuming moonshine
function alcohol_use_(rng)
    useage = categorical([0.25, 0.25, 0.25, 0.25])
    if age(rng) < 15
        usage = rand(categorical([0.9, 0.1, 0.0, 0.0]))
    else
        if income(rng) == :high
            usage = sex(rng) == :male ? rand(categorical([0.1, 0.4, 0.3, 0.2])) : rand(categorical([0.4, 0.3, 0.2, 0.1]))
        elseif income(rng) == :medium
            usage = sex(rng) == :male ? rand(categorical([0.1, 0.4, 0.3, 0.2])) : rand(categorical([0.5, 0.2, 0.2, 0.1]))
        else
            usage = sex(rng) == :male ? rand(categorical([0.1, 0.3, 0.4, 0.2])) : rand(categorical([0.6, 0.15, 0.15, 0.1]))
        end
    end

    return [:none, :rarely, :often, :extreme][usage]
end
alcohol_use = ciid(alcohol_use_)


# Drug use	Yes/ No	Uses drugs

# Forget dosage	Yes/ No	Not taking dosage due to forgetfulness
# Parents: reminders, alcohol use, age, pill count (ignored, not sure the relation)
function forget_dosage_(rng)
    reminders = Bool(has_reminders(rng))
    alcohol = alcohol_use(rng)
    age_ = age(rng)
    if alcohol !== :none && !reminders
        return age_ > 45 ? rand(bernoulli(0.7)) : rand(bernoulli(0.65))
    elseif alcohol !== :none || !reminders
        return age_ > 45 ? rand(bernoulli(0.6)) : rand(bernoulli(0.5))
    else
        return age_ > 45 ? rand(bernoulli(0.2)) : rand(bernoulli(0.15))
    end
end
forget_dosage = ciid(forget_dosage_)

# Travel	Yes/ No	Going far from registered CTC can cause missing appointments and running out of pills when away
# function 

# Run out of pills	Yes/ No	Not enough pills to finish dosage either due to exceeding dosage time (days) or having shared them
# function


# Transport cost / distance to treatment sites	High/ Low	Not affording related costs to reach CTC
# 


# Attends next CTC appointment/ Drug refill	Yes/ No	Going to CTC for therapy and/or drug refill (missed appoinetments)
# missed appointments
# PARENTS: ctc_service_satisfaction, reminders, income (as a proxy for transport)
# function missed_appointment_(rng)
    # if 
# end

# Knowledge on ART use	Yes/ No	Has knowledge on the how's, why's, what's & when with respect to ART (dosage & therapy)
function understand_regimen_(rng)
    edu = education_level(rng)
    if edu == :none
        return bernoulli(0.3)
    elseif edu == :primary
        return bernoulli(0.4)
    elseif edu == :secondary
        return bernoulli(0.6)
    else
        return bernoulli(0.75) # tetieary
    end
end
understand_regimen = ciid(understand_regimen_)

# Food insecurity	Yes/ No	Can afford and follows the required dietary requirement
function food_security_(rng)
    if income(rng) == :medium || income(rng) == :high
        return bernoulli(0.85)
    else
        return bernoulli(0.4) # :low income level
    end
end

food_security = ciid(food_security_)


# Drug use	Yes/ No	Uses drugs
# function drug_use_(rng)
#     if ()

# Regimen Type	Various	The type of regimen administered
# Pill count (Dose fatigue)	High/ Low	The number of pills required to take
# Side effects	Yes/ No	Experiences effects caused by the medication given
# Perceived harmfulness	High/ Low	The feelings that the medication is harmful to self
# Religion (Belief system)	Yes/ No	Belongs to a certain belief system 
# Use of alternative medications	Yes/ No	Using other medications, remedies or methods to combat HIV
# Perceived effectiveness	High/ Low	The feelings that the medication is working
# CD4 count	Continous variable	Determines the robustness of the immune system
# Physical wellbeing	Good/ Bad	Feeling stronger or weaker physically  than before
# Duration on ART	Time - No. of Days	Time since start of ART
# Time taken to report to CTC after testing	Time - No. of Days	Time taken from positive diagnosis to starting ART =




# rand(age, 6)

samples = rand((age, stigma, marital_status, has_dependents, disclosed_status, has_support_system, is_pregnant, education_level, employment_status, income, has_cellphone, has_reminders, alcohol_use, forget_dosage), 6, alg=RejectionSample)
