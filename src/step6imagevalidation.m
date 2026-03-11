@ -0,0 +1,21 @@
% Step 6 – Mean Activity Maps
% Assumes `lung_imgs` and `heart_imgs` already exist from Step 5
% Each should be a 32×32×T matrix

% ✅ Compute mean across time (3rd dimension)
avg_lung = mean(lung_imgs, 3);
avg_heart = mean(heart_imgs, 3);

% 📊 Plot mean lung activity
figure;
imagesc(avg_lung);
axis image off;
colorbar;
title('🫁 Average Lung Activity');

% 📊 Plot mean heart activity
figure;
imagesc(avg_heart);
axis image off;
colorbar;
title('❤️ Average Heart Activity');