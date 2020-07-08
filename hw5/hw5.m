clear all;  close all;  clc;
% 1024*1024
origin_img = imread('violet (color).tif');
img = im2double(origin_img);

% (a)-------------------------------------------------------------------
% RGB(double)
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
% Hue
numi=1/2*((R-G)+(R-B));
denom=((R-G).^2+((R-B).*(G-B))).^0.5;
H=acosd(numi./(denom+0.000001));
H(B>G)=360-H(B>G);
H=H/360;
%Saturation
S=1 - (3./(sum(img,3)+0.000001)).*min(img,[],3);
%Intensity
I=sum(img, 3)./3;

figure;
subplot(2,3,2), imshow(origin_img), title('origin image');
subplot(2,3,4), imshow(H, []), title('Hue');
subplot(2,3,5), imshow(S, []), title('Saturation');
subplot(2,3,6), imshow(I, []), title('Intensity');

% (b)-------------------------------------------------------------------
% RGB(integer)
int_R = double(origin_img(:,:,1));
int_G = double(origin_img(:,:,2));
int_B = double(origin_img(:,:,3));

output = zeros(1024,1024,3);
for i = 1:1024
    for j = 1:1024
        % a1 = [134 51 143]
        a1 = int_R(i, j)-134;
        b1 = int_G(i, j)-51;
        c1 = int_B(i, j)-143;
        distance1 = a1.^2 + b1.^2 + c1.^2;
        if distance1 <= 900
            output1(i,j,:) = img(i, j, :);
        end
        % a2 = [131 132 4]
        a2 = int_R(i, j)-131;
        b2 = int_G(i, j)-132;
        c2 = int_B(i, j)-4;
        distance2 = a2.^2 + b2.^2 + c2.^2;
        if distance2 <= 900
            output2(i,j,:) = img(i, j, :);
        end
    end
end
figure;
subplot(1,3,1), imshow(origin_img), title('origin image');
subplot(1,3,2), imshow(output1, []),title('color slicing at (134, 51, 143)');
subplot(1,3,3), imshow(output2, []),title('color slicing at (131, 132, 4)');

