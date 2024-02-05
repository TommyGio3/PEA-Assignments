clc; 
clear all;

%% M/M/1
lambda1 = 40; 
D = 0.016; 

mu = 1 / D;

%% Utilization
U1 = lambda1 * D;
rho1 = U1;

%% Probability of having exactly one job in the system
Pr1_exact_1 = (1 - rho1) * rho1;

%% Probability of having less than 10 jobs in the system
Pr1_less_10 = 1 - (rho1 ^ (9 + 1));

%% Average queue length (jobs not in service)
Avg_queue_length1 = (rho1 ^ 2) / (1 - rho1);

%% Average response time
R1 = D / (1 - rho1);

%% Probability that the response time is greater than 0.5 s
Pr1_R_greater_05 = exp(-0.5 / R1);

%% 90 percentile of the response time distribution
Perc90 = -log(1 - 90/100) * R1;

%% PRINT1
fprintf("M/M/1: \n");
fprintf("Utilization = %g\n", U1);
fprintf("Probability of having 1 job in the system = %g\n", Pr1_exact_1);
fprintf("Probability of having < 10 jobs in the system = %g\n", Pr1_less_10);
fprintf("Average Queue Length = %g\n", Avg_queue_length1);
fprintf("Average Response Time = %g\n", R1);
fprintf("Probability Response Time > 0.5 = %g\n", Pr1_R_greater_05);
fprintf("90 percentile of response time distribution = %g\n", Perc90);

%% M/M/2
lambda2 = 90;

%% Total utilization
U2 = lambda2 / mu;

%% Average utilization
Avg_U2 = lambda2 / (2 * mu);
rho2 = Avg_U2;

%% Probability of having exactly one job in the system
Pr2_exact_1 = 2 * (1 - rho2) / (1 + rho2) * rho2;

%% Probability of having less than 10 jobs in the system
Pr2_less_10 = (1 - rho2) / (1 +  rho2);
for i = 1:9
    Pr2_i = 2 * ((1 - rho2) / (1 + rho2)) * (rho2 ^ i);
    Pr2_less_10 = Pr2_less_10 + Pr2_i;
end

%% Average queue length (jobs not in service)
N = (2 * rho2) / (1 - rho2 ^ 2);
Avg_queue_length2 = N - U2;

%% Average response time
R2 = D / (1 - rho2 ^ 2);

%% PRINT2
fprintf("\nM/M/2: \n");
fprintf("Total utilization = %g\n", U2);
fprintf("Average utilization = %g\n", Avg_U2);
fprintf("Probability of having 1 job in the system = %g\n", Pr2_exact_1);
fprintf("Probability of having < 10 jobs in the system = %g\n", Pr2_less_10);
fprintf("Average Queue Length = %g\n", Avg_queue_length2);
fprintf("Average Response Time = %g\n", R2);
