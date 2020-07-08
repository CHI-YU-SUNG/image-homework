% Clear all command window, temporary variables and close all MATLAB
window
clc;
clear;
close all;
% Read the image, data type: uint8
imdata = imread('Bird 1.tif' );
% Show the original image (Bird 1.tif)
figure;
imshow(imdata);
title('Original Image' );
% Get Fourier transform of original image and change the data type to double
F = fft2(im2double(imdata));
% Shift zero-frequency component to center of spectrum
Fsh = fftshift(F);
% Get the absolute of the spectrum of original image (Fourier magnitude)
S = abs(Fsh);
% Normalize the scale, its range [0 - 1]
c1 = 1 / log(max(S(:))+1);
% Show the Fourier magnitude using log scale
figure;
imagesc(c1.* log(S+1));
colorbar; % show color bar
colormap gray; % Let the image present gray-level
% Get the phase from the spectrum of original image
F_ph = angle(Fsh);
% Show the phase spectrum, its range [ -pi - pi]
figure;
imagesc(F_ph);
colorbar;
colormap gray;
% Find coordinates (u, v) of the top 25 frequency components from original image
input_top25_freq=[]; % Initial variable to store results
% Sorting the frequency components from Fourier magnitude. It returns value and index to M and I with descending
[M,I] = sort(S(:), 'descend' );
% Get the coordinates of top 25 frequency components
for kk=1:25
 if mod(I(kk),512) == 0
 row = 512;
 else
 row = mod(I(kk),512);
 end
 col = ceil(I(kk) / 512);
 input_top25_freq{kk,1} = [row, col];
end