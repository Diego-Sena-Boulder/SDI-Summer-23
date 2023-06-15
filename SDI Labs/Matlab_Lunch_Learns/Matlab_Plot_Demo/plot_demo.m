%% We generate some data with random Gaussian noise added.
% We could have also captured real data.

time_ms = 0:0.5:100;
signal_mV = (0.0 .* time_ms) + 1000.0;

% introduce Gaussian noise
signal_mV = awgn(signal_mV, 10);

%% We create a new figure and plot our data.
f0 = figure();

plot(time_ms, signal_mV);

%% We label our axes and set a title.
xlabel("Time (ms)");
ylabel("Voltage (mV)");

title("Signal vs Time");

%% If we want, we can specify plotting style
plot(time_ms, signal_mV, '.');
%% and color.
plot(time_ms, signal_mV, 'Color', 'red');

xlabel("Time (ms)");
ylabel("Voltage (mV)");

title("Signal vs Time");

%% We can place multiple plots on the same axes.
hold on;

yyaxis left;
ylim([995 1005]);

% Create a seperate y axis
yyaxis right;
ylim([0 5]);
plot(time_ms, abs(signal_mV - 1000), 'Color', 'blue');

% We can create a legend for our plots in the order we created them.
legend("Signal", "Absolute Error");

%% Create a new figure and generate two random signals.
f1 = figure();

time_ms = 0:0.5:100;

signal1_mV = (0.0 .* time_ms) + 1000.0;
signal1_mV = awgn(signal1_mV, 10);

signal2_mV = (0.0 .* time_ms) + 1000.0;
signal2_mV = awgn(signal2_mV, 10);
signal2_mV = signal2_mV + sin(time_ms .* 0.376);

%% Plot both data on a shared x axis.
stackedplot(time_ms, transpose([signal1_mV; signal2_mV]), ...
    "DisplayLabels", ["Signal 1", "Signal 2"]);

xlabel("Time (ms)");

%% Create a new figure and plot a histogram of our data.
f4 = figure();

% We want multiple subfigures titled.
tiledlayout(2, 2); % 2 x 2 layout

% Select the first subfigure for plotting.
nexttile;
% Let MATLAB choose our bin size.
histogram(signal1_mV);
title("Signal 1 (Auto Bins)");
xlabel('Voltage (mV)');
ylabel('Frequency');

%% 
nexttile;
histogram(signal2_mV);
title("Signal 2 (Auto Bins)");
xlabel('Voltage (mV)');
ylabel('Frequency');

%% Manually set our bin edges.
nexttile;

% Plot 995 mV through 1005 mV in 0.1 mV increments
edges = 995:0.1:1005;

histogram(signal1_mV, edges);
title("Signal 1 (Manual Bins)");
xlabel('Voltage (mV)');
ylabel('Frequency');

nexttile;
histogram(signal2_mV, edges);
title("Signal 2 (Manual Bins)");
xlabel('Voltage (mV)');
ylabel('Frequency');

%% Log and Semilog Plots

f2 = figure();

% generate points logarithmically spread from 10^1 to 10^6
freq = logspace(1, 6);

% Evauluate a low pass transfer function on freq
cutoff_freq = 10^4;
response = 1 ./ sqrt(1 + (freq ./ cutoff_freq) .^ 2);
response_dB = 20 * log10(response);
response_phase_deg = -atan(freq ./ cutoff_freq) .* 180.0 / pi;

% Plot our transfer function with logarithmic x axis
semilogx(freq, response_dB);

%%

xlabel("Frequency (Hz)");
ylabel("Response Magnitude (dB)");
% Display a grid
grid on;

%%

yyaxis right;
semilogx(freq, response_phase_deg);

ylabel("Response Phase (dB)");

%% We can have MATLAB use LaTeX to display text in our figures.

fontsize(30, "pixels");

xlabel("$f$ (Hz)", 'Interpreter', 'latex');

yyaxis left;
ylabel("$|H(j\omega)|_{dB}$", 'Interpreter','latex');

yyaxis right;
ylabel("$\angle H(j\omega)$", 'Interpreter', 'latex');

figure(f0);

plot(freq, response_dB);
