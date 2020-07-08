% 2D Laplacian Demo
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.

% Read in image.
grayImage = imread('Bird 1.tif');
[rows columns numberOfColorChannels] = size(grayImage);
if numberOfColorChannels > 1
	grayImage = rgb2gray(grayImage);
end
%%Process  2D DFT to origin image
fft_inti_img = fftshift(fft2(grayImage, 1024, 1024));

% Figures of the Fourier magnitude spectra of the bird image 
%after applying Laplacian filtering
%1024*1024*2 = 2097152, 512*512*2 = 524288, 256*256*2 = 
for u = 0:1023
    for v = 0:1023
        H(u+1, v+1) = ((u-512).^2 + (v-512).^2)/524288;
    end
end
%%process laplacian in frequency  domain
fft_filter_img = fft_inti_img.*H;
abs_filter_img = abs(fft_filter_img);

%Table of top 25 DFT frequencies (u,v) after Laplacian filtering
freq_table = sort(abs_filter_img(:), 'descend');
location = find(abs_filter_img >= freq_table(25));
for i= 1:25
  %location = find(abs_filter_img == freq_table(i));
   data(i, 1) = freq_table(i);
   data(i, 2) = location(i);
   data(i, 3) = mod(location(i),1024)-1; 
   data(i, 4) = fix(location(i)/1024);
end
%inverse fft
img = ifft2(ifftshift(fft_filter_img));
output_img = img(1:512, 1:512);

%Figure of the output image
figure;
subplot(1,2,1), imshow(grayImage), title('oringin image');
subplot(1,2,2), imshow(abs(output_img),[]), title('output image');
figure;
subplot(1,2,1), imshow(H.*255, []), title('magnitude of Laplacian filter');
subplot(1,2,2), imshow(log(1+abs_filter_img), []), title('magnitude spectrum after Laplacian filter');





