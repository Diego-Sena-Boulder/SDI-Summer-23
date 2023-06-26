%% Clear Vars
clearvars
close all
clc

%% Instrument Connection & Reset Device
myScope = ividev('AgInfiniiVision', 'USB0::0x0957::0x17A6::MY57310896::0::INSTR'); % ResetDevice = true

%% Set Scope Up
sampleLength = 5000;
maxTime = 1e9;
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = 100e-8; % Seconds

%% Gather Data
[waveformArray, actualPoints] = readWaveform(myScope, "Channel1", sampleLength, maxTime);
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (0:sampleLength-1) * dt;

figure (1)
plot(t, waveformArray)
grid on;
xlabel('Time(s)')
ylabel('Volts (V)')
