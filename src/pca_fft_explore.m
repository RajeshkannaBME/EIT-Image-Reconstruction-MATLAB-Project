@ -0,0 +1,34 @@
% Step 1: Load .bin file
frames = read_binData('S01_PEEP.bin');  % Replace with your file

% Step 2: Reshape 3D to 2D: [NumFrames x NumPixels]
[nRows, nCols, nFrames] = size(frames);
data2D = reshape(frames, [], nFrames)';  % size = [Time x Pixels]

% Step 3: PCA
[coeff, score, ~, ~, explained] = pca(data2D);

% Step 4: Plot explained variance
figure;
plot(cumsum(explained), 'o-');
xlabel('Number of Principal Components');
ylabel('Cumulative Variance Explained (%)');
title('Explained Variance by PCA');
grid on;

% Step 5: FFT on top 6 principal components
fs = 50;  % Sampling frequency
n = size(score,1);
freq = (0:n-1)*(fs/n);

figure;
for i = 1:6
    subplot(3,2,i);
    Y = abs(fft(score(:,i)));
    plot(freq(1:n/2), Y(1:n/2));
    title(['FFT of PC ' num2str(i)]);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    grid on;
end
sgtitle('FFT of First 6 Principal Components');