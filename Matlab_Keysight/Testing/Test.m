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
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").InputImpedance = 1e6;
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 1.8;
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
amplitude = 0.789;
duty = mean(dutycycle(waveformArray)) * 100;
offset = mean(waveformArray);
idealWave = amplitude.*square(2*pi*expectedFrequency*t, duty) + offset;

%% Plot
figure (1)
hold on
plot(t*1e9, waveformArray, 'LineWidth', 2, 'Color', 'b')
plot(t*1e9, idealWave, '--', 'LineWidth', 3, 'Color', 'r')
grid on;
grid minor;
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 2;
ax.GridLineWidth = 1.5;
xlabel('Time(ns)', 'FontSize', 20)
ylabel('Volts (V)', 'FontSize', 20)
title('Ideal vs Measured', 'FontSize', 32)
legend({'Measured', 'Ideal'}, 'FontSize', 25)
hold off


%% FFT of Square Waves
f_Hz = (0:sampleLen/2-1)*(sampleRateHz/sampleLen) / 1e6;

DataFFT = fft(waveformArray, sampleLen) ./ sampleLen .* 2;
dataFFT = abs(DataFFT(1:floor(sampleLen/2)));

IdealFFT = fft(idealWave, sampleLen) ./ sampleLen .* 2;
idealFFT = abs(IdealFFT(1:floor(sampleLen/2)));

figure (2)
loglog(f_Hz, dataFFT, 'o', f_Hz, idealFFT, 'x', 'LineWidth', 2)
grid on
ax = gca;
ax.FontSize = 20;
xlabel('Frequency (MHz)', 'FontSize', 20)
ylabel('Amplitude (V)', 'FontSize', 20)
title('Ideal vs Measured', 'FontSize', 32)
legend({'Measured', 'Ideal'}, 'FontSize', 25)
xlim([0 3e3])


%% Harmonics
DataHarmonics = DataFFT([1 11:10:1001]);
dataHarmonics = abs(DataHarmonics);
IdealHarmonics = IdealFFT([1 11:10:1001]);
idealHarmincs = abs(IdealHarmonics);

F_Hz_Harmonics = f_Hz([1 11:10:1001]);

figure(3)
loglog(F_Hz_Harmonics, dataHarmonics, 'o', F_Hz_Harmonics, idealHarmincs, 'x', 'LineWidth', 3)
grid on
ax = gca;
ax.FontSize = 20;
xlabel('Frequency (MHz)', 'FontSize', 20)
ylabel('Amplitude (V)', 'FontSize', 20)
title('Ideal vs Measured, Harmonics Only', 'FontSize', 32)
legend({'Measured', 'Ideal'}, 'FontSize', 25)
xlim([9 1.1e3])

%% Transfer Function
DataOddHarmonics = DataHarmonics([1 2:2:end]);
IdealOddHarmonics = IdealHarmonics([1 2:2:end]);
harmonicTransfer = abs(DataOddHarmonics ./ IdealOddHarmonics);
F_Hz_Odd_Harmonics = F_Hz_Harmonics([1 2:2:end]);

const = polyfit(log(F_Hz_Odd_Harmonics(18:end)), log(harmonicTransfer(18:end)), 1);
%xFitting = 16:51; % Or wherever...
%yFitted = (exp(const(2)) .* F_Hz_Odd_Harmonics(xFitting).^const(1));
figure(4)
loglog(F_Hz_Odd_Harmonics, harmonicTransfer, 'LineWidth', 2) %'-', F_Hz_Odd_Harmonics(xFitting), yFitted, '-', 'LineWidth', 2)
grid on
ax = gca;
ax.FontSize = 20;
xlabel('Frequency (MHz)', 'FontSize', 20)
ylabel('Amplitude (V/V)', 'FontSize', 20)
title('Transfer Function of V(o)/V(i)', 'FontSize', 32)
legend('Transfer Function', 'FontSize', 25) %, 'Filter Trend'}
ylim([1e-3 2])
xlim([9 1.1e3])



