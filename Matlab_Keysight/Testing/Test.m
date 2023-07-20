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
myScope.Channel("Channel1").InputImpedance = 50;
myScope.Acquisition.AcquisitionType = "AVERAGE";
myScope.Acquisition.NumberOfAverages = numAvg;
myScope.Trigger.TriggerLevel = 0;

%% Gather Data
sampleLen = myScope.Acquisition.HorizontalRecordLength;
sampleRateHz = myScope.Acquisition.HorizontalSampleRate;
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (-sampleLen/2:sampleLen/2-1) * dt;

%% Generate Square Wave
amplitude = 0.407;
duty = mean(dutycycle(waveformArray)) * 100;
offset = mean(waveformArray);
idealWave = amplitude.*square(2*pi*expectedFrequency*t, duty) + offset;

%% Plot
figure (1)
hold on
plot(t, waveformArray, 'LineWidth', 1, 'Color', 'b')
plot(t, idealWave, 'LineWidth', 1, 'Color', 'r')
grid on;
xlabel('Time(s)', 'FontSize', 14)
ylabel('Volts (V)', 'FontSize', 14)
title('Ideal vs Measured', 'FontSize', 16)
legend('Measured', 'Ideal')
hold off


%% FFT of Square Waves
f_Hz = (0:sampleLen/2-1)*(sampleRateHz/sampleLen);

DataFFT = fft(waveformArray, sampleLen) ./ sampleLen .* 2;
dataFFT = abs(DataFFT(1:floor(sampleLen/2)));

IdealFFT = fft(idealWave, sampleLen) ./ sampleLen .* 2;
idealFFT = abs(IdealFFT(1:floor(sampleLen/2)));

figure (2)
loglog(f_Hz, dataFFT, 'o', f_Hz, idealFFT, 'o')
xlabel('Frequency (Hz)', 'FontSize', 14)
ylabel('Amplitude (A)', 'FontSize', 14)

%% Transfer Function

Transfer = (dataFFT ./ idealFFT);
transfer = abs(Transfer(1:floor(sampleLen/2)));

figure(3)
loglog(f_Hz, transfer, 'o')

