clc;
clear all;

filename1 = 'Trace1.csv';
filename2 = 'Trace2.csv';
filename3 = 'Trace3.csv';
trace1 = csvread(filename1);
trace2 = csvread(filename2);
trace3 = csvread(filename3);

Trace = [trace1 trace2 trace3];

N = size(Trace,1);
sortedTrace = sort(Trace);

% Mean
Mean = sum(Trace) / N;
% Second moment
Moment2 = sum(Trace .^2) / N; 
% Third moment
Moment3 = sum(Trace .^3) / N;  
% Fourth moment
Moment4 = sum(Trace .^4) / N;

% Variance
Variance = var(Trace);
centeredMean = Trace - Mean;
% Third centered moment
CenteredMoment3 = sum(centeredMean .^3) / N;
% Fourth centered moment
CenteredMoment4 = sum(centeredMean .^4) / N;

% Skewness
Skewness = skewness(Trace);
% Standard Deviation
StdDev = std(Trace);
%stdMoment3 = sum((centeredMean ./ StdDev) .^3) / N;
% Fourth standardized moment
stdMoment4 = sum((centeredMean ./ StdDev) .^4) / N;

% Coefficient of variation
CoV = sqrt(Variance) ./ Mean;
% Excess Kurtosis
Kurtosis = kurtosis(Trace);
Kurtosis = Kurtosis - 3;

% Median
Median = median(Trace);
% First quartile
Percentile25 = prctile(Trace, 25);
% Third quartile
Percentile75 = prctile(Trace, 75);

% Plot of the approximated CDF of the corresponding distribution
for i = 1: +1: N
    counter(i,:) = i;
end
FunctionX = counter ./ N;
figure;
plot(sortedTrace(:, 1), FunctionX, 'LineWidth', 2);
title('Cumulative Distribution Function for Trace1', 'FontSize', 15);

figure;
plot(sortedTrace(:, 2), FunctionX, 'LineWidth', 2);
title('Cumulative Distribution Function for Trace2', 'FontSize', 15);

figure;
plot(sortedTrace(:, 3), FunctionX, 'LineWidth', 2);
title('Cumulative Distribution Function for Trace3', 'FontSize', 15);


% Plot of the Pearson Correlation Coefficient for lags m=1 to m=100
partialCrossCovariance = [zeros(100, 1), zeros(100, 1), zeros(100, 1)];
crossCovariance = [zeros(100, 1), zeros(100, 1), zeros(100, 1)];
PearsonCorrCoefficient = [zeros(100, 1), zeros(100, 1), zeros(100, 1)];
for i = 1: +1: 3
    for m = 1:100
        for j = 1:N-m
            partialCrossCovariance(m,i) = partialCrossCovariance(m,i) + (Trace(j,i) - Mean(1, i)) .* (Trace(j+m,i) - Mean(1, i));
        end
        crossCovariance(m, i) = (1/(N-m)) .* partialCrossCovariance(m, i);
        PearsonCorrCoefficient(m, i) = crossCovariance(m, i) ./ Variance(1, i);
    end    
end
figure;
plot([1:100], PearsonCorrCoefficient(:, 1), 'LineWidth', 2);
title('Pearson Correlation Coefficient for lags m=1 to m=100 for Trace1', 'FontSize', 15);

figure;
plot([1:100], PearsonCorrCoefficient(:, 2), 'LineWidth', 2);
title('Pearson Correlation Coefficient for lags m=1 to m=100 for Trace2', 'FontSize', 15);

figure;
plot([1:100], PearsonCorrCoefficient(:, 3), 'LineWidth', 2);
title('Pearson Correlation Coefficient for lags m=1 to m=100 for Trace3', 'FontSize', 15);

% Print
%fprintf(1, "\t  Trace 1 | Trace 2 | Trace 3\n");
fprintf(1, "Mean = ");
fprintf(1, "%g  ", Mean);
fprintf(1, "\nMoment 2 = ");
fprintf(1, "%g  ", Moment2);
fprintf(1, "\nMoment 3 = ");
fprintf(1, "%g  ", Moment3);
fprintf(1, "\nMoment 4 = ");
fprintf(1, "%g  ", Moment4);

fprintf(1, "\n\nVariance = ");
fprintf(1, "%g  ", Variance);
fprintf(1, "\nCentered Moment 3 = ");
fprintf(1, "%g  ", CenteredMoment3);
fprintf(1, "\nCentered Moment 4 = ");
fprintf(1, "%g  ", CenteredMoment4);

fprintf(1, "\n\nSkewness = ");
fprintf(1, "%g  ", Skewness);
fprintf(1, "\nStandardized Moment 4 = ");
fprintf(1, "%g  ", stdMoment4);

fprintf(1, "\n\nStandard Deviation = ");
fprintf(1, "%g  ", StdDev);
fprintf(1, "\nCoefficient of Variation = ");
fprintf(1, "%g  ", CoV);
fprintf(1, "\nExcess Kurtosis = ");
fprintf(1, "%g  ", Kurtosis);

fprintf(1, "\n\nMedian = ");
fprintf(1, "%g  ", Median);
fprintf(1, "\nFirst quartile = ");
fprintf(1, "%g  ", Percentile25);
fprintf(1, "\nThird quartile = ");
fprintf(1, "%g  ", Percentile75);

fprintf(1, "\n");