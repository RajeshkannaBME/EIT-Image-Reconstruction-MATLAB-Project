@ -0,0 +1,55 @@
% STEP 1: Load and Plot Signals from Processed Dataset (CSV)
clear; clc; close all;

% ---- Select Subject and Trial ----
Subject = 1;
Trial = 'FEM';   % Options: 'FEM', 'PEEP', 'PEEP_BH'

% ---- Construct File Path ----
filename = sprintf('Processed_Dataset/ProcessedData_Subject%02d_%s.csv', Subject, Trial);
if ~isfile(filename)
    error('File not found: %s', filename);
end

% ---- Read Table ----
Data = readtable(filename);

% ---- Extract Signals ----
PSD_t = Data{:,1};       % Time [s]
PSD_V = Data{:,6};       % Tidal Volume [L]
InspInd = Data{:,7};     % Inspiration indices (integer)
EIT_t = Data{:,8};       % EIT time [s]
EIT_A = Data{:,9};       % Global aeration (impedance)
ECG_t = Data{:,10};
ECG = Data{:,11};         % ECG [mV]
PPG_t = Data{:,12};
PPG0 = Data{:,13}; PPG1 = Data{:,14}; PPG2 = Data{:,15};

% ---- Filter Valid Inspiration Markers ----
valid_inds = InspInd(InspInd > 0 & InspInd <= length(PSD_t));

% ---- Plot All Signals ----
figure('Name', sprintf('Subject %02d - %s', Subject, Trial), 'Position', [100 100 800 800]);

subplot(4,1,1)
plot(PSD_t, PSD_V, 'b'); hold on;
xline(PSD_t(valid_inds), '--k');
title('Tidal Volume [L]'); xlabel('Time [s]'); ylabel('Volume'); grid on;

subplot(4,1,2)
plot(EIT_t, EIT_A, 'm'); hold on;
xline(PSD_t(valid_inds), '--k');
title('EIT Global Aeration'); xlabel('Time [s]'); ylabel('Impedance'); grid on;

subplot(4,1,3)
plot(ECG_t, ECG, 'r');
title('ECG Signal [mV]'); xlabel('Time [s]'); ylabel('Amplitude'); grid on;

subplot(4,1,4)
plot(PPG_t, PPG0, 'b'); hold on;
plot(PPG_t, PPG1, 'g');
plot(PPG_t, PPG2, 'r');
title('PPG Signals'); xlabel('Time [s]'); ylabel('Amplitude'); legend('PPG0','PPG1','PPG2'); grid on;

% ---- Done ----
disp('✅ Step 1 Complete: Signals loaded and plotted. Zoom in to inspect good breathing segments.');