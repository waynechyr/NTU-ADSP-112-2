% 讀取並轉換圖片為雙精度
A = double(imread('圖片一'));
B = double(imread('圖片二'));

% 設定常數
c1 = (1/255)^0.5;
c2 = (1/255)^0.5;

% 計算 A 和 B 的平均值
mu_A = mean(A(:));
mu_B = mean(B(:));

% 計算 A 和 B 的方差
sigma_A = var(A(:));
sigma_B = var(B(:));

% 計算 A 和 B 的協方差
sigma_AB = cov(A(:), B(:));
sigma_AB = sigma_AB(1, 2);

% 計算 SSIM
numerator = (2 * mu_A * mu_B + (c1*255)^2) * (2 * sigma_AB + (c2*255)^2);
denominator = (mu_A^2 + mu_B^2 + (c1*255)^2) * (sigma_A + sigma_B + (c2*255)^2);
ssim_value = numerator / denominator;

% 顯示 SSIM 結果
disp(['SSIM: ', num2str(ssim_value)]);

% 顯示兩張圖片
figure;
subplot(1, 2, 1);  % 第一張圖片位置
imshow(uint8(A));  % 將 A 轉換為 uint8 顯示
title('Image 1');

subplot(1, 2, 2);  % 第二張圖片位置
imshow(uint8(B));  % 將 B 轉換為 uint8 顯示
title('Image 2');

% 在圖窗中添加 SSIM 結果
sgtitle(['SSIM: ', num2str(ssim_value)]);
%subtitle(['SSIM: ', num2str(ssim_value)]);
