%% Clear Vars
clearvars
close all
clc

%% Set Vars
sampleLen = 5000;
duty = 50.143;
amplitude = 0.8;
frequency = 10e6;

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout", 40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true);
myScope.Acquisition.InitiateContinuous = true;

%% Generate Time Vector

t = linspace(-500e-9, 500e-9, sampleLen);

%% Generate Square Wave
idealWave = amplitude*square(2*pi*frequency*t, duty);

%% Plot
figure(1)
plot(t, idealWave)
ylim([-0.9 0.9])

%% FFT of Ideal Square Wave
DataFFT = fft(idealWave, sampleLen) ./ sampleLen .* 2;
f_HZ = (0:sampleLen/2-1)*(5e9/sampleLen);
dataFFT = abs(DataFFT(1:floor(sampleLen/2)));
figure (2)
loglog(f_HZ, dataFFT, 'o', 'LineWidth', 2)
grid on;
xlabel('Frequency (Hz)', 'FontSize', 14)
ylabel('Amplitude (A)', 'FontSize', 14)
% xlim([0 3e9])