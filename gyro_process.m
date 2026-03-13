


% Load data from file
fpath = 'C:\Users\choang\College\ESA\Rocky\Rocky_Project_2026\'; %path (change this!)
fname = 'Motor R16 Atp04.txt'; %file name (change this!)
data = readmatrix(fname);
t = data(:,1) - data(1,1);
theta = data(:,2);

figure(1);
hold on

% Crop the data
idx1 = find(t>=2.4,1);
idx2 = find(t>=7.3,1);
t_crop = t(idx1:idx2) - t(idx1);
theta_crop = theta(idx1:idx2) - theta(idx2);

plot(t_crop,theta_crop)

% fit a curve to the data
% our solution is a forced step response with two roots, underdamped
response = @(C,S,wd,sigma,x) exp(-sigma.*x).*(C.*cos(wd.*x) + S.*sin(wd.*x));
fitfunc = fittype(@(C,S,wd,sigma,x) exp(-sigma.*x).*(C.*cos(wd.*x) + S.*sin(wd.*x)));

rsquare = 0;
iter = 0;
while rsquare < 0.9 && iter < 100
    % Iterate until we get a good fit
    x0 = [1 1 0.6 1];
    [fitted,gof] = fit(t_crop,theta_crop,fitfunc,'StartPoint',x0);
    rsquare = gof.rsquare
    iter = iter + 1;
end
rsquare
fit_coeffs = coeffvalues(fitted)

% using the example code from hw2
% fitted = regress_underdamped_response(t_crop,theta_crop)
% C = fitted.C
% S = fitted.S
% D = fitted.D;
% wd = fitted.omega_d
% wn = fitted.omega_n;
% zeta = fitted.zeta;
% sigma = fitted.sigma
% theta_0 = fitted.y0;
% theta_dot_0 = fitted.y0;
% 
% theta_func = @(t) exp(-sigma.*t).*(C.*cos(wd.*t) + S.*sin(wd.*t))

t_space = linspace(0,5,100);
response_fit = @(t_in) response(fit_coeffs(1),fit_coeffs(2),fit_coeffs(3),fit_coeffs(4),t_in);
plot(t_space,response_fit(t_space))

wd = fit_coeffs(3);
sigma = fit_coeffs(4);

wn = sqrt(wd^2 + sigma^2);
zeta = sigma / wn;

g = 9.8;

wn_squared = wn^2
l_eff = g / wn^2

