%% Clear Vars
clearvars
close all
clc

%% Set Vars
expectedFrequency = 10e6; % which is in Hz
numCycles = 10;
sampleTimeS = 1 / expectedFrequency * numCycles;
maxTime = 1e9;
numAvg = 1000;

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout",40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true);
myScope.Acquisition.InitiateContinuous = true;

%% Set Scope Up
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = sampleTimeS; % Seconds
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Acquisition.AcquisitionType = "AVERAGE";
myScope.Acquisition.NumberOfAverages = numAvg;
myScope.Trigger.TriggerLevel = 0;
%% Gather Data
sampleLen = myScope.Acquisition.HorizontalRecordLength;
sampleRateHz = myScope.Acquisition.HorizontalSampleRate;
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (-sampleLen/2:sampleLen/2-1) * dt;

figure (1)
plot(t, waveformArray, 'LineWidth', 1)
grid on;
xlabel('Time(s)')
ylabel('Volts (V)')

%% FFT the Data
%data = waveformArray - mean(waveformArray); % removed dc
DataFFT = fft(waveformArray, sampleLen) ./ sampleLen .* 2;
f_HZ = (0:sampleLen/2-1)*(myScope.Acquisition.HorizontalSampleRate/sampleLen);
dataFFT = abs(DataFFT(1:sampleLen/2));
figure (2)
loglog(f_HZ, dataFFT, 'o', 'LineWidth', 2)
grid on;
xlabel('Frequency (hz)', 'FontSize', 14)
ylabel('Amplitude (A)', 'FontSize', 14)




