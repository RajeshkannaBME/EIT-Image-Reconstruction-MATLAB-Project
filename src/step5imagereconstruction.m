@ -0,0 +1,44 @@

% Load the filtered signals from Step 4
load('lung_heart_signals.mat', 'lung_signals', 'heart_signals');

% Check the number of frames
[num_pixels, T] = size(lung_signals);
nx = 32; ny = 32;

if num_pixels ~= nx * ny
    error("Expected 32x32 pixels (%d), but got %d pixels.", nx*ny, num_pixels);
end

% Allocate image matrices
lung_imgs = zeros(nx, ny, T);
heart_imgs = zeros(nx, ny, T);

% Reshape signals into 32x32 images per frame
for t = 1:T
    lung_imgs(:,:,t) = reshape(lung_signals(:,t), nx, ny);
    heart_imgs(:,:,t) = reshape(heart_signals(:,t), nx, ny);
end

% 🫁 Play Lung Image Movie
figure('Name', 'Lung Movie');
for t = 1:50:T  % skip every 50th frame for speed
    imagesc(lung_imgs(:,:,t));
    axis image off;
    title(['🫁 Lung Activity – Frame ' num2str(t)]);
    colorbar;
    drawnow;
end

% ❤️ Play Heart Image Movie
figure('Name', 'Heart Movie');
for t = 1:50:T
    imagesc(heart_imgs(:,:,t));
    axis image off;
    title(['❤️ Heart Activity – Frame ' num2str(t)]);
    colorbar;
    drawnow;
end

% ✅ Save for Step 6
save('reconstructed_images.mat', 'lung_imgs', 'heart_imgs');