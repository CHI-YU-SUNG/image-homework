clear all;  close all;  clc;
origin_img = imread('image-pj4 (motion blurring).tif');
fft_img = fft2(origin_img);
fft_shift_img = fftshift(fft_img);

magnitude_spectrum = fftshift(log(1+abs(fft_img)));
T = 1.5; a = 0.017;
b=abs(a/tan(90*pi/180))
%b = 0;
for u = 0:511
    for v = 0:511
        k = pi*((u-255)*a+(v-255)*b);
        if k == 0
            k = 0.1;
        end
        temp = T./k.*sin(k).*exp(-1j*k);
        if temp == 0
            H(u+1, v+1) = 0.1;
        else
            H(u+1, v+1) = temp;
        end
    end
end
filter_img = fft_shift_img./H;
output_img = ifft2(ifftshift(filter_img));

imshow(output_img, []);

figure;
subplot(2,2,1), imshow(origin_img), title('oringin image');
subplot(2,2,2), imshow(output_img, []), title('output image');
subplot(2,2,3), imshow(magnitude_spectrum, []), title('magnitude spectrum');
subplot(2,2,4), imshow(abs(H).*255, []), title('filter spectrum');

