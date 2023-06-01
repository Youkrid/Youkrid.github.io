using Plots 

function toto()
    global x = 0
    while 1 ==1 
        println("Coucou")
        if x == 5
            break
        end 
        x += 1
    end
end

function sum(n)
    global x = 10
    for i in 1:n:10
        println(" i = ", i)
        x += 2
        println(" X = ", x)
    end
end

function plot1()
    x = [25,26,27,28,29,30,31,32,33,34,35]
    y = [45375,48887,50467,51678,52189,53167,54871,56789,57891,58671,65179]
    plot(x,y)
end


C = 1
T = 2

println(C+T)







