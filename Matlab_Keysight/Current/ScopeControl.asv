%% Clear Vars
clearvars; close all; clc;

%% Set Vars
samplerate = 5e9; % the sample rate you want from the scope
sampletime = 1e-6; % the time window you want from the scope
sampleLen = sampletime*samplerate; % the length of sample min size is 640 and max size is 62500
maxTime = 1e9; % the max time the scope is allowed to respond in milliseconds

%% Set Scope Up
% Configure horizontal range and scale
myScope.Acquisition.HorizontalTimePerRecord = sampletime; % Seconds
% Configure vertical range and scale
myScope.Channel("Channel1").VerticalRange = 2; % Peek to Peek Voltage range
myScope.Channel("Channel1").ProbeAttenuation = 1; % Attenuation of the scope probe 

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout",40); % Lists devices connected to the computer
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true); %% Chooses the correct device from the list

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
