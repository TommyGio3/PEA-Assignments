clc;
clear all;

N = 80;

% Terminals is the reference station
P1 = [   0,     1,    0,    0,   0,   0;
         0,     0,  0.4,  0.5,   0,   0;
         0,     0,    0,    0, 0.6, 0.4;
         0,     1,    0,    0,   0,   0;
         0,     1,    0,    0,   0,   0;
         0,     1,    0,    0,   0,   0;
     ];

l = [1, 0, 0, 0, 0, 0];

% Visits
vk = l * inv(eye(6) - P1);

% Service time
Sk = [40, 50/1000, 2/1000, 80/1000, 80/1000, 120/1000];

% Demand
Dk = vk .* Sk;

Qk = [0, 0, 0, 0, 0, 0];

Z = 40;

for n = 1 : 80
    for k = 2 : 6
        %if (k == 1)
         %   Rk(k) = Dk(k);
        %else
            Rk(k) = Dk(k) * (1 + Qk(k));
        %end
    end
    X = n / (Z + sum(Rk));
    for k = 2 : 6
        Qk(k) = X * Rk(k);
    end
end

% Response time
R = sum(Rk);
%R = N / X - Z;

% Utilization
U = Dk .* X;

fprintf("Throughput of the system: %g\n", X);
fprintf("Average system response time: %g\n",R);
fprintf("Utilization of the Application Server: %g\n", U(2));
fprintf("Utilization of the DBMS: %g\n", U(4));
fprintf("Utilization of the Disk1: %g\n", U(5));
fprintf("Utilization of the Disk2: %g\n", U(6));





