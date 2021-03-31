println("Importing server packages")
using HTTP
using JSON2
println("Package importing has finished")

include("conditions.jl")


function getHome(req::HTTP.Request)
    return HTTP.Response(200, "Welcome to the Elsa Pediatrics API")
end

mutable struct AssessmentRequest
    age::String -> "1.0"
    present_symptoms::String -> []
    absent_symptoms::String -> []
    present_risk_factors::String -> []
    absent_risk_factors::String -> []
    condition_options::String -> []
    sex::String -> "0"
end

function getPatientAssessment(req::HTTP.Request)

    variables = JSON2.read(IOBuffer(HTTP.payload(req)))

    @show variables

    age = get(variables, :age, 1.0)
    present_symptoms = get(variables, :present_symptoms, [])
    absent_symptoms = get(variables, :absent_symptoms, [])
    present_risk_factors = get(variables, :present_risk_factors, [])
    absent_risk_factors = get(variables, :absent_risk_factors, [])
    condition_options = get(variables, :condition_options, [])
    
    # categories [<4weeks, 1mo - 1yr, 1yr - 3yrs, 3yrs - 6yrs, 6yrs - 12yrs, 12yrs - 18yrs]
    age_categories = [:neonatal, :infant, :toddler, :preschool, :school, :adolescent]

    age_category = :neonatal
    if age < 0.1
        age_categories = :neonatal
    elseif age < 1.1
        age_category = :infant
    elseif age < 3.1
        age_category = :toddler
    elseif age < 6.1
        age_category = :preschool
    elseif age < 12.1
        age_category = :school
    else
        age_category = :adolescent
    end

    assessment = patient_assessment(age_category, present_symptoms, absent_symptoms, present_risk_factors, absent_risk_factors, condition_options)

    # @show assess_symptoms(present_symptoms)

    return HTTP.Response(200, JSON2.write(assessment))
end


ELSA_ROUTER = HTTP.Router()
HTTP.@register(ELSA_ROUTER, "GET", "/", getHome)
HTTP.@register(ELSA_ROUTER, "POST", "/symptom-assessment", getPatientAssessment)


HTTP.serve(ELSA_ROUTER, "0.0.0.0", length(ARGS) > 0 ? parse(Int, ARGS[1]) : 8080)