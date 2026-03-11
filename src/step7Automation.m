@ -0,0 +1,88 @@
% STEP 7: Fixed Automation Script for All Subjects and Trials

Subjects = 1:20;
TrialTypes = {'FEM', 'PEEP', 'PEEP_BH'};

% Sampling frequency
Fs = 50;

% Pre-allocate result storage
results = [];

for subj = Subjects
    for t = 1:length(TrialTypes)
        trial = TrialTypes{t};
        fprintf("\n🧪 Processing Subject %02d - %s...\n", subj, trial);

        try
            % Load the CSV file
            filename = sprintf('Processed_Dataset/ProcessedData_Subject%02d_%s.csv', subj, trial);
            Data = readtable(filename);

            % Extract time and aeration signal
            EIT_t = Data{:,8};
            EIT_A = Data{:,9};

            % Trim window for FFT (e.g., 5–35 seconds)
            t_min = 5;
            t_max = 35;
            inds = find(EIT_t >= t_min & EIT_t <= t_max);
            signal = EIT_A(inds);

            % Perform FFT
            N = length(signal);
            Y = fft(signal);
            f = (0:N-1)*(Fs/N);
            amp = abs(Y)/N;

            % Find peaks in 0–2 Hz
            f_mask = f <= 2;
            [pks, locs] = findpeaks(amp(f_mask), f(f_mask));

            % Sort peaks and keep two largest
            [~, sort_idx] = sort(pks, 'descend');
            top_freqs = locs(sort_idx(1:min(2,end)));

            % Assign frequencies
            BreathFreq = min(top_freqs);
            HeartFreq = max(top_freqs);

            % Count breaths (from inspiration index)
            tmp = Data{:,7};
            InspInd = tmp(tmp > 0);
            NumBreaths = numel(InspInd);

            % Detect perfusion presence
            PerfusionDetected = HeartFreq > 0.6;  % Typical heartbeat > 0.6 Hz

            % Determine signal quality
            if BreathFreq < 0.05 || NumBreaths == 0
                quality = "Apnea";
            elseif PerfusionDetected && BreathFreq > 0.05 && BreathFreq < 0.6
                quality = "Regular";
            else
                quality = "Irregular";
            end

            % Append result
            results = [results; {
                subj, trial, BreathFreq, HeartFreq, NumBreaths, PerfusionDetected, "Yes", quality
            }];

            fprintf("✅ Done with Subject %02d – %s!\n", subj, trial);

        catch ME
            warning("⚠️ Failed Subject %02d – %s: %s\n", subj, trial, ME.message);
        end
    end
end

% Save and display
ResultTable = cell2table(results, 'VariableNames', {
    'Subject', 'TrialType', 'BreathFreq_Hz', 'HeartFreq_Hz', ...
    'NumBreaths', 'PerfusionDetected', 'ReconDone', 'SignalQuality'});

writetable(ResultTable, 'SummaryResults_Fixed.csv');

disp("📊 Final Summary Table:");
disp(ResultTable);