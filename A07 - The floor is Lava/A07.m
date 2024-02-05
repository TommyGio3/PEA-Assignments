clc;
clear all;
T = 10000;

s0 = 0; %% stato iniziale
s = s0;
t = 0;
i = 0;

trace =[T, s0];
durata = 0;
j=1;


while t<T
    if s==0    %% ENTRANCE
        if rand() <= 0.3 %% LIGHT BLUE PATH
            if rand() <= 0.3 %% 0.3 dello 0.3 
                ns = 2; %% C2
                dt = 3 + rand() * (6-3); 
                durata = durata + dt;
            else %% 0.7 dello 0.3
                ns = 4; %% FALL
                dt = -log (rand()) / 0.25;
                durata = durata + dt;
            end

        else %% YELLOW PATH
            if rand() <= 0.2 %% 0.2 dello 0.7
                ns = 4; %% FALL
                dt = -log (rand()) / 0.5;
                durata = durata + dt;
            else   %% 0.8 dello 0.7
                ns = 1;  %% C1
                dt = -log(prod(rand(4,1))) / 1.5;
                durata = durata + dt;
            end
        end
    end

    if s==1 %% C1
        if rand() <= 0.5 %% WHITE PATH
            if rand() <= 0.4 %% 0.4 di 0.5
                ns = 4; %% FALL
                dt = -log (rand()) / 0.2;
                durata = durata + dt;
            else %% 0.6 di 0.5
                ns = 2; %% C2
                dt = -log (rand()) / 0.15;
                durata = durata + dt;
            end
        else  %% YELLOW PATH
            if rand() <= 0.25 %% 0.25 di 0.5
                ns = 2; %% C2
                dt = -log(prod(rand(3,1))) / 2;
                durata = durata + dt;
            else %% 0.75 di 0.5
                ns = 4; %% FALL
                dt = -log (rand()) / 0.4;
                durata = durata + dt;
            end
        end
    end

    if s==2 %% C2 %% GREEN PATH
        if rand() <= 0.4
            ns = 4; %% FALL
            dt = -log(prod(rand(5,1))) / 4;
            durata = durata + dt;
        else 
            ns = 3; %% EXIT
            dt = -log(prod(rand(5,1))) / 4;
            durata = durata + dt;
        end
    end

    if s==3 %% EXIT
        ns = 0; %% ENTRANCE
        dt = 5;
    end

    if s==4 %% FALL
        ns = 0; %% ENTRANCE
        dt = 5;
    end

    s = ns;
    t = t+dt;
    
    if(ns == 0)
        durataTrace(j,1) = durata;
        durata = 0;
        j= j+1;
    end
    
    i=i+1;
    trace(i, :) = [t, s];     

end

Tot_partite = sum(trace(:,2) == 0);
Tot_vittorie = sum(trace(:,2) == 3);
Prob_vincite = Tot_vittorie / Tot_partite;
AverageDurationGame = sum(durataTrace) / Tot_partite;
X = (Tot_partite / (T/60));
%figure;
%stairs(trace(:,1), trace(:,2));
fprintf("Winning probability: %g \n", Prob_vincite);
fprintf("Average duration of a game: %g \n", AverageDurationGame);
fprintf("Throughput: %g games per hour \n", X);
fprintf("Number of simulations: %g\n", Tot_partite);

