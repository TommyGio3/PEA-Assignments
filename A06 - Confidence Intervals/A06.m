clc; 
clear all;

M_batch = 1000; 
gamma = 0.95;
diGamma = norminv((1 + gamma)/2);
Max_Rel_Err = 0.04;

%% SCENARIO 1

K0 = 1000;
maxK = 20000;
K = K0;
DK = 100;

tA = 0;
tC = 0;
U = 0;
U2 = 0;
R = 0;
R2 = 0;
X = 0;
X2 = 0;
N = 0;
N2 = 0;
Var = 0;
Var2 = 0;

newIters = K;

while K < maxK
  for i = 1: newIters
    Busy_time = 0;
    Wi = 0;
    tA0 = tA;
  
    for j = 1: M_batch
      arr_ji = HyperExpGen();
      serv_ji = ErlangGen();
      
      tA = tA + arr_ji;
      tC = max(tA, tC) + serv_ji;
      Resp_time = tC - tA;
      Resp_trace((i-1) * M_batch + j, 1) = Resp_time;
      Resp_trace_i(j,1) = Resp_time;
      
      Busy_time = Busy_time + serv_ji;
      
      Wi = Wi + Resp_time;
    end
    
    Avg_Resp_Time = Wi / M_batch;
    R = R + Avg_Resp_Time;
    R2 = R2 + Avg_Resp_Time^2;
    
    Ti = tC - tA0;
    Ui = Busy_time / Ti;
    U = U + Ui;
    U2 = U2 + Ui^2;

    Xi = M_batch / Ti;
    X = X + Xi;
    X2 = X2 + Xi^2;

    Ni = Wi / Ti;
    N = N + Ni;
    N2 = N2 + Ni^2;

    Vari(i,1) = var(Resp_trace_i);
    Var = Var + Vari(i,1);
    Var2 = Var2 + Vari(i,1)^2;
  end
  
  Rm = R / K;
  Rs = sqrt((R2 - R^2 / K) / (K-1));
  CiR = [Rm - diGamma * Rs / sqrt(K), Rm + diGamma * Rs / sqrt(K)];
  errR = 2 * diGamma * Rs / sqrt(K) / Rm;
  
  Um = U / K;
  Us = sqrt((U2 - U^2 / K) / (K-1));
  CiU = [Um - diGamma * Us / sqrt(K), Um + diGamma * Us / sqrt(K)];
  errU = 2 * diGamma * Us / sqrt(K) / Um;

  Xm = X / K;
  Xs = sqrt((X2 - X^2 / K) / (K-1));
  CiX = [Xm - diGamma * Xs / sqrt(K), Xm + diGamma * Xs / sqrt(K)];
  errX = 2 * diGamma * Xs / sqrt(K) / Xm;

  Nm = N / K;
  Ns = sqrt((N2 - N^2 / K) / (K-1));
  CiN = [Nm - diGamma * Ns / sqrt(K), Nm + diGamma * Ns / sqrt(K)];
  errN = 2 * diGamma * Ns / sqrt(K) / Nm;

  Varm = Var / K;
  Vars = sqrt((Var2 - Var^2 / K) / (K-1));
  CiVar = [Varm - diGamma * Vars / sqrt(K), Varm + diGamma * Vars / sqrt(K)];
  errVar = 2 * diGamma * Vars / sqrt(K) / Varm;

  
  if errR < Max_Rel_Err && errU < Max_Rel_Err && errX < Max_Rel_Err && errN < Max_Rel_Err && errVar < Max_Rel_Err
    break;
  else
    K = K + DK;
    newIters = DK;
  end
end

fprintf("Scenario 1: ");
if errR < Max_Rel_Err && errU < Max_Rel_Err && errX < Max_Rel_Err && errN < Max_Rel_Err && errVar < Max_Rel_Err
  fprintf(1, "\nMaximum Relative Error reached in %d Iterations\n", K);
else
  fprintf(1, "\nMaximum Relative Error NOT REACHED in %d Iterations\n", K);
end  

fprintf("Utilization in [%g, %g], with %g confidence. Relative Error: %g\n", CiU(1,1), CiU(1,2), gamma, errU);
fprintf("Resp. Time in [%g, %g], with %g confidence. Relative Error: %g\n", CiR(1,1), CiR(1,2), gamma, errR);
fprintf("Throughput in [%g, %g], with %g confidence. Relative Error: %g\n", CiX(1,1), CiX(1,2), gamma, errX);
fprintf("Average number of jobs in [%g, %g], with %g confidence. Relative Error: %g\n", CiN(1,1), CiN(1,2), gamma, errN);
fprintf("Variance of the response time in [%g, %g], with %g confidence. Relative Error: %g\n", CiVar(1,1), CiVar(1,2), gamma, errVar);

%% SCENARIO 2

K0_2 = 1000;
maxK_2 = 20000;
K_2 = K0_2;
DK_2 = 100;

tA_2 = 0;
tC_2 = 0;
U_2 = 0;
U2_2 = 0;
R_2 = 0;
R2_2 = 0;
X_2 = 0;
X2_2 = 0;
N_2 = 0;
N2_2 = 0;
Var_2 = 0;
Var2_2 = 0;

newIters_2 = K_2;

while K_2 < maxK_2
  for i = 1: newIters_2
    Busy_time_2 = 0;
    Wi_2 = 0;
    tA0_2 = tA_2;
  
    for j = 1: M_batch
      arr_ji_2 = ExpGen();
      serv_ji_2 = UniformGen();

      tA_2 = tA_2 + arr_ji_2;
      tC_2 = max(tA_2, tC_2) + serv_ji_2;
      Resp_time_2 = tC_2 - tA_2;
      Resp_trace_2((i-1) * M_batch + j, 1) = Resp_time_2;
      Resp_trace_i_2(j,1) = Resp_time_2;
    
      Busy_time_2 = Busy_time_2 + serv_ji_2;
      
      Wi_2 = Wi_2 + Resp_time_2;
    end
    
    Avg_Resp_Time_2 = Wi_2 / M_batch;
    R_2 = R_2 + Avg_Resp_Time_2;
    R2_2 = R2_2 + Avg_Resp_Time_2^2;
    
    Ti_2 = tC_2 - tA0_2;
    Ui_2 = Busy_time_2 / Ti_2;
    U_2 = U_2 + Ui_2;
    U2_2 = U2_2 + Ui_2^2;

    Xi_2 = M_batch / Ti_2;
    X_2 = X_2 + Xi_2;
    X2_2 = X2_2 + Xi_2^2;

    Ni_2 = Wi_2 / Ti_2;
    N_2 = N_2 + Ni_2;
    N2_2 = N2_2 + Ni_2^2;

    Vari_2(i,1) = var(Resp_trace_i_2);
    Var_2 = Var_2 + Vari_2(i,1);
    Var2_2 = Var2_2 + Vari_2(i,1)^2;
  end
  
  Rm_2 = R_2 / K_2;
  Rs_2 = sqrt((R2_2 - R_2^2 / K_2) / (K_2-1));
  CiR_2 = [Rm_2 - diGamma * Rs_2 / sqrt(K_2), Rm_2 + diGamma * Rs_2 / sqrt(K_2)];
  errR_2 = 2 * diGamma * Rs_2 / sqrt(K_2) / Rm_2;
  
  Um_2 = U_2 / K_2;
  Us_2 = sqrt((U2_2 - U_2^2 / K_2) / (K_2-1));
  CiU_2 = [Um_2 - diGamma * Us_2 / sqrt(K_2), Um_2 + diGamma * Us_2 / sqrt(K_2)];
  errU_2 = 2 * diGamma * Us_2 / sqrt(K_2) / Um_2;

  Xm_2 = X_2 / K_2;
  Xs_2 = sqrt((X2_2 - X_2^2 / K_2) / (K_2-1));
  CiX_2 = [Xm_2 - diGamma * Xs_2 / sqrt(K_2), Xm_2 + diGamma * Xs_2 / sqrt(K_2)];
  errX_2 = 2 * diGamma * Xs_2 / sqrt(K_2) / Xm_2;

  Nm_2 = N_2 / K_2;
  Ns_2 = sqrt((N2_2 - N_2^2 / K_2) / (K_2-1));
  CiN_2 = [Nm_2 - diGamma * Ns_2 / sqrt(K_2), Nm_2 + diGamma * Ns_2 / sqrt(K_2)];
  errN_2 = 2 * diGamma * Ns_2 / sqrt(K_2) / Nm_2;

  Varm_2 = Var_2 / K_2;
  Vars_2 = sqrt((Var2_2 - Var_2^2 / K_2) / (K_2-1));
  CiVar_2 = [Varm_2 - diGamma * Vars_2 / sqrt(K_2), Varm_2 + diGamma * Vars_2 / sqrt(K_2)];
  errVar_2 = 2 * diGamma * Vars_2 / sqrt(K_2) / Varm_2;

  
  if errR_2 < Max_Rel_Err && errU_2 < Max_Rel_Err && errX_2 < Max_Rel_Err && errN_2 < Max_Rel_Err && errVar_2 < Max_Rel_Err
    break;
  else
    K_2 = K_2 + DK_2;
    newIters_2 = DK_2;
  end
end

fprintf("\nScenario 2: ");
if errR_2 < Max_Rel_Err && errU_2 < Max_Rel_Err && errX_2 < Max_Rel_Err && errN_2 < Max_Rel_Err && errVar_2 < Max_Rel_Err
  fprintf(1, "\nMaximum Relative Error reached in %d Iterations\n", K_2);
else
  fprintf(1, "\nMaximum Relative Error NOT REACHED in %d Iterations\n", K_2);
end  

fprintf("Utilization in [%g, %g], with %g confidence. Relative Error: %g\n", CiU_2(1,1), CiU_2(1,2), gamma, errU_2);
fprintf("Resp. Time in [%g, %g], with %g confidence. Relative Error: %g\n", CiR_2(1,1), CiR_2(1,2), gamma, errR_2);
fprintf("Throughput in [%g, %g], with %g confidence. Relative Error: %g\n", CiX_2(1,1), CiX_2(1,2), gamma, errX_2);
fprintf("Average number of jobs in [%g, %g], with %g confidence. Relative Error: %g\n", CiN_2(1,1), CiN_2(1,2), gamma, errN_2);
fprintf("Variance of the response time in [%g, %g], with %g confidence. Relative Error: %g\n", CiVar_2(1,1), CiVar_2(1,2), gamma, errVar_2);

%% FUNCTIONS

function Hyper_Exp_arr = HyperExpGen()
    t1 = rand();
    t2 = rand();
    lambda1_hyper = 0.02;
    lambda2_hyper = 0.2;
    p1_hyper = 0.1;

    if t1 <= p1_hyper;
        Hyper_Exp_arr = -log(t2) / lambda1_hyper;
    else
        Hyper_Exp_arr = -log(t2) / lambda2_hyper;
    end
    
end

function Uni_serv = UniformGen()
	a = 5;
	b = 10;

	Uni_serv = a + (b-a) * rand();
end

function Exp_arr = ExpGen()
    lambda_Exp = 0.1;

    Exp_arr = -log (rand()) / lambda_Exp;
end

function Erlang_serv = ErlangGen()
    kappa_Erlang = 10;
    lambda_Erlang = 1.5;

    Erlang_serv = -log(prod(rand(kappa_Erlang,1))) / lambda_Erlang;
end
