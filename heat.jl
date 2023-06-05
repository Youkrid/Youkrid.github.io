using Plots


# plot to see intial_function
function init()
    F = Real[]
    space = Real[]
    for x in 0:0.5:80
        f(x) = 100 * sin((pi / 80)*x)
        push!(F, f(x))
        push!(space, x)
    end
    plot(space,F)
end 


#Exact Function first try just test things 
function exact_solution(n)

#Parameter 
    d= 8.92 #density 
    sh= 0.092 #specific_heat
    tc= 0.95 #thermal_conductivity
    l= 80 #length
    c = square( tc / (sh * d))
    lambda_n = (n * c * pi) / l

 #Define exact solution 
    u_exact(x,t) = 100 * sin(pi * x /80) * exp(-lambda_n^2 * t)
end
