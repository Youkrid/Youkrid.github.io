{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "ec42480b",
   "metadata": {},
   "outputs": [],
   "source": [
    "using Plots\n",
    "using SparseArrays\n",
    "using LinearAlgebra\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "a35761e9",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "source_function (generic function with 1 method)"
      ]
     },
     "execution_count": 4,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "    function source_function(x)\n",
    "        X0 = 20.0\n",
    "        σ = 0.8\n",
    "        A = 10.\n",
    "        return  A .* exp.(.-((x .- X0).^2)./σ^2)  \n",
    "    end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "e686e629",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "source (generic function with 1 method)"
      ]
     },
     "execution_count": 3,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    " function source(N)\n",
    "\n",
    "    #Parameter\n",
    "        l = 80.\n",
    "        dx = l/N\n",
    "\n",
    "    #Mesh\n",
    "        X_vect = Vector(0:dx:l)\n",
    "        #print(X_vect) \n",
    "\n",
    "    # Function source\n",
    "        f = source_function(X_vect)\n",
    "        #plot(X_vect, f)\n",
    "        return f\n",
    "\n",
    "    end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "17b3d7ae",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "exact_solution (generic function with 1 method)"
      ]
     },
     "execution_count": 5,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "    function exact_solution(N)\n",
    "        l= 80 #length\n",
    "        dx = l/ N\n",
    "        u_exact = zeros(N+1)\n",
    "        x = 0\n",
    "        for i in 1:N+1\n",
    "            u_exact[i] = 0.5 * x + 10\n",
    "            x = x + dx     \n",
    "        end\n",
    "        return u_exact\n",
    "    end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "4648d5a5",
   "metadata": {},
   "outputs": [],
   "source": [
    "    function matrix(n) #8 times faster than before (calculate with @btime)\n",
    "\n",
    "    # Parameter for a copper bar \n",
    "        d= 8.92 #density \n",
    "        sh= 0.092 #specific_heat\n",
    "        tc= 0.95 #thermal_conductivity\n",
    "        l= 80 #length\n",
    "        c = ( tc / (sh * d))^(1/2)\n",
    "        dx = l/ n  \n",
    "     \n",
    "    # Build of the tridiagonal Matrix\n",
    "        A = spdiagm(-1 =>  -(c^2 / dx^2)* ones(n), 0 => 2 * (c^2 / dx^2) * ones(n+1), 1 => - (c^2 / dx^2) * ones(n)) \n",
    "        A[1,1] = 1\n",
    "        A[1,2] = 0\n",
    "        A[n+1,n+1] = 1 \n",
    "        A[n+1,n] = 0\n",
    "        return A\n",
    "    end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "ab1eb20c",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "heat (generic function with 1 method)"
      ]
     },
     "execution_count": 6,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "function heat(N)\n",
    "\n",
    "    #Parameter of the bar \n",
    "        l= 80 #length\n",
    "        dx = l/ N  \n",
    "\n",
    "    # Build of the matrix A\n",
    "        A = matrix(N)\n",
    "        #print(A)\n",
    "\n",
    "    # Vector B from Au = B (Boundary)\n",
    "        b = zeros(N+1)\n",
    "        b[1] = 10\n",
    "        b[end] = 50\n",
    "        #print(b)\n",
    "\n",
    "    # Vector S for the source power\n",
    "        X_vect = Vector(0:dx:l)\n",
    "        S = source_function(X_vect) \n",
    "        #print(S)\n",
    "        \n",
    "    # Solving of the Linear System\n",
    "        u = A \\ (b+S)   \n",
    "        #plot(X_vect, u)\n",
    "        return u \n",
    "    end "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "54771f5c",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "error (generic function with 1 method)"
      ]
     },
     "execution_count": 7,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "function error(N)\n",
    "\n",
    "        l = 80.0\n",
    "        dx = l/ (N)\n",
    "        exact = exact_solution(N)\n",
    "        modele = heat(N)\n",
    "        erreur = zeros(N+1)\n",
    "\n",
    "        for i in 1:N+1\n",
    "            erreur[i] = abs(exact[i] - modele[i])\n",
    "        end\n",
    "        X = [i for i in 0:dx:l]\n",
    "        plot(X, erreur)\n",
    "        #print(X)\n",
    "        #print(erreur)\n",
    "    end\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "bf699dbd",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "curbes (generic function with 1 method)"
      ]
     },
     "execution_count": 8,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "  function curbes(N)\n",
    "\n",
    "        l = 80.0\n",
    "        dx = l/ (N )\n",
    "        exact = exact_solution(N)\n",
    "        modele = heat(N)\n",
    "        X = [i for i in 0:dx:l]\n",
    "        plot(X, [exact,modele])\n",
    "        #print(length(exact), length(modele), length(X))\n",
    "        #print(X)\n",
    "    end "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "3fb20ac3",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Julia 1.4.1",
   "language": "julia",
   "name": "julia-1.4"
  },
  "language_info": {
   "file_extension": ".jl",
   "mimetype": "application/julia",
   "name": "julia",
   "version": "1.4.1"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
