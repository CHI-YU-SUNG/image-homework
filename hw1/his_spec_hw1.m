clc;
clear;
close;

a = imread('camellia (mono) 512x512.tif');                %Read the Image
b = size(a);             
%scale = 1;
%shift = 0;
r = 0:255;                                          %Defining input pixels
%d = round(scale*r)+ shift;                          %linear Transformation function
count = zeros(3,256);
spec = zeros(1,256);
ep = zeros(b);
transform = zeros(b);

original_data =imhist(a);

%loop for spec gray level accumulation 
for i= 0:255
    if i>63 && i<192
        spec(1,i+1)=spec(1,i)+800;
    elseif i==0
        spec(1,i+1)=1248;  
    else
        spec(1,i+1)=spec(1,i)+1248;
    end
end

    %loop for count input image gray level 
for i=1:b(1)                                        %loop tracing the rows of image
    for j=1:b(2)                                    %loop tracing thes columns of image
        %t=(a(i,j)+1);                               %pixel values in image
        %ep(i,j)=d(t);                              %Making the ouput image using
        ep(i,j)=a(i,j);                              %Making the ouput image using
       count(1,ep(i,j)+1)=count(1,ep(i,j)+1)+1;     %counting
    end                                             
end
%loop for count input gray level accumulation
for i= 0:255
    if i==0
        count(2,i+1)=0;  
    else
        count(2,i+1)=count(2,i)+count(1,i+1);
    end
end
%loop for comparsion
for i=1:256                                        %loop tracing the  arrary count
    for j=1:256                                   %loop tracing thes columns of image
       if count (2,i)>spec(1,j)
           count (3,i)=j;
       end 
    end                                             
end

%transform
for i=1:b(1)                                        %loop tracing the rows of image
    for j=1:b(2)                                    %loop tracing thes columns of image
        t=(a(i,j)+1);                               %pixel values in image
        %ep(i,j)=d(t);                              %Making the ouput image using
        ep(i,j)=t;                              %Making the ouput image using
        transform(i,j)=count(3,ep(i,j));     %counting
    end                                             
end



%Procedure for plotting histogram
hist1 = zeros(1,256);                               %prealocation space for input histogram
hist2 = zeros(1,256);                               %prealocation space for output histogram

for i1=1:b(1)                                       %loop tracing the rows of image 
    for j1=1:b(2)                                   %loop tracing the Columns of image
        for k1=0:255                                %loop checking which graylevel
            if a(i1,j1)==k1                         %match found at k1
                hist1(k1+1)=hist1(k1+1)+1;          %increase the value at k1
            end
            if transform(i1,j1)==k1                        %for output image
                hist2(k1+1)=hist2(k1+1)+1;                
            end
        end
    end
end        
%transform=im2double(transform);   

%Plotting input image output image and their respective histograms

subplot(2,2,1);
imshow(a);
title('original image');
subplot(2,2,3);
imshow(uint8(transform));
title('output image');
subplot(2,2,2);
%plot(hist1);
imhist(a);
subplot(2,2,4);
%plot(hist2);

imhist(uint8(transform));

%Plotting input image output image 

figure;
subplot(1,2,1);
imshow(a);
title('original image');
subplot(1,2,2);
imshow(uint8(transform));
title('output image');

%%%
figure;
plot(count(3,:));
xlabel('input gray level');
ylabel('output gray level');



