%% Clear Vars
clearvars;
close all;
clc;

%% Set Vars
sampleLen = 1000;
amplitude = 1;
frequency = 10e6;
dt = 1e-6 / sampleLen;

%% Generate Time Vector
t = (-sampleLen/2:sampleLen/2-1) * dt;

%% Generate Sin Wave
wave = amplitude*sin(2*pi*frequency*t);

%% Plot
figure(1)
plot(t, wave)
ylim([-1.1 1.1])

%% FFT of Ideal Sin Wave
f_HZ = (0:sampleLen/2-1)*(5e9/sampleLen);
Wave1FFT = fft(wave, sampleLen) ./ sampleLen .* 2;
wave1FFT = abs(Wave1FFT(1:floor(sampleLen/2)));
figure (2)
semilogy(f_HZ, wave1FFT, 'o')
grid on;
xlabel('Frequency (Hz)', 'FontSize', 14)
ylabel('Amplitude (A)', 'FontSize', 14)
