%% Clear Vars
clearvars
close all
clc

%% Set Vars
expectedFrequency = 10e6; % which is in Hz
numCycles = 10; % number of cycles to capture
sampleTimeS =  1 / expectedFrequency * numCycles; % takes the expected frequency and number of cycles to calculate 
                                                  % the size of the time buffer
maxTime = 1e12;
numAvg = 1000; % the number of averages taken

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout", 40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true);
myScope.Acquisition.InitiateContinuous = true;

%% Set Scope Up
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = sampleTimeS; % Seconds
myScope.Channel("Channel1").VerticalRange = 1.1;
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").InputImpedance = 1e6;
myScope.Acquisition.AcquisitionType = "AVERAGE";
myScope.Acquisition.NumberOfAverages = numAvg;
myScope.Trigger.TriggerLevel = 0;

%% Gather Data
sampleLen = myScope.Acquisition.HorizontalRecordLength;
sampleRateHz = myScope.Acquisition.HorizontalSampleRate;
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);
dt = myScope.Acquisition.HorizontalTimePerRecord/sampleLen;
t = (-sampleLen/2:sampleLen/2-1) * dt;

%% Generate Square Wave
amplitude = 0.5;
%offset = mean(waveformArray);
idealWave = amplitude*sin(2*pi*expectedFrequency*t); % + offset;

%% Plot
figure (1)
hold on
plot(t*1e9, waveformArray, 'LineWidth', 2, 'Color', 'b')
plot(t*1e9, idealWave, '--', 'LineWidth', 2, 'Color', 'r')
grid on;
ax = gca;
ax.FontSize = 20;
xlabel('Time(ns)', 'FontSize', 25)
ylabel('Volts (V)', 'FontSize', 25)
title('Ideal vs Measured', 'FontSize', 32)
legend({'Measured', 'Ideal'}, 'FontSize', 20)
ylim([-0.6 0.6])
hold off


%% FFT of Square Waves
f_Hz = (0:sampleLen/2-1)*(sampleRateHz/sampleLen) / 1e6;

DataFFT = fft(waveformArray, sampleLen) ./ sampleLen .* 2;
dataFFT = abs(DataFFT(1:floor(sampleLen/2)));

IdealFFT = fft(idealWave, sampleLen) ./ sampleLen .* 2;
idealFFT = abs(IdealFFT(1:floor(sampleLen/2)));

figure (2)
loglog(f_Hz, dataFFT, 'o', f_Hz, idealFFT, '+', 'LineWidth', 2)
grid on
ax = gca;
ax.FontSize = 20;
title('Ideal vs Measured', 'FontSize', 32)
legend({'Measured', 'Ideal'}, 'FontSize', 20)
xlabel('Frequency (MHz)', 'FontSize', 25)
ylabel('Amplitude (V)', 'FontSize', 25)
xlim([0 3e3])

annotation('textarrow', [0.38 0.357], [0.89 0.91], 'String', ...
           '10 MHz Primary Component', 'FontSize', 20, 'HeadWidth', 20, ...
           'LineWidth', 2);


%% Transfer Function

Transfer = (dataFFT ./ idealFFT);
transfer = abs(Transfer(1:floor(sampleLen/2)));

figure(3)
loglog(f_Hz, transfer, 'o')

