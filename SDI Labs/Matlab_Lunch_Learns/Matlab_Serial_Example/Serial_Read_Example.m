%% Clear Vars
close all; clearvars; clc;
fclose('all');
delete 'Data.txt';

%% Setting Inital Variables
Fs = 100;         % Sampling frequency Hz
buffSize = Fs * 6;
T = 1/Fs;         % Sampling period       
L = buffSize;     % Length of signal
t = (0:L-1)*T;    % Time vector
n = 0:L-1;
f_omega = n*2/L;  % Omega For X-Axis
f_hz = n*Fs/L;    % Hz for X-Axis

%% Data Gathering
s = serialport("COM3", 115200);
configureTerminator(s, "CR/LF");
readline(s)

for i = 1:buffSize
    AData = readline(s);
    writematrix(AData, 'Data.txt','Delimiter', ',', 'WriteMode', 'append');
end

clear s;

%% Plot Data
figure(1)
buffer = readmatrix('Data.txt');

plot(t, buffer);
title('Sin vs Time');
xlabel('Time (s)');
ylabel('Amplitude (V)');

%% Calculate Data


