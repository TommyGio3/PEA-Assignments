clc; 
clear all;

%% CLOSED MODEL
N = 10; % Users

% 1: Terminals 
% 2: CPU
% 3: Disk
% 4: RAM
P = [   0,    1,    0,    0;
       0.1,    0,  0.3,  0.6;
         0, 0.85,    0, 0.15;
         0, 0.75, 0.25,    0;
    ];

% Terminals is the reference station
P1 = [  0,    1,    0,    0;
        0,    0,  0.3,  0.6;
        0, 0.85,    0, 0.15;
        0, 0.75, 0.25,    0;
     ];


l1 = [1, 0, 0, 0];

% Visits
Vk1 = l1 * inv(eye(4) - P1);

% Service time
Sk1 = [10, 20/1000, 10/1000, 3/1000];

% Demand
Dk1 = Vk1 .* Sk1;

fprintf("CLOSED MODEL\n");
fprintf("Visits: %g %g %g %g\n", Vk1);
fprintf("Demand: %g %g %g %g\n", Dk1);

%% OPEN MODEL
% 1: CPU
% 2: Disk
% 3: RAM

lambdaIn = [0.3, 0, 0];

% Throughput of the system
lambda0 = sum(lambdaIn); 

P2 = [    0,  0.3,  0.6;
        0.8,    0, 0.15;
       0.75, 0.25,    0; 
     ];

l2 = lambdaIn / lambda0;

% Visits
Vk2 = l2 * inv(eye(3) - P2);

% Throughput of the stations
Xk2 = Vk2 .* lambda0;

% Service time
Sk2 = [20/1000, 10/1000, 3/1000];

% Demand
Dk2 = Vk2 .* Sk2;

fprintf("\nOPEN MODEL\n");
fprintf(1, "Visits: %g %g %g\n", Vk2);
fprintf(1, "Demand: %g %g %g\n", Dk2);
fprintf(1, "Throughput: %g %g %g\n", Xk2);