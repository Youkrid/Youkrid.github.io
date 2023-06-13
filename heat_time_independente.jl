using Plots
using SparseArrays
using LinearAlgebra

#-----------------------------------------------------------------------------SOURCE----------------------------------------------------------------------------------------------

function source_function(x)
    X0 = 20.0
    σ = 0.8
    A = 10.
    return  A .* exp.(.-((x .- X0).^2)./σ^2)  
end

function source(N)
#Parameter
    l = 80.
    dx = l/N
#Mesh
    X_vect = Vector(0:dx:l)
    #print(X_vect) 
# Function source
    f = source_function(X_vect)
    #plot(X_vect, f)
    return f
end

#----------------------------------------------------------------------Exact solution without SOURCE ------------------------------------------------------------------------------
function exact_solution(N)
    l= 80 #length
    dx = l/ N
    u_exact = zeros(N+1)
    x = 0
    for i in 1:N+1
        u_exact[i] = 0.5 * x + 10
        x = x + dx     
    end
    return u_exact
end

#-------------------------------------------------------------------Build the Matrix A for the linear problem----------------------------------------------------------------------------

function matrix(n) #8 times faster than before (calculate with @btime)
# Parameter for a copper bar 
    d= 8.92 #density 
    sh= 0.092 #specific_heat
    tc= 0.95 #thermal_conductivity
    l= 80 #length
    c = ( tc / (sh * d))^(1/2)
    dx = l/ n  
# Build of the tridiagonal Matrix
    A = spdiagm(-1 =>  -(c^2 / dx^2)* ones(n), 0 => 2 * (c^2 / dx^2) * ones(n+1), 1 => - (c^2 / dx^2) * ones(n)) 
    A[1,1] = 1
    A[1,2] = 0
    A[n+1,n+1] = 1 
    A[n+1,n] = 0
    return A
end

#---------------------------------------------------------------Main function to solve heat equation time independente -----------------------------------------------------------------
function heat(N)
#Parameter of the bar 
    l= 80 #length
    dx = l/ N  
# Build of the matrix A
    A = matrix(N)
    #print(A)
# Vector B from Au = B (Boundary)
    b = zeros(N+1)
    b[1] = 10
    b[end] = 50
    #print(b)
# Vector S for the source power
    X_vect = Vector(0:dx:l)
    S = source_function(X_vect) 
    #print(S)
# Solving of the Linear System
    u = A \ (b+S)   
    #plot(X_vect, u)
    return u 
end 

#------------------------------------------------------------------------------------------Show error and plots -------------------------------------------------------------------------------------
function error(N)
    l = 80.0
    dx = l/ (N)
    exact = exact_solution(N)
    modele = heat(N)
    erreur = zeros(N+1)
    for i in 1:N+1
        erreur[i] = abs(exact[i] - modele[i])
    end
    X = [i for i in 0:dx:l]
    plot(X, erreur)
    #print(X)
    #print(erreur)
end



function curbes(N)
    l = 80.0
    dx = l/ N 
    exact = exact_solution(N)
    modele = heat(N)
    X = [i for i in 0:dx:l]
    plot(X, [exact,modele])
    #print(length(exact), length(modele), length(X))
    #print(X)
end 




