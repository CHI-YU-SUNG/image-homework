% 2D FFT Demo
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;

% Change the current folder to the folder of this m-file.
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
	
% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'cameraman.tif';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
	% File doesn't exist -- didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
% Read in image.
grayImage = imread('cameraman.tif');
[rows columns numberOfColorChannels] = size(grayImage)
if numberOfColorChannels > 1
	grayImage = rgb2gray(grayImage);
end

% Display original grayscale image.
subplot(2, 2, 1);
imshow(grayImage)
title('Original Gray Scale Image', 'FontSize', fontSize)

% Perform 2D FFTs
fftOriginal = fft2(double(grayImage));
shiftedFFT = fftshift(fftOriginal);
subplot(2, 2, 2);
scaledFFTr = 255 * mat2gray(real(shiftedFFT));
imshow(log(scaledFFTr), []);
title('Log of Real Part of Spectrum', 'FontSize', fontSize)
subplot(2, 2, 3);
scaledFFTi = mat2gray(imag(shiftedFFT));
imshow(log(scaledFFTi), []);
title('Log of Imaginary Part of Spectrum', 'FontSize', fontSize)

% Display magnitude and phase of 2D FFTs
subplot(2, 2, 4);
imshow(log(abs(shiftedFFT)),[]);
colormap gray
title('Log Magnitude of Spectrum', 'FontSize', fontSize)
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Now convolve with a 2D rect function.
figure;
rectWidth = 10;
rectHeight = 5;
kernel = ones(rectHeight, rectWidth) / (rectHeight * rectWidth);
% Display it
subplot(2, 2, 1);
k = padarray(kernel, [3, 3]); % Just for display.
imshow(k, []);
axis on;
title('Kernel', 'FontSize', fontSize)
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Convolve kernel (box filter) with the image
filteredImage = conv2(double(grayImage), kernel, 'same');
% Display filtered image.
subplot(2, 2, 2);
imshow(filteredImage,[]);
title('Filtered Image', 'FontSize', fontSize)

% Perform 2D FFT on the filtered image to see its spectrum.
% We expect to see a sinc multiplication effect.
% It should look like the original but with a sinc pattern overlaid on it.
fftFiltered = fft2(double(filteredImage));
shiftedFFT = fftshift(fftFiltered);

% Display magnitude of the 2D FFT of the filtered image.
subplot(2, 2, 3);
imshow(log(abs(shiftedFFT)),[]);
colormap gray
title('Log Magnitude of Spectrum - Note sinc multiplication', 'FontSize', fontSize)

