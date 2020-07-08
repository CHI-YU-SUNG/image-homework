% 2D DFT Demo
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;

% Read in image.
grayImage = imread('Bird 1.tif');
[rows columns numberOfColorChannels] = size(grayImage)
if numberOfColorChannels > 1
	grayImage = rgb2gray(grayImage);
end
%zero padding
padding_grayImage=zeros(1024,1024);
for i = 1:1024
    for j = 1:1024
        if i <= 512 && j<= 512
            padding_grayImage(i,j) = grayImage(i,j);
        else
            padding_grayImage(i,j) = 0;
        end
    end
end

% Display original grayscale image.
input_phase=zeros(1024,1024);
input_shiftedFFT=zeros(1024,1024);
subplot(2, 2, 1);
imshow(grayImage)
title('Original Gray Scale Image', 'FontSize', fontSize)

% Perform 2D FFTs
fftOriginal = fft2(double(padding_grayImage));
shiftedFFT = fftshift(fftOriginal);
subplot(2, 2, 2);
scaledFFTr = 255 * mat2gray(real(shiftedFFT));
imshow(log(scaledFFTr), []);
title('Log of Real Part of Spectrum', 'FontSize', fontSize)
subplot(2, 2, 3);
scaledFFTi = mat2gray(imag(shiftedFFT));
imshow(log(scaledFFTi), []);
title('Log of Imaginary Part of Spectrum', 'FontSize', fontSize)


% Display magnitude of 2D FFTs
subplot(2, 2, 4);
input_magnitude=log(abs(shiftedFFT )+1);
imshow(log(abs(shiftedFFT )),[]);
colormap gray
title('Log Magnitude of Spectrum', 'FontSize', fontSize)
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Display phase of 2D FFTs
figure;
subplot(1, 2, 1);
imshow(grayImage)
title('Original Gray Scale Image', 'FontSize', fontSize)
input_phase=angle(shiftedFFT);
subplot(1, 2, 2);
imshow(angle(shiftedFFT),[]);
title('phase of Spectrum', 'FontSize', fontSize)

%count top 25 frequency
top_25_freq=zeros(1,25);
top_25_freq=maxk(abs(fftOriginal(:)),25)
