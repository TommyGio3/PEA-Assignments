clc;
clear all;

lambdaIn = [3, 2, 0, 0];

% Throughput of the system
lambda0 = sum(lambdaIn); 

P = [    0,   0.8,     0,     0;
         0,     0,   0.3,   0.5;
         0,     1,    0,      0; 
         0,     1,    0,      0;
     ];

l = lambdaIn / lambda0;

% Visits
Vk = l * inv(eye(4) - P);

% Service time
Sk = [2, 30/1000, 100/1000, 80/1000];

% Demand
Dk = Vk .* Sk;

% Utilization
Uk = lambda0 .* Dk;  

% Average number of jobs in the system
Q1 = Uk(1);
Q2 = Uk(2) / (1 - Uk(2));
Q3 = Uk(3) / (1 - Uk(3));
Q4 = Uk(4) / (1 - Uk(4));
N = Q1 + Q2 + Q3 + Q4;

% Average system response time
R1 = Dk(1);
R2 = Dk(2) / (1 - Uk(2));
R3 = Dk(3) / (1 - Uk(3));
R4 = Dk(4) / (1 - Uk(4));
R = R1 + R2 + R3 + R4;

% PRINT
fprintf("Throughput of the system: %g\n", lambda0);
fprintf("Average number of jobs in the system: %g\n", N);
fprintf("Average system response time: %g\n", R);
