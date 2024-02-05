clc; 
clear all;

m = 2^32;
a = 1664525;
c = 1013904223;
seed = 521191478;

%% Uniform
UniformList(1, 1) = seed;
for i = 2: +1: 10000
    UniformList(i, 1) = (mod(a * UniformList(i-1, 1) + c, m));
end

UniformList = UniformList ./ m;

%% Exponential
lambda_exp = 0.1;
ExpList = - (log(UniformList) ./ lambda_exp);

%% Pareto
a_Pareto = 1.5;
m_Pareto = 5;
ParetoList = m_Pareto ./ (UniformList .^ (1 / a_Pareto)); 

%% Erlang
k_Erlang = 4;
lambda_Erlang = 0.4;
j=1;
for i=1: +4: 10000
        produttoria(j,1) = prod(UniformList(i:i+3));
        j = j+1;
end
ErlangList = -(log(produttoria) ./ lambda_Erlang);

%% Hypo-Exponential
lambda1_hypo = 0.5;
lambda2_hypo = 0.125;
for i=1: +1: 10000
    if (mod(i, 2) == 0)
        HypoListParz(i,1) = - (log(UniformList(i,1)) / lambda1_hypo);
    else
        HypoListParz(i,1) = - (log(UniformList(i,1)) / lambda2_hypo);
    end
end
j = 1;
for i=1: +2: 10000
    HypoList(j,1) = HypoListParz(i,1) + HypoListParz(i+1,1);
    j = j + 1;
end

%% Hyper-Exponential
lambda1_hyper = 0.5;
lambda2_hyper = 0.05;
p1_hyper = 0.55;
lhyper = [0.5, 0.05];

lamda_Hyper=[0.5,0.05];
Prob_Hyper=[0.55,0.45];
C=cumsum(Prob_Hyper);
for k = 1:5000
    for i = 1:2
        if UniformList(k,1) <= C(1,i)
            HyperList(k,1) = -(log(UniformList(k+5000,1))/lamda_Hyper(1,i));
            break
        end
    end
end

%% Plot

t = [0:25].';

%% Exponential
figure;
plot(sort(ExpList), [1:10000]/10000, "r", t, max(0, (1- exp(-lambda_exp .* t))), "g", "LineStyle", "-");
xlim([0, 25]);
title("Comparison of real and empirical distribution for case N1: Exponential");

%% Pareto
for i = 1: 26
    if t(i,1) >= m_Pareto
        Pareto_Dist(i,1) = 1 - (m_Pareto ./ t(i, 1)) .^ a_Pareto;
    else
        Pareto_Dist(i,1) = 0;
    end
end
figure;
plot(sort(ParetoList), [1:10000]/10000, "r", t, Pareto_Dist, "g", "LineStyle", "-");
xlim([0, 25]);
title("Comparison of real and empirical distribution for case N2: Pareto");

%% Erlang
Mean = sum(UniformList) / 10000;
sortedUniform = sort(UniformList);
Variance = var(sortedUniform);
CoV = sqrt(Variance) ./ Mean;

if CoV < 1
    Erlang_Dist = 1 - (sum(exp(-lambda_Erlang .* t) .* (lambda_Erlang .* t) .^ (0: (k_Erlang - 1)) ./ factorial(0: (k_Erlang - 1)), 2));
end

figure;
plot(sort(ErlangList), [1:2500]/2500, "r", t, Erlang_Dist, "g", "LineStyle", "-");
xlim([0, 25]);
title("Comparison of real and empirical distribution for case N3: Erlang");

%% Hypo_exponential
figure;
plot(sort(HypoList), [1:5000]/5000, "r", t,(t>0) .* min(1,max(0,1 - lambda2_hypo/(lambda2_hypo-lambda1_hypo) * exp(-lambda1_hypo*t) + lambda1_hypo/(lambda2_hypo-lambda1_hypo) * exp(-lambda2_hypo*t))) , "g", "LineStyle", "-");
xlim([0, 25]);
title("Comparison of real and empirical distribution for case N4: Hypo-Exponential");

%% Hyper-Exponential
figure;
plot(sort(HyperList), [1:5000]/5000, "r", t,max(0,1 - p1_hyper * exp(-lambda1_hyper*t) - (1-p1_hyper) * exp(-lambda2_hyper*t)) , "g", "LineStyle", "-");
xlim([0, 25]);
title("Comparison of real and empirical distribution for case N5: Hyper-Exponential");

%% COST

totalCostEXP = 0;
for i=1: +1: 10000
    if (ExpList(i,1) < 10)
        costo_parzialeEXP = 0.01 * ExpList(i,1);
        totalCostEXP = totalCostEXP + costo_parzialeEXP;
    elseif (ExpList(i,1) > 10)
        costo_parzialeEXP = 0.02 * ExpList(i,1);
        totalCostEXP = totalCostEXP + costo_parzialeEXP;
    end
end

fprintf("Total cost for N1 Exponential = %g\n", totalCostEXP);

totalCostPAR = 0;
for i=1: +1: 10000
    if (ParetoList(i,1) < 10)
        costo_parzialePAR = 0.01 * ParetoList(i,1);
        totalCostPAR = totalCostPAR + costo_parzialePAR;
    elseif (ParetoList(i,1) > 10)
        costo_parzialePAR = 0.02 * ParetoList(i,1);
        totalCostPAR = totalCostPAR + costo_parzialePAR;
    end
end

fprintf("Total cost for N2 Pareto = %g\n", totalCostPAR);

totalCostERL= 0;
for i=1: +1: 2500
    if (ErlangList(i,1) < 10)
        costo_parzialeERL = 0.01 * ErlangList(i,1);
        totalCostERL = totalCostERL + costo_parzialeERL;
    elseif (ErlangList(i,1) > 10)
        costo_parzialeERL = 0.02 * ErlangList(i,1);
        totalCostERL = totalCostERL + costo_parzialeERL;
    end
end

fprintf("Total cost for N3 Erlang = %g\n", totalCostERL);

totalCostHypo= 0;
for i=1: +1: 5000
    if (HypoList(i,1) < 10)
        costo_parzialeHypo = 0.01 * HypoList(i,1);
        totalCostHypo = totalCostHypo + costo_parzialeHypo;
    elseif (HypoList(i,1) > 10)
        costo_parzialeHypo = 0.02 * HypoList(i,1);
        totalCostHypo = totalCostHypo + costo_parzialeHypo;
    end
end

fprintf("Total cost for N4 Hypo-Exponential = %g\n", totalCostHypo);

totalCostHyper= 0;
for i=1: +1: 5000
    if (HyperList(i,1) < 10)
        costo_parzialeHyper = 0.01 * HyperList(i,1);
        totalCostHyper = totalCostHyper + costo_parzialeHyper;
    elseif (HyperList(i,1) > 10)
        costo_parzialeHyper = 0.02 * HyperList(i,1);
        totalCostHyper = totalCostHyper + costo_parzialeHyper;
    end
end

fprintf("Total cost for N5 Hyper-Exponential = %g\n", totalCostHyper);


