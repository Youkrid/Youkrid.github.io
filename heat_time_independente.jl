using Plots
using SparseArrays
using LinearAlgebra

function heat(N)

    d= 8.92 #density 
    sh= 0.092 #specific_heat
    tc= 0.95 #thermal_conductivity
    l= 80 #length
    c = ( tc / (sh * d))^(1/2)
    dx = l/ (N ) #N is the number of points without boundary so N+2 points in total 

#____________________________Datas are okay maybe dx is the problem for the rest__________________________________________________

    # Matrix A from Au = B
    A = zeros(N+1, N+1)
    A[1,1] = 1
    A[N+1,N+1] = 1
    for i in 2:N
        A[i, i] = 2 * c^2/ dx^2
        if i > 1
            A[i, i-1] = -c^2 / dx^2
        end
        if i < N+1
            A[i, i+1] = -c^2 / dx^2
        end
    end
    
#__________________________Matrix A print is okay____________________________________________________



    # Vector B from Au = B (Boundary)
    b = zeros(N+1)
    b[1] = 10
    b[end] = 50


#_________________________Vector b print is okay__________________________________________________________________
    
    # Solving of the Linear System
    u = A \ b
 
#_________________________Problem in this part __________________________________________________________________________
    
    
    return u

end 






function exact_solution(N)
    l= 80#length
    dx = l/ (N) #N is the number of points without boundary so N+2 points in total 
    u_exact = zeros(N+1)
    x = 0
    for i in 1:N+1
        u_exact[i] = 0.5 * x + 10
        x = x + dx     
    end
    return u_exact
end



function error(N)

    l = 80.0
    dx = l/ (N)
    exact = exact_solution(N)
    modele = heat(N)
    err = zeros(N+1)

    for i in 1:N+1
        err[i] = abs(exact[i] - modele[i])
    end
    X = [i for i in 0:dx:l]
    plot(X, err)
    #print(X)
    #print(err)
end



function curbes(N)

    l = 80.0
    dx = l/ (N )
    exact = exact_solution(N)
    modele = heat(N)
    X = [i for i in 0:dx:l]
    plot(X, [exact,modele])
    #print(length(exact), length(modele), length(X))
    #print(X)
end 
