%% Task 1
clearvars
close all
clc

cf_model = Simulink.SimulationInput('Assignment_2_model');

% Initialize variables
cf_model = cf_model.setVariable('interest', 0);
cf_model = cf_model.setVariable('salary_increase_rate', 0.025);

% Get time data
sim_results = sim(cf_model);
time_data = sim_results.yout{1}.Values.Time;

% a.)
minimum = 0;
interests = (0:0.5:10)';
cumulated_total_savings = zeros(length(interests),1);
savings = zeros(length(time_data),length(interests));

for i = 1:length(cumulated_total_savings)
    
    cf_model = cf_model.setVariable('interest',(interests(i)/100));
    sim_results = sim(cf_model);
    
    savings_data = sim_results.yout{1}.Values.Data;
    savings(:,i) = savings_data;
    
    final_savings = savings_data(end);
    cumulated_total_savings(i) = final_savings;
    
    if final_savings > 500 && minimum == 0
        disp(['Minimum interest rate: ',num2str(interests(i)), ' %'])
        minimum = 1;
    end
end

% i
figure
hold on
grid on
plot(interests, cumulated_total_savings, 'k');
plot(interests, cumulated_total_savings, 'bo');
title('Cumulated savings as a function of interest')
xlabel('Interest rate')
ylabel('Cumulated savings')
legend('Cumulated savings')

% ii
figure
hold on
grid on
for i = 1:size(savings,2)
    plot(time_data, savings(:,i), DisplayName=['interest rate: ', num2str(i-1), '%'])
end
title('Savings as a function of time')
xlabel('Time')
ylabel('Total savings')
legend(Location='Best')

% b.)  6.5 %

%% Task 2
clearvars
close all
clc

cf_model = Simulink.SimulationInput('Assignment_2_model');

% Initialize variables
cf_model = cf_model.setVariable('interest', 0);
cf_model = cf_model.setVariable('salary_increase_rate', 0.025);

% Get time data
sim_results = sim(cf_model);
time_data = sim_results.yout{1}.Values.Time;

interests = 0:1:10;
salary_increases = -1:1:5;
combinations = combvec(interests, salary_increases);
cumulated_total_savings = zeros(length(combinations),1);
savings = zeros(length(time_data),length(combinations));

for i = 1:length(combinations)

    interest_rate = combinations(1,i);
    salary_increase_rate = combinations(2,i);

    cf_model = cf_model.setVariable('interest',(interest_rate/100));
    cf_model = cf_model.setVariable('salary_increase_rate',(salary_increase_rate/100));
    sim_results = sim(cf_model);
    
    savings_data = sim_results.yout{1}.Values.Data;
    savings(:,i) = savings_data;
    
    final_savings = savings_data(end);
    cumulated_total_savings(i) = final_savings;
    
end

analysis_set = [combinations', cumulated_total_savings];
analysis_set_sorted = sortrows(analysis_set,3, 'ascend')

N = size(analysis_set_sorted,1);

positive = 0;
more_than_200K = 0;
for i = 1:N
    row = analysis_set_sorted(i,:);
    value = row(3);
    if positive == 0 && value > 0
        positive = 1;
        disp('a.) More than 0:')
        disp(['Interest rate: ', num2str(row(1)), ', Salary rate: ', num2str(row(2)), ', Value: ', num2str(value)])
        fprintf('\n')
    end

    if more_than_200K == 0 && value > 200
        more_than_200K = 1;
        disp('b.) More than 200K:')
        disp(['Interest rate: ', num2str(row(1)), ', Salary rate: ', num2str(row(2)), ', Value: ', num2str(value)])
        fprintf('\n')
    end
end

disp('c.) Minimum interest rate for 1M is 8%');
fprintf('\n')
disp('d.) Minimum salary increase for positive savings is 0%')

%% Task 3
clearvars
close all
clc

cf_model = Simulink.SimulationInput('Assignment_2_model');

% Initialize variables
cf_model = cf_model.setVariable('interest', 0);
cf_model = cf_model.setVariable('salary_increase_rate', 0.02); % Fixed value


interest_rates = 0:1:10;
revenues = zeros(length(interest_rates),4); % In order (years): 20, 30, 40, 50
for i = 1:length(interest_rates)
    
    cf_model = cf_model.setVariable('interest',(interest_rates(i)/100));
    sim_results = sim(cf_model);
    savings_data = sim_results.yout{1}.Values.Data;
    savings = savings_data(end)*1000; % Have to multiply it here
    retirement_data = sim_results.yout{2}.Values.Data;
    retirement = retirement_data(end);
    for years = 2:5
        revenues(i,years-1) = savings/(years*10*12)+retirement;
    end
    
end

figure
hold on
grid on
for i = 1:4
    plot(interest_rates, revenues(:,i), DisplayName=[num2str((i+1)*10), ' years'])
end
legend(Location='Best')
title('Retirement monhtly revenues')
xlabel('Interest rate')
ylabel('Monthly revenue')