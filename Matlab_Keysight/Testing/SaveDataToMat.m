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