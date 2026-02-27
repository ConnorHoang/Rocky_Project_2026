%loads and plots the pendulum calibration data
function [t, theta] = load_pendulum_data()
    %path and file name of data
    fpath = 'C:\Users\choang\Documents\'; %path (change this!)
    fname_in = 'CoolTerm Capture Gyro_1) 2026-02-27 11-15-17-735.txt'; %file name (change this!)
    %load the pendulum calibration data
    % pendulum_data = importdata([fpath,fname_in])
    pendulum_data = readmatrix([fpath,fname_in])
    %unpack the pendulum calibration data
    t = pendulum_data(:,1); theta = pendulum_data(:,2);
    %plot the motor calibration data
    figure(1);
    hold on
    plot(t,theta,'k','linewidth',1);
    xlabel('time (sec)'); ylabel('angle (rad)');
    title('Pendulum Calibration Data');
end

load_pendulum_data()