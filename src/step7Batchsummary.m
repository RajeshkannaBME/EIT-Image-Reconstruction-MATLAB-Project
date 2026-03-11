@ -0,0 +1,82 @@
%% STEP 7: Batch Summary for All Subjects and Trials (with fixes)
clear; clc;

Subjects = 1:20;
TrialTypes = {'FEM', 'PEEP', 'PEEP_BH'};
Fs = 50;
Summary = {};  % Initialize results cell

for subj = Subjects
    for t = 1:length(TrialTypes)
        trial = TrialTypes{t};
        try
            filename = sprintf('Processed_Dataset/ProcessedData_Subject%02d_%s.csv', subj, trial);
            T = readtable(filename);

            % --- Extract Signals ---
            time = T{:,8};
            signal = T{:,9};
            L = length(signal);
            f = (0:L-1)*(Fs/L);
            Z = fft(signal);
            amp = abs(Z)/L;

            % --- Find Breaths ---
            [pks, locs] = findpeaks(signal, 'MinPeakProminence', 200);

            % --- Breath Frequency ---
            if length(locs) >= 2
                breath_intervals = diff(time(locs));
                avg_breath_period = mean(breath_intervals);
                breath_freq = 1 / avg_breath_period;
            else
                breath_freq = 0;
            end

            % --- Heart Frequency ---
            heart_band = (f >= 0.8 & f <= 1.5);
            [~, heart_idx] = max(amp .* heart_band');
            heart_freq = f(heart_idx);

            % --- Apnea detection ---
            if length(locs) >= 2
                apnea_gaps = diff(time(locs)) > 15;
                num_apnea = sum(apnea_gaps);
            else
                num_apnea = 0;
            end

            % --- Signal Quality ---
            if breath_freq > 0.08 && breath_freq < 0.5 && num_apnea < 3
                quality = "Good";
            else
                quality = "Irregular";
            end

            % --- Save Result ---
            Summary{end+1,1} = subj;
            Summary{end,2} = {trial};
            Summary{end,3} = round(breath_freq, 5);
            Summary{end,4} = round(heart_freq, 5);
            Summary{end,5} = length(locs);
            Summary{end,6} = num_apnea;
            Summary{end,7} = quality;

            fprintf("✅ S%02d - %s done\n", subj, trial);
        catch ME
            fprintf("⚠️ Skipped S%02d - %s: %s\n", subj, trial, ME.message);
        end
    end
end

% === FINAL TABLE CONVERSION FIX ===
Summary = Summary(~cellfun(@isempty, Summary(:,1)), :);  % Remove empty rows
valid_rows = cellfun(@(x) length(x)==7, num2cell(Summary,2));
Summary = Summary(valid_rows, :);  % Keep only valid rows

Results = cell2table(Summary, ...
    'VariableNames', {'Subject', 'TrialType', 'BreathFreq_Hz', 'HeartFreq_Hz', ...
                      'NumBreaths', 'Apneas', 'SignalQuality'});

writetable(Results, 'SummaryResults.csv');
fprintf('\n✅ SummaryResults.csv saved successfully.\n');