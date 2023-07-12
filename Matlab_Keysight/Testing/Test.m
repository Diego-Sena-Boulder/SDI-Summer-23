%% Clear Vars
clearvars
close all
clc

%% Set Vars
sampleRateHz = 5e9;
sampleTimeS = 200e-9;
sampleLen = sampleTimeS*sampleRateHz;
maxTime = 1e9;
numAvg = 100;

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout",40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true);
myScope.Acquisition.InitiateContinuous = true;

%% Set Scope Up
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = sampleTimeS; % Seconds
myScope.Channel("Channel1").VerticalRange = 1.2;
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Trigger.TriggerLevel = 0;
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
xlabel('Frequency (hz)')
ylabel('Magnitude (Vpp)')
xlim([0 200e6])



