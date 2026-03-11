@ -0,0 +1,44 @@
% STEP 2: FFT of EIT Global Aeration Signal

% Choose Subject and Trial
Subject = 1;
Trial = 'FEM';

% Load file
filename = sprintf('ProcessedData_Subject%02d_%s.csv', Subject, Trial);
Data = readtable(filename);

% Extract EIT time and signal
EIT_t = Data{:,8};    % Time [s]
EIT_A = Data{:,9};    % Global Aeration

% Define time window to analyze (clean portion)
t_min = 10; t_max = 60;   % Adjust as needed
inds = EIT_t >= t_min & EIT_t <= t_max;
signal = EIT_A(inds);
time = EIT_t(inds);

% FFT parameters
Fs = 50;                 % Sampling frequency
N = length(signal);      % # of points
f = (0:N-1)*(Fs/N);      % Frequency axis

% FFT calculation
Y = fft(signal);
amp = abs(Y)/N;          % Normalize amplitude

% Plot only 0–5 Hz (rest is noise)
cut = find(f >= 5, 1);

% Plot FFT
figure;
plot(f(1:cut), amp(1:cut), 'LineWidth', 2);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title(sprintf('FFT of Global Aeration Signal – Subject %02d %s', Subject, Trial));
grid on;

% Annotate expected regions
hold on;
xline(0.3, '--g', 'Expected Breathing');
xline(1.0, '--r', 'Expected Heartbeat');