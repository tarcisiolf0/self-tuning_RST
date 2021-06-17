clc
%% Read and transform file into time, r(t), y(t) and u(t) arrays
data = cell2mat(struct2cell(load('auto_reg_4_order_with_error_values.mat')));
% data = cell2mat(struct2cell(load('auto_reg_with_error_values_sin.mat')));
time = data(1,:);
rt = data(2,:);
yt = data(3,:);
ut = data(4,:);
%% Calculate absolute and square errors
abs_error = abs(yt - rt);
square_error = (yt - rt).^2;

%% Calculate IAE, ISE and ITAE
dt = [];
for i = 1:length(time)-1
    dt = [dt time(i+1)-time(i)];
end
    
iae = sum(abs_error(2:length(abs_error)) .* dt)
ise = sum(square_error(2:length(square_error)) .* dt)
itae = sum(time(2:length(time)) .* abs_error(2:length(abs_error)) .* dt)

%% Set Goodhart constants
alpha1 = 0.3;
alpha2 = 0.5;
alpha3 = 0.2;

%% Calculate Goodhart index
X = time(end);
E1 = sum(ut)/X;
E2 = sum(ut - E1).^2/X;
E3 = sum(abs_error)/X;

goodhart = alpha1 * E1 + alpha2 * E2 + alpha3 * E3

%% Set RBEMCE and RBMSEMCE constant
beta = 1;
len = size(time);
n = len(2);

%% Calculate RBEMCE and RBMSEMCE
rbemce = (1/n) * sum(abs_error) + (beta/n) * sum(ut)
rbmsemce = (1/n) * sum(square_error) + (beta/n) * sum(ut)

%% Calculate variability
mu = sum(yt) / n;
sigma = sqrt(sum((yt - mu).^2) / n);
variability = 2 * sigma / mu