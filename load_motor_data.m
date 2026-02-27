%loads and plots the motor calibration data
function [t, y_L, v_L, y_R, v_R] = load_motor_data()
    %path and file name of data
    fpath = 'C:\Users\choang\Documents\'; %path (change this!)
    fname_in = 'CoolTerm Capture (Motor_test) 2026-02-27 11-07-33-588.txt'; %file name (change this!)
    %load the motor calibration data
    motor_data = readmatrix([fpath,fname_in]);
    %unpack the motor calibration data
    t = motor_data(:,1);
    ind_1 = find(t>=25.998, 1);
    ind_2 = find(t>=27, 1);
    t_plot = t(ind_1:ind_2);
    y_L = motor_data(ind_1:ind_2,2); v_L = motor_data(ind_1:ind_2,3);
    y_R = motor_data(ind_1:ind_2,4); v_R = motor_data(ind_1:ind_2,5);
    %plot the motor calibration data

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
    tspace = linspace(0,ind_2-ind_1);

    % curve fit fun
    rsquare = 0
    while rsquare < 0.5
    x0 = [1 0.1];
    fit_func = fittype(@(K,tau,x) K/tau * (1 - exp(-x/tau)));
    [fit_result,gof] = fit(tspace,v_L,fit_func,'StartPoint',x0);
    coeffs = coeffvalues(fit_result);
    rsquare = gof.rsquare;
    end

    subplot(2,1,1)
    plot(tspace,coeffs(1)/coeffs(2) * (1 - exp(-tspace.*coeffs(2))))

end

