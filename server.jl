println("Importing server packages")
using HTTP
using JSON2
using Sockets
using StatsFuns: logistic
using Turing
using MLDataUtils

println("Package importing has finished")


function getHome(req::HTTP.Request)
    return HTTP.Response(200, "Welcome to the Elsa API")
end

function get_distribution(samples)
    # @show samples
    mapping = Dict(
        "0.0" => 0,
        "0.1" => 0,
        "0.2" => 0,
        "0.3" => 0,
        "0.4" => 0,
        "0.5" => 0,
        "0.6" => 0,
        "0.7" => 0,
        "0.8" => 0,
        "0.9" => 0,
        "1.0" => 0
    )

    foreach(ix -> mapping[string(round(ix, digits=1))] += 1, samples)
    return mapping
end

# FIXME: Support taking the whole distribution
function adherenceScore(x::Matrix, chain, threshold, n)
    # Pull the means from each parameter's sampled values in the chain.
    intercept = rand(chain[:intercept].value, n)
    age = rand(chain[:age].value, n)
    edu_lev = rand(chain[:edu_lev].value, n)
    share_drugs = rand(chain[:share_drugs].value, n)
    occupation = rand(chain[:occupation].value, n)
    side_effect = rand(chain[:side_effect].value, n)
    understand_reg = rand(chain[:understand_reg].value, n)
    sex = rand(chain[:sex].value, n)
    alc_drinks = rand(chain[:alc_drinks].value, n)
    
    # Retrieve the number of rows.
    n_rows, _ = size(x)
    
    v_sampled = Array{Any,1}(undef, n_rows)
    p_hats_sampled = Array{Any,1}(undef, n_rows)
    
    for ir in 1:n_rows
        # Generate a vector to store our predictions.
        v = Vector{Float64}(undef, n)
        p_hats = Vector{Float64}(undef, n)
        for is in 1:n
            num = logistic(intercept[is] + occupation[is] * x[ir, 1] + age[is] * x[ir, 2] + share_drugs[is] * x[ir, 3] + understand_reg[is] * x[ir, 4] + side_effect[is] * x[ir, 5] + edu_lev[is] * x[ir, 6] + alc_drinks[is] * x[ir, 7] + sex[is] * x[ir, 8])
            p_hats[is] = num
            if num >= threshold
                v[is] = 1
            else
                v[is] = 0
            end
        end
        v_sampled[ir] = v
        p_hats_sampled[ir] = p_hats
    end
    
    # Sum the predictions and round them to either 0 or 1
    predictions = map(v_ar -> round(sum(v_ar) / length(v_ar)), v_sampled)
    mapping = get_distribution(p_hats_sampled[1])
    return predictions, p_hats_sampled, v_sampled, mapping
end;


mutable struct AdherenceRequest
    occupation::String -> "0.0"
    age::String -> "0.0"
    share_drugs::String -> "0.0"
    side_effect::String -> "0.0"
    understand_reg::String -> "0.0"
    edu_lev::String -> "0.0"
    sex::String -> "0.0"
    alc_drinks::String -> "0.0"
end

function getAdherenceScore(req::HTTP.Request)

    loaded_chn = read("./models/chn.jls", Chains)

    variables = JSON2.read(IOBuffer(HTTP.payload(req)))

    @show variables
    
	occupation = float(get(variables, :occupation, 0.0))
	age = float(get(variables, :age, 0.0))
	share_drugs = float(get(variables, :share_drugs, 0.0))
	side_effect = float(get(variables, :side_effect, 0.0))
	understand_reg = float(get(variables, :understand_reg, 0.0))
	edu_lev = float(get(variables, :edu_lev, 0.0))
	sex = float(get(variables, :sex, 0.0))
	alc_drinks = float(get(variables, :alc_drinks, 0.0))

	μ = [42.81944444444444]
	σ = [10.521142734724418]
	rescaled_age = [age]
    @show rescale!(rescaled_age, μ, σ)
    
	predictions, p_hats_sampled, v_sampled, mapping = adherenceScore([occupation rescaled_age[1] share_drugs understand_reg side_effect edu_lev alc_drinks sex], loaded_chn, 0.65, 6000)
    return HTTP.Response(200, JSON2.write(
       Dict("predictions" => predictions, 
        # "p_hats_sampled" => p_hats_sampled,
        "mapping" => mapping,
        # "v_sampled" => v_sampled
        )))
end

ELSA_ROUTER = HTTP.Router()
HTTP.@register(ELSA_ROUTER, "GET", "/", getHome)
HTTP.@register(ELSA_ROUTER, "POST", "/adherence-score", getAdherenceScore)

# HTTP.listen() do http::HTTP.Stream
#     @show http.message
#     @show HTTP.header(http, "Content-Type")
#     while !eof(http)
#         println("body data:", String(readavailavle(http)))
#     end
#     HTTP.setstatus(http, 404)
#     HTTP.setheader(http, "Foo-Header" => "bar")
#     HTTP.startwrite(http)
#     write(http, "response body")
#     write(http, "more response body")
# end

# HTTP.serve(ELSA_ROUTER, ip"127.0.0.1", 8080)
HTTP.serve(ELSA_ROUTER, "0.0.0.0", parse(Int,ARGS[1]))