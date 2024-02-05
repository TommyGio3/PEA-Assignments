clc;
clear all;

lambda1 = 10;
mu1 = 50;
mu2 = 5;
p1 = 0.8;
p2 = 1 - p1;
D = p1 / mu1 + p2 / mu2;

m2 = 2 * (p1 / mu1^2 + p2 / mu2^2);

rho1 = lambda1 * D;

%% The utilization of the system
U1 = rho1;

%% The (exact) average response time
R1 = D + ((lambda1 * m2) / (2 * (1 - rho1)));

%% The (exact) average number of jobs in the system
N1 = lambda1 * R1;

fprintf("M/G/1\n");
fprintf("The utilization of the system: %g\n", U1);
fprintf("The (exact) average response time: %g\n", R1);
fprintf("The (exact) average number of jobs in the system: %g\n", N1);

lambdaErlang = 240;
k = 5;
T = k/lambdaErlang;
lambda2 = 1/T;

rho2 = D/(3*T);

ca = 1 / sqrt(k);

%% The utilization of the system
U2 = rho2;

%% The approximate average response time
c = 3;

mu_hyper = p1 / mu1 + p2 / mu2;
sigma_hyper_alQuadrato = (((2*p1)/mu1^2) + ((2*p2)/mu2^2) - (mu_hyper)^2);
cv = sqrt(sigma_hyper_alQuadrato) / mu_hyper;

numeratore = D / (c * (1 - rho2));
sommatoria_denominatore = 1 + (c * rho2) + ((c * rho2)^2 / factorial(2));
denominatore = 1 + ((1 - rho2) * (factorial(c) / (c * rho2)^c) * sommatoria_denominatore);
theta = numeratore / denominatore;
R2 = D + ((ca^2 + cv^2) / 2) * theta;

%% The approximate average number of jobs in the system
N2 = lambda2 * R2;

fprintf("\nG/G/3\n");
fprintf("The utilization of the system: %g\n", U2);
fprintf("The approximate average response time: %g\n", R2);
fprintf("The approximate average number of jobs in the system: %g\n", N2);