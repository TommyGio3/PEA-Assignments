clc; clear all;

% Throughput
XA = 2 / 60;
XB = 3 / 60;
XC = 2.5 / 60;

% Service time
SA = [10, 12];
SB = [4, 3];
SC = [6, 6];

% Demand
DA = SA;
DB = SB;
DC = SC;

% Utilization
UA = XA * DA;
UB = XB * DB;
UC = XC * DC;

Uprod = UA(1,1) + UB(1,1) + UC(1,1);
Upack = UA(1,2) + UB(1,2) + UC(1,2);

% Average system response time per product type 
RAprod = DA(1,1) ./ (1 - (UA(1,1) + UB(1,1) + UC(1,1)));
RApack = DA(1,2) ./ (1 - (UA(1,2) + UB(1,2) + UC(1,2)));
RA = RAprod + RApack;

RBprod = DB(1,1) ./ (1 - (UA(1,1) + UB(1,1) + UC(1,1)));
RBpack = DB(1,2) ./ (1 - (UA(1,2) + UB(1,2) + UC(1,2)));
RB = RBprod + RBpack;

RCprod = DC(1,1) ./ (1 - (UA(1,1) + UB(1,1) + UC(1,1)));
RCpack = DC(1,2) ./ (1 - (UA(1,2) + UB(1,2) + UC(1,2)));
RC = RCprod + RCpack;

% Average number of jobs in the system for each type of product 
QA = XA * RA;
QB = XB * RB;
QC = XC * RC;

% Class-independent average system response time
X = XA + XB + XC;
R = (XA / X) * RA + (XB / X) * RB + (XC / X) * RC;

fprintf("Utilisation of the production station: %g\n", Uprod);
fprintf("Utilisation of the packaging station: %g\n", Upack);
fprintf("Average number of jobs in the system (Class A - NA): %g\n", QA);
fprintf("Average number of jobs in the system (Class B - NB): %g\n", QB);
fprintf("Average number of jobs in the system (Class C - NC): %g\n", QC);
fprintf("Average system response time (Class A - RA): %g\n", RA);
fprintf("Average system response time (Class B - RB): %g\n", RB);
fprintf("Average system response time (Class C - RC): %g\n", RC);
fprintf("Class independent average system response time (R): %g\n", R);