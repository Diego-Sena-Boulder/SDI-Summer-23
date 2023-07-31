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

duty = 50.143;
amplitude1MOhm = 0.7985;
amplitudeSinWave = 0.5;
frequency = 10e6;

%% Instrument Connection & Reset Device
devlist = ividevlist("Timeout", 40);
myScope = ividev(devlist.MATLABDriver(1), devlist.ResourceName(1), ResetDevice = true);
myScope.Acquisition.InitiateContinuous = true;

%% Initial Set-Up 
% Configure horizontal time scale
myScope.Acquisition.HorizontalTimePerRecord = sampleTimeS; % Seconds
myScope.Channel("Channel1").InputImpedance = 1e6;
myScope.Acquisition.AcquisitionType = "AVERAGE";
myScope.Acquisition.NumberOfAverages = numAvg;
myScope.Trigger.TriggerLevel = 0;

%% Genearte Time Vector
sampleLen = myScope.Acquisition.HorizontalRecordLength;
sampleRateHz = myScope.Acquisition.HorizontalSampleRate;
dt = myScope.Acquisition.HorizontalTimePerRecord/myScope.Acquisition.HorizontalRecordLength;
t = (-sampleLen/2:sampleLen/2-1) * dt;

%% Sin Wave
% Set Scope Up for 1Vpp Sin Wave
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").InputImpedance = 1e6;
myScope.Channel("Channel1").VerticalRange = 1.1;

uiwait(msgbox(["Set Up 10MHz Sin Wave";"Click OK to continue"]));
% Gather 1Vpp Sin Wave
Sin10MHz = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% Square Wave
% Set Scope Up for Direct Connection
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up 10MHz Square Wave Wave";"Click OK to continue"]));
% Gather Direct Connection
Square1Mohm = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% AK-200 Probe
% Set Scope Up for 1X
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;


uiwait(msgbox(["Set Up for 60MHz AK-220 Probe for 1X";"Click OK to continue"]));
% Gather 1X
Square1Mohm60MHzAK1X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

% Set Scope Up for 10X
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for 60MHz Probe for 10X";"Click OK to continue"]));
% Gather 10X
Square1Mohm60MHzAK10X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% P-6100 Probe
% Set Scope Up for 1X
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for 100MHz P-6100 Probe for 1X";"Click OK to continue"]));
% Gather 1X
Square1Mohm100MHzP1X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

% Set Scope Up for 10X
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;


uiwait(msgbox(["Set Up for 100MHz P-6100 Probe for 10X";"Click OK to continue"]));
% Gather 10X
Square1Mohm100MHzP10X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% P-2200 Probe
% Set Scope Up for 1X
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for 200MHz P-2200 Probe for 1X";"Click OK to continue"]));
% Gather 1X
Square1Mohm200MHzP1X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

% Set Scope Up for 10X
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for 200MHz P-2200 Probe for 10X";"Click OK to continue"]));
% Gather 10X
Square1Mohm200MHzP10X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% TL PP-019 Probe
% Set Scope Up for 10X
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 2;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for 250MHz TL Probe for 10X";"Click OK to continue"]));
% Gather 10X
Square1Mohm250MHzTL10X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% TL PP-026 Probe
% Set Scope Up for 10X
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 2;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for 500MHz TL Probe for 10X";"Click OK to continue"]));
% Gather 1M Ohm Data
Square1Mohm500MHzTL10X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% RIGOL Probe
% Set Scope Up for 1X
myScope.Channel("Channel1").ProbeAttenuation = 1;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for RIGOL Probe for 1X";"Click OK to continue"]));
% Gather 1X
Square1MohmRIGOL1X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

% Set Scope Up for 10X
myScope.Channel("Channel1").ProbeAttenuation = 10;
myScope.Channel("Channel1").VerticalRange = 1.8;
myScope.Channel("Channel1").InputImpedance = 1e6;

uiwait(msgbox(["Set Up for RIGOL Probe for 10X";"Click OK to continue"]));
% Gather 10X
Square1MohmRIGOL10X = readWaveform(myScope, "Channel1", sampleLen, maxTime);

%% Generate Ideal Waves
ideal_1MOhmWave = amplitude1MOhm*square(2*pi*frequency*t, duty);
ideal_50_1MOhmWave = amplitude1MOhm*square(2*pi*frequency*t, 50);
ideal_SinWave = amplitudeSinWave*sin(2*pi*frequency*t);

%% Save Data to .mat File
save('ScopeData.mat', "t", "ideal_SinWave", "Sin10MHz", "Square1Mohm",...
     "ideal_1MOhmWave","ideal_50_1MOhmWave", "Square1Mohm60MHzAK1X", ...
     "Square1Mohm60MHzAK10X", "Square1Mohm100MHzP1X", "Square1Mohm100MHzP10X", ...
     "Square1Mohm200MHzP1X", "Square1Mohm200MHzP10X", "Square1Mohm250MHzTL10X", ...
     "Square1Mohm500MHzTL10X", "Square1MohmRIGOL1X", "Square1MohmRIGOL10X");
