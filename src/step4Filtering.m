@ -0,0 +1,46 @@


% Load PCA result (from Step 3)
load('pca_result.mat', 'score', 'coeff');  % Make sure you ran Step 3 fully

% Sampling rate
Fs = 50;  % EIT data sampled at 50 Hz

% 🫁 Filter Design for Breathing (0.1–0.4 Hz)
[b_lung, a_lung] = butter(4, [0.08 0.5]/(Fs/2), 'bandpass');

% ❤️ Filter Design for Heartbeat (0.8–1.5 Hz)
[b_heart, a_heart] = butter(4, [0.7 1.8]/(Fs/2), 'bandpass');

% Filter top N PCs (you can increase if needed)
numPCs = 6;
filtered_score_lung = zeros(size(score(:,1:numPCs)));
filtered_score_heart = zeros(size(score(:,1:numPCs)));

for i = 1:numPCs
    filtered_score_lung(:,i) = filtfilt(b_lung, a_lung, score(:,i));
    filtered_score_heart(:,i) = filtfilt(b_heart, a_heart, score(:,i));
end

% Reconstruct filtered voltage matrices [Pixels x Time]
coeff_subset = coeff(:,1:numPCs);  % 1024 x numPCs
lung_signals = (filtered_score_lung * coeff_subset')';     % 🫁
heart_signals = (filtered_score_heart * coeff_subset')';   % ❤️

% Plot one pixel for visual sanity check
pixel_id = 700;
figure;
subplot(2,1,1);
plot(lung_signals(pixel_id,:), 'b');
title(['Lung signal at pixel ' num2str(pixel_id)]);
xlabel('Time [frames]');
ylabel('Amplitude');

subplot(2,1,2);
plot(heart_signals(pixel_id,:), 'r');
title(['Heart signal at pixel ' num2str(pixel_id)]);
xlabel('Time [frames]');
ylabel('Amplitude');

% ✅ Save for use in Step 5 and Step 6
save('lung_heart_signals.mat', 'lung_signals', 'heart_signals');