%% Clear Vars
clearvars
close all
clc

%% Set Vars
samplerate = 5e9;
sampletime = 1e-6;
sampleLen = sampletime*samplerate;
maxTime = 1e9;

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout",40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true); 

%% Set Scope Up
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = sampletime; % Seconds
myScope.Channel("Channel1").VerticalRange = 2;
myScope.Channel("Channel1").ProbeAttenuation = 1;
%% Gather Data
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLen, maxTime);
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (0:sampleLen-1) * dt;

figure (1)
plot(t, waveformArray, 'LineWidth', 1)
grid on;
xlabel('Time(s)')
ylabel('Volts (V)')

%% FFT the Data
DataFFT = abs(fft(waveformArray) ./ sampleLen);
f_HZ = (0:sampleLen/2-1)*(myScope.Acquisition.HorizontalSampleRate/sampleLen);
dataFFT = DataFFT(1:sampleLen/2);
figure (2)
semilogy(f_HZ, dataFFT)
grid on;
xlabel('Frequency (hz)', 'LineWidth', 2)
ylabel('Magnitude')
xlim([0 1e9])




