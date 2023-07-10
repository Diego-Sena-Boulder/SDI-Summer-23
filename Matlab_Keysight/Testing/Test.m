%% Clear Vars
clearvars
close all
clc

%% Set Vars
sampleRateHz = 5e9;
sampleTimeS = 1e-6;
sampleLen = sampleTimeS*sampleRateHz;
maxTime = 1e9;

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout",40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true);
myScope.Acquisition.InitiateContinuous = true;

%% Set Scope Up
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = sampleTimeS; % Seconds
myScope.Channel("Channel1").VerticalRange = 4;
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Trigger.TriggerLevel = 1;
%% Gather Data
sampleLen = myScope.Acquisition.HorizontalRecordLength;
sampleRateHz = myScope.Acquisition.HorizontalSampleRate;
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (0:sampleLen-1) * dt;

figure (1)
plot(t, waveformArray, 'LineWidth', 1)
grid on;
xlabel('Time(s)')
ylabel('Volts (V)')

%% FFT the Data
%data = waveformArray - mean(waveformArray); % removed dc
DataFFT = abs(fft(waveformArray) ./ sampleLen);
f_HZ = (0:sampleLen/2-1)*(myScope.Acquisition.HorizontalSampleRate/sampleLen);
dataFFT = DataFFT(1:sampleLen/2);
figure (3)
semilogy(f_HZ, dataFFT, 'o')
grid on;
xlabel('Frequency (hz)', 'LineWidth', 2)
ylabel('Magnitude')
%xlim([0 4e3])




