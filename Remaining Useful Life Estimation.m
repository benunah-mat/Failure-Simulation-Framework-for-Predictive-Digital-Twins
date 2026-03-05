%% =========================================
% Phase 4
% Regime-Aware Failure Prediction
% =========================================

clear
clc
close all

%% Load Dataset

folder_path = "C:\Users\USER\Downloads\Projects\IMS\1st_test";

files = dir(folder_path);

count = 0;

for i = 1:length(files)

    name = files(i).name;

    if ~(files(i).isdir || endsWith(name,".m"))
        count = count + 1;
    end

end

signal = zeros(count,1);

index = 1;

for i = 1:length(files)

    name = files(i).name;

    if files(i).isdir || endsWith(name,".m")
        continue
    end

    file_path = fullfile(folder_path,name);

    data = load(file_path);

    vibration = data(:,1);

    signal(index) = rms(vibration);

    index = index + 1;

end

fprintf("Total measurements loaded: %d\n",length(signal));

%% Log Degradation

g = log(signal);

%% Accelerated Degradation Region

start_index = 1800;

t = (start_index:length(g))';

g_degradation = g(start_index:end);

%% Fit Quadratic Degradation Model

p = polyfit(t,g_degradation,2);

a = p(3);
b = p(2);
c = p(1);

fprintf("\nQuadratic degradation model coefficients:\n")
fprintf("a = %.6f\n",a)
fprintf("b = %.6f\n",b)
fprintf("c = %.6f\n",c)

%% Failure Threshold

failure_threshold = log(max(signal));

%% Predict Failure Time

coeff = [c b (a - failure_threshold)];

roots_t = roots(coeff);

t_failure = max(roots_t);

t_current = length(g);

RUL = t_failure - t_current;

fprintf("\nPredicted Failure Time: %.2f samples\n",t_failure)
fprintf("Remaining Useful Life: %.2f samples\n",RUL)

%% Prediction Error

true_failure = length(signal);

prediction_error = abs(t_failure - true_failure);

fprintf("\nTrue Failure Time: %d\n",true_failure)
fprintf("Prediction Error: %.2f samples\n",prediction_error)

%% Plot Degradation Model

figure
plot(g,'LineWidth',1.5)
hold on

t_full = (1:length(g))';

plot(t_full,a + b*t_full + c*t_full.^2,'r','LineWidth',2)

yline(failure_threshold,'k--','Failure Threshold')
xline(t_failure,'g--','Predicted Failure')

title("Failure Prediction using Accelerated Degradation Model")
xlabel("Time Index")
ylabel("Log Degradation")

legend("Log Degradation","Model","Failure Threshold","Predicted Failure")

grid on
