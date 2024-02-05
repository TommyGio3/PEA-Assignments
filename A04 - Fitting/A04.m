clc; 
clear all;

filename1 = 'Trace1.csv';
filename2 = 'Trace2.csv';
trace1 = csvread(filename1);
trace2 = csvread(filename2);

Trace = [trace1 trace2];
N = size(Trace,1);

%%  X-axis
for i = 0: 100
    t(i+1,1) = i;
end

%% Moments
Mean = sum(Trace) / N;
Moment2 = sum(Trace .^2) / N;
Moment3 = sum(Trace .^3) / N;

%%  Coefficient of variation
sortedTrace = sort(Trace);
Variance = var(sortedTrace);
CoV = sqrt(Variance) ./ Mean;
CoV_size = size(CoV, 2);

%%  Uniform distribution
Uniform_a = Mean - (sqrt(12 * (Moment2 - Mean .^ 2)) / 2);
Uniform_b = Mean + (sqrt(12 * (Moment2 - Mean .^ 2)) / 2);
Uniform_Dist(:,1) = max(0, min(1, (t > Uniform_a(:,1)) .* (t < Uniform_b(:,1)) .* (t - Uniform_a(:,1)) ./ (Uniform_b(:,1) - Uniform_a(:,1)) + (t >= Uniform_b(:,1))));
Uniform_Dist(:,2) = max(0, min(1, (t > Uniform_a(:,2)) .* (t < Uniform_b(:,2)) .* (t - Uniform_a(:,2)) ./ (Uniform_b(:,2) - Uniform_a(:,2)) + (t >= Uniform_b(:,2))));

%%  Exponential distribution
Exponential_lambda = 1 ./ Mean;
Exponential_Dist(:,1) = max(0, (1 - exp(-Exponential_lambda(:,1) .* t)));
Exponential_Dist(:,2) = max(0, (1 - exp(-Exponential_lambda(:,2) .* t)));

%%  Erlang distribution 
Erlang_k = round(1 ./ (CoV .^ 2));
Erlang_lambda = Erlang_k ./ Mean;
for i = 1: +1: CoV_size
    if CoV(1,i) < 1
        Erlang_Dist = 1 - (sum(exp(-Erlang_lambda(:,i) .* t) .* (Erlang_lambda(:,i) .* t) .^ (0: (Erlang_k(:,i) - 1)) ./ factorial(0: (Erlang_k(:,i) - 1)), 2));
    else
        fprintf(1, "Erlang is NOT available for Trace2 --> CoV > 1\n");
    end
end

%%  Weibull with method of moments
% x(1) = lambda | x(2) = k
weibull_eq1 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,1), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,1)];
weibull_eq2 = @(x) [x(1) * gamma(1 + 1 / x(2)) - Mean(1,2), x(1)^2 * gamma(1 + 2 / x(2)) - Moment2(1,2)];
x1 = fsolve(weibull_eq1, [1,1]);
x2 = fsolve(weibull_eq2, [1,1]);
Weibull_lambda = [x1(1) x2(1)];
Weibull_k = [x1(2) x2(2)];
Weibull_Dist(:,1) = 1 - exp(-(t ./ Weibull_lambda(:,1)) .^ Weibull_k(:,1));
Weibull_Dist(:,2) = 1 - exp(-(t ./ Weibull_lambda(:,2)) .^ Weibull_k(:,2));

%%  Pareto with method of moments
% x(1) = alpha | x(2) = m
pareto_eq1 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,1), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,1)];
pareto_eq2 = @(y) [y(1) * y(2) / (y(1) - 1) - Mean(1,2), (y(1) * (y(2) ^2) / (y(1) - 2)) - Moment2(1,2)];
y1 = fsolve(pareto_eq1, [3, min(sortedTrace(:,1))]);
y2 = fsolve(pareto_eq2, [3, min(sortedTrace(:,2))]);
Pareto_alpha = [y1(1) y2(1)];
Pareto_m = [y1(2) y2(2)];
for j = 1: 2
    for i = 1: 101
        if t(i,1) >= Pareto_m(j)
            Pareto_Dist(i,j) = 1 - (Pareto_m(j) ./ t(i,1)) .^ Pareto_alpha(j);
        else
            Pareto_Dist(i,j) = 0;
        end
    end
end

%% Print
fprintf(1, "First moment: %g %g\n", Mean(1,1), Mean(1,2));
fprintf(1, "Second moment: %g %g\n", Moment2(1,1), Moment2(1,2));
fprintf(1, "Third moment: %g %g\n", Moment3(1,1), Moment3(1,2));
fprintf(1, "Uniform minimum(a): %g %g\n", Uniform_a(1,1), Uniform_a(1,2));
fprintf(1, "Uniform maximum(b): %g %g\n", Uniform_b(1,1), Uniform_b(1,2));
fprintf(1, "Exponential rate (lambda): %g %g\n", Exponential_lambda(1,1), Exponential_lambda(1,2));
fprintf(1, "Erlang stages (k): %g %g\n", Erlang_k(1,1), Erlang_k(1,2));
fprintf(1, "Erlang rate (lambda): %g %g\n", Erlang_lambda(1,1), Erlang_lambda(1,2));
fprintf(1, "Weibull shape (k): %g %g\n", Weibull_k(1,1), Weibull_k(1,2));
fprintf(1, "Weibull scale (lambda): %g %g\n", Weibull_lambda(1,1), Weibull_lambda(1,2));
fprintf(1, "Pareto shape (a): %g %g\n", Pareto_alpha(1,1), Pareto_alpha(1,2));
fprintf(1, "Pareto scale (m): %g %g\n", Pareto_m(1,1), Pareto_m(1,2));

%%  Hyper-exponential and Hypo_exponential with maximum likelihood method
Hyper_PDF = @(x,l1,l2,p1) (x > 0) .* (p1 * l1 * exp(-l1 * x) + (1 - p1) * l2 * exp(-l2 * x));
Hyper_Param1 = mle(sortedTrace(:,1), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,1), 1.2 / Mean(1,1), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
Hyper_Param2 = mle(sortedTrace(:,2), 'pdf', Hyper_PDF, 'Start', [0.8 / Mean(1,2), 1.2 / Mean(1,2), 0.4], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);

fprintf(1, "Hyper-exponential first rate (lambda_1) for Trace 1: %g\n", Hyper_Param1(1,1));
fprintf(1, "Hyper-exponential second rate (lambda_2) for Trace 1: %g\n", Hyper_Param1(1,2));
fprintf(1, "Hyper-exponential probability of first branch (p_1) for Trace 1: %g\n", Hyper_Param1(1,3));

fprintf(1, "Hyper-exponential first rate (lambda_1) for Trace 2: %g\n", Hyper_Param2(1,1));
fprintf(1, "Hyper-exponential second rate (lambda_2) for Trace 2: %g\n", Hyper_Param2(1,2));
fprintf(1, "Hyper-exponential probability of first branch (p_1) for Trace 2: %g\n", Hyper_Param2(1,3));

Hypo_PDF = @(x,l1,l2) (x > 0) .* (l1 * l2 / (l1 - l2) * (exp(-l2 * x) - exp(-l1 * x)));
Hypo_Param1 = mle(sortedTrace(:,1), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,1)), 1 / (0.7 * Mean(1,1))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
Hypo_Param2 = mle(sortedTrace(:,2), 'pdf', Hypo_PDF, 'Start', [1 / (0.3 * Mean(1,2)), 1 / (0.7 * Mean(1,2))], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);

fprintf(1, "Hypo-exponential first rate (lambda_1) for Trace 1: %g\n", Hypo_Param1(1,1));
fprintf(1, "Hypo-exponential second rate (lambda_2) for Trace 1: %g\n", Hypo_Param1(1,2));

fprintf(1, "Hypo-exponential first rate (lambda_1) for Trace 2: %g\n", Hypo_Param2(1,1));
fprintf(1, "Hypo-exponential second rate (lambda_2) for Trace 2: %g\n", Hypo_Param2(1,2));

for i = 1: CoV_size
    if CoV(:,i) > 1
        fprintf(1, "Hypo-exponential is NOT available for Trace: " + i + " --> CoV > 1\n");
        Hyper_Dist = 1 - (Hyper_Param2(1,3) .* exp(-Hyper_Param2(1,1) .* t(:,1))) - (1 - Hyper_Param2(1,3)) .* exp(-Hyper_Param2(1,2) .* t(:,1));
    else
        Hypo_Dist = 1 - (Hypo_Param1(1,2) * exp(-Hypo_Param1(1,1) .* t(:,1)) ./ (Hypo_Param1(1,2) - Hypo_Param1(1,1))) + (Hypo_Param1(1,1) .* exp(-Hypo_Param1(1,2) .* t(:,1)) ./ (Hypo_Param1(1,2) - Hypo_Param1(1,1)));
        fprintf(1, "Hyper-exponential is NOT available for Trace: " + i + " --> CoV < 1\n");
    end
end

%%  Empirical CDF
for i = 1: N
    counter(i,:) = i;
end
FunctionX = counter ./ N;

%%  Plot Trace 1
figure;
plot(sortedTrace(:,1), FunctionX, 'y', t, sort(Uniform_Dist(:,1)), 'r', t, sort(Exponential_Dist(:,1)), 'g', t, sort(Erlang_Dist(:,1)), 'b', t, sort(Weibull_Dist(:,1)), 'm', t, sort(Pareto_Dist(:,1)), 'c', t, sort(Hypo_Dist(:,1)), 'k', 'LineStyle', '-');
xlim([0 100]);
title('Comparison of distributions with the trace for TRACE 1', FontSize = 15);
xlabel('VALUE', FontSize = 13);
ylabel('PROBABILITY', FontSize = 13);
legend('Empirical', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'Hypo-exponential');
grid on;

%%  Plot Trace 2
figure;
plot(sortedTrace(:,2), FunctionX, 'y', t, sort(Uniform_Dist(:,2)), 'r', t, sort(Exponential_Dist(:,2)), 'g', t, sort(Weibull_Dist(:,2)), 'm', t, sort(Pareto_Dist(:,2)), 'c', t, sort(Hyper_Dist(:,1)), 'k', 'LineStyle', '-');
xlim([0 100]);
title('Comparison of distributions with the trace for TRACE 2', FontSize = 15);
xlabel('VALUE', FontSize = 13);
ylabel('PROBABILITY', FontSize = 13);
legend('Empirical', 'Uniform', 'Exponential', 'Weibull', 'Pareto', 'Hyper-exponential');
grid on;