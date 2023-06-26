%% Clear Vars
clearvars
close all
clc

%% Instrument Connection
list = ividriverlist;
devlist = ividevlist("Timeout",40);
dev = ividev("AgInfiniiVision","USB0::0x0957::0x17A6::MY57310896::0::INSTR");

%% Reset Device
reset(dev)
dev.Channel("Channel1").ChannelEnabled = false;
dev.configurede = 62500;


%% Enable Channel 2
recordLength = actualRecordLength(dev);
dev.Channel("Channel2").ChannelEnabled = true;
maxTimeMilliseconds = 1e2;

%% Read Channel 2
[waveformArray,actualPoints] = readWaveform(dev,"Channel2",recordLength,maxTimeMilliseconds);

n = numel(waveformArray);

dt = dev.Acquisition.HorizontalTimePerRecord/dev.Acquisition.HorizontalRecordLength;
t = (0:n-1) * dt;