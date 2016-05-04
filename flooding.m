
function flooding()

imgBefore = imread('before.jpg');
imgAfter = imread('after.jpg');
b_size = size(imgBefore);
a_size = size(imgAfter);
if(b_size(1,1)~=a_size(1,1) || b_size(1,2) ~= a_size(1,2))
    disp('Error! Images have different size!');
    return;
end

imgBefore = rgb2gray(imgBefore);
imgAfter = rgb2gray(imgAfter);

[imgBefore,imgAfter] = graynorm(imgBefore,imgAfter);
% imgAfter = graynorm(imgAfter);

figure;
imshow(imgBefore);
title('水灾前');
figure;
imshow(imgAfter);
title('水灾后');

 % 受灾的区域在灰度归一化之后颜色偏白对应值偏大(0~1)，原图对应位置的值偏暗，所以用原图减去后图
imgSub = imgBefore - imgAfter;

figure;
imshow(imgSub);
title('差分图');
% 
% %---- start to judge -----%
% % here if the point's value is smaller than 

count_black = find(imgSub < 40/255);

% draw the possible space of disaster
image = draw('before.jpg',count_black);
figure;
imshow(image);
title('原图中的估计受灾位置');

count_all = numel(imgBefore);
fprintf('The percent is %2.2f\n',numel(count_black)/count_all);

end

function [obef,oaft] = graynorm(bef,aft)
%本函数把两个图像的灰度直方图放在同一个坐标中，对两个图像做归一化
bef_var =  var(double(bef(:)));
bef_mean = mean(mean(bef));
aft_var = var(double(aft(:)));
aft_mean = mean(mean(aft));

target_var = (bef_var + aft_var)/2;
target_mean = (bef_mean + aft_mean)/2;
cof = target_var/bef_var;
obef = (bef - bef_mean)*cof + target_mean;
oaft = (aft - aft_mean)*cof + target_mean;
end

function out_img = draw(src,count_black)
image = imread(src);
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);
R(count_black) = 220;
G(count_black) = 0;
B(count_black) = 0;
image(:,:,1) = R;
image(:,:,2) = G;
image(:,:,3) = B;
out_img = image;
end