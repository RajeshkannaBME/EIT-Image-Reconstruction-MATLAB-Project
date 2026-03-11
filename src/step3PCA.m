@ -0,0 +1,38 @@

% Load the .bin file
eit_data = read_binData('S01_PEEP.bin');  % Change to your file
[nx, ny, nt] = size(eit_data);            % Expect 32x32xT

% Reshape into [Pixels x Time]
V = reshape(eit_data, nx*ny, nt);         % 1024 x Time

% Transpose: Time x Pixels for PCA
[coeff, score, latent] = pca(V');         % V' is [Time x Pixels]

% Plot how much variance each PC explains
figure;
pareto(latent);
title('Variance Explained by Principal Components');

% Plot FFT of first 6 PCs
Fs = 50;  % Sampling frequency
T = 1/Fs;
t = (0:nt-1)*T;

figure;
for i = 1:6
    pc_signal = score(:,i);
    Y = fft(pc_signal);
    L = length(pc_signal);
    f = (0:L-1)*(Fs/L);
    amp = abs(Y)/L;

    subplot(3,2,i);
    plot(f(1:round(L/2)), amp(1:round(L/2)));
    title(['FFT of PC ' num2str(i)]);
    xlim([0 2]); grid on;
    xlabel('Frequency (Hz)');
end

% ✅ Save for Step 4
save('pca_result.mat', 'score', 'coeff');