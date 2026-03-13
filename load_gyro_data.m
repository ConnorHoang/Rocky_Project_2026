%loads and plots the pendulum calibration data
%path and file name of data
fname_in = 'Gyro R16 Attempt05.txt'; %file name (change this!)
%load the pendulum calibration data
pendulum_data = readmatrix(fname_in);
%unpack the pendulum calibration data
t = pendulum_data(335:end,1); theta = pendulum_data(335:end,2); 

%plot the motor calibration data
figure();
hold on
plot(t,theta,'.', 'DisplayName', 'Measured Position');
xlabel('Time (sec)'); ylabel('Angle (rad)');
title('Pendulum Calibration Data');

% calculate fit line parameters
signal_params = gyro_fit(t,theta);
omega_d = signal_params.omega_d;
sigma = signal_params.sigma;
C = signal_params.C;
S = signal_params.S;
response = @(C,S,omega_d,sigma,x) exp(-sigma.*x).* ...
    (C.*cos(omega_d.*x) + S.*sin(omega_d.*x));
omega_n = signal_params.omega_n

% plot the fit line for validation 
plot(t, response(C, S, omega_d, sigma, t)+theta(end), 'linewidth',1.5, ...
    'DisplayName', 'Fit Line')
legend()

% Post processing
g=9.81;
l_eff = (g/omega_n^2)