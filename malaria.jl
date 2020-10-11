using Omega

timeofday = uniform([:morning, :afternoon, :evening])
is_window_open = bernoulli(0.5)
is_ac_on = bernoulli(0.3)

function outside_temp_(rng)
    if timeofday(rng) == :morning
        normal(rng, 20.0, 1.0)
    elseif timeofday(rng) == :afternoon
        normal(rng, 32.0, 1.0)
    else
        normal(rng, 10.0, 1.0)
    end
end
outside_temp = ciid(outside_temp_)

function inside_temp_(rng)
    if Bool(is_ac_on(rng))
        normal(rng, 20.0, 1.0)
    else
        normal(rng, 25.0, 1.0)
    end
end
  
inside_temp = ciid(inside_temp_)

function thermostat_(rng)
    if Bool(is_window_open(rng))
        (outside_temp(rng) + inside_temp(rng)) / 2.0
    else
        inside_temp(rng)
    end
end
  
thermostat = ciid(thermostat_)
rand((timeofday, is_window_open, is_ac_on, outside_temp, inside_temp, thermostat), is_ac_on == 1, 5, alg = SSMH)