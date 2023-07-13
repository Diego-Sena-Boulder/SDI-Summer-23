%% Clear Vars
clearvars; close all; clc;

%% Set Vars
sampletime = 1e-6; % the time window you want from the scope
maxTime = 1e9; % the max time the scope is allowed to respond in milliseconds
numAvg = 100; % the number of averages you want for the data.

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout",40); % Lists devices connected to the computer
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true); %% Chooses the correct device from the list

%% Set Scope Up
% Configure horizontal range and scale
myScope.Acquisition.HorizontalTimePerRecord = sampletime; % Seconds
% Configure vertical range and scale
myScope.Channel("Channel1").VerticalRange = 2; % Peek to Peek Voltage range
myScope.Channel("Channel1").ProbeAttenuation = 1; % Attenuation of the scope probe 
myScope.Trigger.TriggerLevel = 0; % sets the level of the trigger
%% Gather Data
sampleLen = myScope.Acquisition.HorizontalRecordLength;
sampleRateHz = myScope.Acquisition.HorizontalSampleRate;
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);

for n = 0:(numAvg - 2)
    [holdwaveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);
    waveformArray = waveformArray + holdwaveformArray;
end

waveformArray = waveformArray ./ numAvg;
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (0:sampleLen-1) * dt;

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


