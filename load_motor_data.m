%loads and plots the motor calibration data

%path and file name of data
fpath = 'C:\Users\choang\College\ESA\Rocky\Rocky_Project_2026\'; %path (change this!)
fname_in = 'Motor R16 Atp03'; %file name (change this!)

%load the motor calibration data
motor_data = readmatrix([fpath,fname_in]);

%unpack the motor calibration data
t = motor_data(4:end,1);
% cut vectors to one cycle
ind_1 = find(t>=4, 1);
ind_2 = find(t>=5.1, 1);
t_plot = t(ind_1:ind_2);
y_L = motor_data(ind_1:ind_2,2); v_L = motor_data(ind_1:ind_2,3);
y_R = motor_data(ind_1:ind_2,4); v_R = motor_data(ind_1:ind_2,5);

% plot the motor calibration data
figure(1);
subplot(2,1,1);
hold on
plot(t_plot,v_L,'k.','linewidth',1);
plot(t_plot,v_R,'r.','linewidth',1);
xlabel('time (sec)'); ylabel('wheel speed (m/sec)');
title('Motor Calibration Data');
h1 = legend('Left Wheel','Right Wheel');
set(h1,'location','southeast');
subplot(2,1,2);
hold on
plot(t_plot,y_L,'k','linewidth',1);
plot(t_plot,y_R,'r--','linewidth',1);
xlabel('time (sec)'); ylabel('wheel command (-)');
title('Motor Calibration Data');
h2 = legend('Left Wheel','Right Wheel');
set(h2,'location','southeast');

% Set parameters
rsquare = 0;
t_shift = t_plot - t_plot(1);

% Compute the fit line for the left motor
while rsquare < 0.90
    x0 = [.04 0.05];
    fit_func = fittype(@(K,tau,x) K/tau * (1 - exp(-x./tau)));
    [fit_result,gof] = fit(t_shift,v_L,fit_func,'StartPoint',x0);
    coeffs_L = coeffvalues(fit_result);
    rsquare = gof.rsquare;
end
K_L = coeffs_L(1)   % this is beta
tau_L = coeffs_L(2) % this is 1/alpha

% Compute the fit line for the right motor
rsquare = 0;
while rsquare < 0.90
    x0 = [.04 0.05];
    fit_func = fittype(@(K,tau,x) K/tau * (1 - exp(-x./tau)));
    [fit_result,gof] = fit(t_shift,v_R,fit_func,'StartPoint',x0);
    coeffs_R = coeffvalues(fit_result);
    rsquare = gof.rsquare;
end
K_R = coeffs_R(1)   % this is beta
tau_R = coeffs_R(2) % this is 1/alpha

% Plot fit lines
subplot(2,1,1)
plot(t_shift+t_plot(1), K_L/tau_L * (1 - exp(-(t_shift)./tau_L)), 'k', 'DisplayName','V_L Fit')
plot(t_shift+t_plot(1), K_R/tau_R * (1 - exp(-(t_shift)./tau_R)), 'r', 'DisplayName','V_R Fit')