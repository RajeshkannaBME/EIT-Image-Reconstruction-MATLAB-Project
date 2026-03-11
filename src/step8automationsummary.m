@ -0,0 +1,73 @@
% step7Automation_summary.m
clear; clc;

subjects = 1:20;
trials = {'FEM', 'PEEP', 'PEEP_BH'};
Fs = 50; % Sampling frequency in Hz

results = [];

for subj = subjects
    for t = 1:length(trials)
        trial = trials{t};
        try
            % 1. Load the processed CSV
            file = sprintf('Processed_Dataset/ProcessedData_Subject%02d_%s.csv', subj, trial);
            T = readtable(file);
            time = T{:, 8};               % EITTime_s_
            signal = T{:, 9};             % EITGlobalAeration
            insp = T{:, 7};               % PSDInspiratoryIndex

            InspInd = find(insp > 0);     % Remove zeros

            % 2. FFT to get breath and heart frequencies
            L = length(signal);
            Y = fft(signal);
            P2 = abs(Y/L);
            P1 = P2(1:floor(L/2));
            f = Fs*(0:(L/2)-1)/L;

            [~, idxs] = maxk(P1(2:end), 2);
            dom_freqs = sort(f(idxs+1));  % skip DC

            breath_freq = dom_freqs(1);
            heart_freq  = dom_freqs(2);

            % 3. Breath count
            num_breaths = length(InspInd);

            % 4. Flags
            perfusion_flag = heart_freq > 0.8;

            % 5. Signal Quality Logic
            if num_breaths < 2
                quality = "Apnea";
            elseif breath_freq < 0.15 || breath_freq > 0.6 || heart_freq < 0.7 || heart_freq > 1.5
                quality = "Irregular";
            else
                quality = "Good";
            end

            % 6. Reconstruction flag (placeholder - update as needed)
            recon = "Yes";

            % 7. Add to results
            results = [results; {subj, trial, breath_freq, heart_freq, ...
                num_breaths, perfusion_flag, recon, quality}];

            fprintf("✅ Done with Subject %02d – %s\n", subj, trial);

        catch ME
            fprintf("⚠️ Skipped Subject %02d – %s: %s\n", subj, trial, ME.message);
        end
    end
end

% 8. Convert to table
resultsTable = cell2table(results, ...
    'VariableNames', {'Subject','TrialType','BreathFreq_Hz','HeartFreq_Hz','NumBreaths',...
                      'PerfusionDetected','ReconDone','SignalQuality'});

% 9. Display and optionally save
disp(resultsTable);
writetable(resultsTable, 'EIT_Result_Summary.csv'); % optional file output