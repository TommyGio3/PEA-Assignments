clc;
clear all;

%% STATO 0 = LOW
%% STATO 1 = MEDIUM
%% STATO 2 = HIGH
%% STATO 3 = DOWN

l_0_1 = 0.33;    %% LOW --> MEDIUM
l_1_0 = 0.6;     %% MEDIUM --> LOW
l_1_2 = 0.4;     %% MEDIUM --> HIGH
l_2_1 = 1;       %% HIGH --> MEDIUM
l_x_3 = 0.05;    %% HIGH/MEDIUM/LOW --> DOWN
l_3_0 = 6 * 0.6; %% DOWN --> LOW
l_3_1 = 6 * 0.3; %% DOWN --> MEDIUM
l_3_2 = 6 * 0.1; %% DOWN --> HIGH

Q = [-l_0_1 - l_x_3,      l_0_1,                    0,                l_x_3;
     l_1_0,               -l_1_0 - l_1_2 - l_x_3,   l_1_2,            l_x_3;
     0,                   l_2_1,                    -l_2_1 - l_x_3,   l_x_3;
     l_3_0,               l_3_1,                    l_3_2,            -l_3_0 - l_3_1 - l_3_2];


p0_MEDIUM = [0, 1, 0, 0];

[t, Sol] = ode45(@(t,x) Q'*x, [0 8], p0_MEDIUM');

figure;
plot(t, Sol, "-");
title("Evolution of the states of the system starting from the MEDIUM traffic state", FontSize=12);


p0_DOWN = [0, 0, 0, 1];

[t, Sol] = ode45(@(t,x) Q'*x, [0 8], p0_DOWN');

figure;
plot(t, Sol, "-");
title("Evolution of the states of the system starting from the DOWN traffic state", FontSize=12);


