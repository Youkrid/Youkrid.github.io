using Plots
using SparseArrays
using LinearAlgebra
using BenchmarkTools
using DifferentialEquations

#Beginning : Using DifferentialEquations

function matrix(n) 

    #Parameter for copper
        d= 8.92 #density 
        sh= 0.092 #specific_heat
        tc= 0.95 #thermal_conductivity
        l= 80.0 #length
        c = ( tc / (sh * d))^(1/2)
        dx = l/ n 
        dt = 1
        α = dt * c^2 /dx^2 
    
    #Build the matrix 
        A = spdiagm(-1 =>  -(α )* ones(n), 0 => ((2 * α + 1) ) * ones(n+1), 1 => - ( α ) * ones(n))
        return A
end


function heat!(du,u,p,t)
 
    #left boundary
    du[1] = p[2] * (-u[1] + u[2])/ p[1]

    #Interior 
    for i in 2:length(u)-1
        du[i] = p[2] * (u[i-1] -2*u[i] + u[i+1])/p[1]^2
    end

    #right boundary 
    du[end] = p[2] * (u[end-1] - u[end])/ p[1]^2
    
end




function set_initial_condition(x)
    A = 100.
    l = 80
    return A .* sin.((pi / l ) .* x)
end




function solve(n)
    
    #Parameter for copper
    d= 8.92 #density 
    sh= 0.092 #specific_heat
    tc= 0.95 #thermal_conductivity
    l= 80.0 #length
    c = ( tc / (sh * d))^(1/2)

    dt = 1
    dx = 1/n

    p = zeros(2)
    p[1] = dx
    p[2] = dt * c^2 /dx^2 

    t_begin = 0
    t_end = 0
    tspan = (t_begin, t_end)

    x = 0:dx:l
    init = set_initial_condition.(x)

   prob = ODEProblem(heat!, init, tspan, p)
    #sol = solve(prob)
    
    return prob
end