img = double(imread('輸入圖片'));
[h,w,c] = size(img);

rgb2ycbcr=[ 0.2990    0.5870    0.1140;...
   -0.1690   -0.3310    0.5000;...
    0.5000   -0.4190   -0.0810;];

ycbcr = zeros(h,w,c);
ycbcr420 = zeros(h,w,c);
imgafterycbcr = zeros(h,w,c);

for i = 1 : h
    for j = 1 : w
        ycbcr(i,j,:) = rgb2ycbcr * double([img(i, j, 1);img(i, j, 2);img(i, j, 3)]);
    end
end

%4:2:0採樣
ycbcr420(1:h, 1:w, 1) = ycbcr(1:h, 1:w, 1);
ycbcr420(1:2:h, 1:2:w, 2) = ycbcr(1:2:h, 1:2:w, 2);
ycbcr420(1:2:h, 1:2:w, 3) = ycbcr(1:2:h, 1:2:w, 3);

% 插值操作
ycbcr420(2:2:h-1, 1:2:w, 2) = (ycbcr420(1:2:h-2, 1:2:w, 2) + ycbcr420(3:2:h, 1:2:w, 2))./2;
ycbcr420(1:2:h, 2:2:w-1, 2) = (ycbcr420(1:2:h, 1:2:w-2, 2) + ycbcr420(1:2:h, 3:2:w, 2))./2;
ycbcr420(2:2:h-1, 2:2:w, 3) = (ycbcr420(1:2:h-2, 2:2:w, 3) + ycbcr420(3:2:h, 2:2:w, 3))./2;
ycbcr420(1:2:h, 2:2:w-1, 3) = (ycbcr420(1:2:h, 1:2:w-2, 3) + ycbcr420(1:2:h, 3:2:w, 3))./2;

% 處理邊界問題
ycbcr420(:,w,2) = ycbcr420(:,w-1,2);
ycbcr420(h,:,3) = ycbcr420(h-1,:,3);

% 將YCbCr空間的圖像轉換回RGB空間
for i = 1 : h
    for j = 1 : w
        imgafterycbcr(i,j,:) = inv(rgb2ycbcr) * [ycbcr420(i, j, 1);ycbcr420(i, j, 2);ycbcr420(i, j, 3)];
    end
end

% 將浮點數轉換為8位無符號整數
imgafterycbcr = uint8(imgafterycbcr);

% 顯示壓縮後的圖像
imshow(imgafterycbcr);
