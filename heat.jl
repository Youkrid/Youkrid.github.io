using Plots
using SparseArrays


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

#Parameter for copper
    d= 8.92 #density 
    sh= 0.092 #specific_heat
    tc= 0.95 #thermal_conductivity
    l= 80 #length
    c = square( tc / (sh * d))
    lambda_n = (n * c * pi) / l

 #Define exact solution 
    u_exact(x,t) = 100 * sin(pi * x /80) * exp(-lambda_n^2 * t)
    return u_exact(x,t)
end

function heat(n)

    #Parameter for copper
    d= 8.92 #density 
    sh= 0.092 #specific_heat
    tc= 0.95 #thermal_conductivity
    l= 80.0 #length
    c = ( tc / (sh * d))^(1/2)
    dx = l/ (n -1) #n is the number of point with the starting point 
    tmax = 30.0 #30 secondes 
    dt = 0.05
    n_iteration = Int(tmax /dt) + 1 #to convert into integer
    α = dt * c^2 /dx^2 #Without dt for now 
    
    #Boundary solution 
    U = zeros(n)
    U[1] = 0.0
    U[n] = 0.0  

    #inital condition
    for i in 2:n-1
        x = (i-1)*dx
        U[i] = 100.0 * sin((pi / 80)*x)
    end 

    #solve the system
    for j in 1:n_iteration
        Unp1 = copy(U)
    
        for i in 2:n-1
            Unp1[i] = α * (U[i+1] - 2 * U[i] + U[i-1]) + U[i]
        end 
        U = Unp1
    end 
    x = [k for k in 0:dx:l]
    plot(x,U)
end



