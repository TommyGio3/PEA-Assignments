clc; 
clear all;

lambda1 = 150 / 60;
D = 0.35;
mu = 1 / D;
rho = lambda1 / mu;
K = 32;

%% Utilization
U = (rho - rho^(K+1)) / (1 - rho^(K+1)); 

%% Loss probability
Pl = (rho^K - rho^(K+1)) / (1 - rho^(K+1));

%% Average number of jobs in the system
N = (rho / (1 - rho)) - (((K+1) * rho^(K+1)) / (1 - rho^(K+1)));

%% Drop rate
Dr = lambda1 * Pl;

%% Average response time
R = D * ((1 -(K+1)*rho^K+K*rho^(K+1))/ ((1-rho)*(1-rho^K)));

%% Average time spent in the queue
Avg_time_queue = R - D;

%% Print M/M/1/32
fprintf("M/M/1/32: \n");
fprintf("Utilization: %g\n", U);
fprintf("Loss probability: %g\n", Pl);
fprintf("Average number of jobs: %g\n", N);
fprintf("Drop rate: %g\n", Dr);
fprintf("Average response time: %g\n", R);
fprintf("Average time spent in the queue: %g\n", Avg_time_queue);


lambda2 = 250 / 60;
rho2 = lambda2 / (2*mu);
c = 2;

%% Total utilization
p0 = (((2*rho2)^2 / 2) * ((1 - rho2^(K-1))/(1 - rho2)) + (1 + (2*rho2)))^-1;

primo_termine = 0;
for n = 1:2
    if(n<c)
        primo_termine = primo_termine + (n * ((p0 / factorial(n)) * (c*rho2)^n));
    elseif(c<=n && n<=K)
        primo_termine = primo_termine + (n * ((p0*c^c*rho2^n) / factorial(c)));
    end
end
secondo_termine = 0;
for n = 3:K
    if(n<c)
        secondo_termine = secondo_termine + ((p0 / factorial(n)) * (c*rho2)^n);
    elseif(c<=n && n<=K)
        secondo_termine = secondo_termine + ((p0*c^c*rho2^n) / factorial(c));
    end
end
U2_tot = primo_termine + c * secondo_termine;

%% Average utilization
U2_average = U2_tot / 2;

%% Loss probability
n = 32;
Pl2 = (p0*c^c*rho2^n) / factorial(c);

%% Average number of jobs in the system
N2 = 0;
for n = 1:K
    if(n<c)
        N2 = N2 + (n * ((p0 / factorial(n)) * (c*rho2)^n));
    elseif(c<=n && n<=K)
        N2 = N2 + (n * ((p0*c^c*rho2^n) / factorial(c)));
    end
end

%% Drop rate
Dr2 = lambda2 * Pl2;

%% Average response time
R2 = N2 / (lambda2 * (1-Pl2));

%% Average time spent in the queue
Avg_time_queue = R2 - D;

%% Print M/M/2/32
fprintf("\nM/M/2/32: \n");
fprintf("Total Utilization: %g\n", U2_tot);
fprintf("Average Utilization: %g\n", U2_average);
fprintf("Loss probability: %g\n", Pl2);
fprintf("Average number of jobs: %g\n", N2);
fprintf("Drop rate: %g\n", Dr2);
fprintf("Average response time: %g\n", R2);
fprintf("Average time spent in the queue: %g\n", Avg_time_queue);


