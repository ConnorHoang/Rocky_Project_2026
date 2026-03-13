% loads and plots the motor calibration data
% name of data - ensure that it is in this folder!
fname_in = 'Motor R16 Atp03'; %file name

% load the motor calibration data
motor_data = readmatrix(fname_in);

% unpack the motor calibration data
t = motor_data(4:end,1);
% cut vectors to one cycle
ind_1 = find(t>=4.033, 1);
ind_2 = find(t>=5.1, 1);
t_plot = t(ind_1:ind_2);
y_L = motor_data(ind_1:ind_2,2); v_L = motor_data(ind_1:ind_2,3);
y_R = motor_data(ind_1:ind_2,4); v_R = motor_data(ind_1:ind_2,5);

% plot the motor calibration data
figure();
subplot(2,1,2);
hold on
plot(t_plot,v_L,'k.','linewidth',1);
plot(t_plot,v_R,'r.','linewidth',1);
xlabel('Time (sec)'); ylabel('Wheel Speed (m/sec)');
title('Motor Calibration Curve');
h1 = legend('Left Wheel Velocity','Right Wheel Velocity');
set(h1,'location','south');

% compare wheel velocity against wheel commands
subplot(2,1,1);
hold on
plot(t_plot,y_L,'k','linewidth',1);
plot(t_plot,y_R,'r--','linewidth',1);
xlabel('Time (sec)'); ylabel('Wheel Command (-)');
title('Motor Commands');
h2 = legend('Left Wheel','Right Wheel');
set(h2,'location','south');

% set parameters to prepare for fit-line calculations
rsquare = 0;
t_shift = t_plot - t_plot(1);

% compute the fit line for the left motor
iter = 0;
while rsquare < 0.90 && iter<100
    x0 = [.04 0.05];
    fit_func = fittype(@(K,tau,x) K/tau * (1 - exp(-x./tau)));
    [fit_result,gof] = fit(t_shift,v_L,fit_func,'StartPoint',x0);
    coeffs_L = coeffvalues(fit_result);
    rsquare = gof.rsquare;
    iter = iter+1;
end
K_L = coeffs_L(1)   % this is beta
tau_L = coeffs_L(2) % this is 1/alpha

% compute the fit line for the right motor
rsquare = 0;
iter = 0;
while rsquare<0.90 && iter<100
    x0 = [.04 0.05];
    fit_func = fittype(@(K,tau,x) K/tau * (1 - exp(-x./tau)));
    [fit_result,gof] = fit(t_shift,v_R,fit_func,'StartPoint',x0);
    coeffs_R = coeffvalues(fit_result);
    rsquare = gof.rsquare;
    iter = iter+1;
end
K_R = coeffs_R(1)   % this is beta
tau_R = coeffs_R(2) % this is 1/alpha

% plot fit lines
subplot(2,1,2)
plot(t_shift+t_plot(1), K_L/tau_L * (1 - exp(-(t_shift)./tau_L)), 'k', 'DisplayName','Left Wheel Fit')
plot(t_shift+t_plot(1), K_R/tau_R * (1 - exp(-(t_shift)./tau_R)), 'r', 'DisplayName','Right Wheel Fit')