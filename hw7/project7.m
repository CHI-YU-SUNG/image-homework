clear all;  close all;  clc;
img=imread('image-pj7c.tif');
B = double(img(:,:,3));
G = double(img(:,:,2));
R = double(img(:,:,1));
numsuper=100;
T=10;
c=1;
[M,N]=size(R);
numtotal=M*N;
S=floor(sqrt(numtotal/numsuper));
m=zeros(numsuper,5);
m_x=S;
m_y=S;
%初始的mi
for i=1:numsuper
    
    m(i,1)=R(m_x,m_y);
    m(i,2)=G(m_x,m_y);
    m(i,3)=B(m_x,m_y);
    m(i,4)=m_x;
    m(i,5)=m_y;
    m_x=m_x+S;
    if(m_x>M)
        m_x=S;
        m_y=m_y+S;
    end    
end    
%根據grdient改變mi的位置
[gradient_magnitude_r,gradient_angle_r] = imgradient(R);
[gradient_magnitude_g,gradient_angle_g] = imgradient(G);
[gradient_magnitude_b,gradient_angle_b] = imgradient(B);
gradient_magnitude=sqrt(gradient_magnitude_r*gradient_magnitude_r+gradient_magnitude_g*gradient_magnitude_g+gradient_magnitude_b*gradient_magnitude_b);
k_x=0;
k_y=0;
for k=1:numsuper
    gradient=gradient_magnitude(m(k,4),m(k,5));
    for i=-1:1
        for j=-1:1
            if(m(k,4)+i<M)
               m_new_x=m(k,4)+i;   
            else
                m_new_x=m(k,4);
            end    
            if(m(k,5)+j<N)
               m_new_y=m(k,5)+j;   
            else
                m_new_y=m(k,5);
            end   
            if(gradient>gradient_magnitude(m_new_x,m_new_y))
                gradient=gradient_magnitude(m_new_x,m_new_y);
                k_x=m_new_x;
                k_y=m_new_y;
                
            end
        end
    end   
    if(gradient>gradient_magnitude(m_new_x,m_new_y))
        m(k,1)=R(k_x,k_y);
        m(k,2)=G(k_x,k_y);
        m(k,3)=B(k_x,k_y);
        m(k,4)=k_x;
        m(k,5)=k_y;
    end
   
end
label=zeros(numtotal,4);
m_new=zeros(numsuper,5);


for time=1:5 
    for i=1:M
        for j=1:N
            %初始化D，給一個很大的值確保第一個D一定會小於初始值
            serial=(j-1)*M+i;
            label(serial,1)=i;
            label(serial,2)=j;
            label(serial,4)=1000000;
        end
    end
    sum1=0;
    for k=1:numsuper
        
        for i=-S:S
            for j=-S:S
                    if(m(k,4)+i<M&&m(k,4)+i>=1)
                        x=m(k,4)+i;     
                    else
                        x=m(k,4);
                    end    
                    if(m(k,5)+j<N&&m(k,5)+j>=1)
                        y=m(k,5)+j;                  
                    else    
                        y=m(k,5);
                    end   
                    d_color=(m(k,1)-R(x,y))^2+(m(k,2)-G(x,y))^2+(m(k,3)-B(x,y))^2;
                    d_space=(m(k,4)-x)^2+(m(k,5)-y)^2;
                    D=sqrt(d_color/c/c+d_space/S/S);
                    serial=(y-1)*M+x;
                    if(label(serial,4)>D)
                        label(serial,1)=x;
                        label(serial,2)=y;
                        label(serial,3)=k;
                        label(serial,4)=D;         
                
                    end
            end
        end
    end
    
    count=zeros(numsuper,6);
        for a=1:M
            for b=1:N
                serial=b+(a-1)*M               
                count(label(serial,3),1)=count(label(serial,3),1)+R(a,b);
                count(label(serial,3),2)=count(label(serial,3),2)+G(a,b);
                count(label(serial,3),3)=count(label(serial,3),3)+B(a,b);
                count(label(serial,3),4)=count(label(serial,3),4)+a;
                count(label(serial,3),5)=count(label(serial,3),5)+b;
                count(label(serial,3),6)=count(label(serial,3),6)+1;
            end
        end
   for p=1:numsuper
        m_new(p,1)=count(p,1)/count(p,6);
        m_new(p,2)=count(p,2)/count(p,6);
        m_new(p,3)=count(p,3)/count(p,6);
        m_new(p,4)=count(p,4)/count(p,6);
        m_new(p,5)=count(p,5)/count(p,6);
        sum1=sum1+sqrt((m_new(p,1)-m(p,1))^2+(m_new(p,2)-m(p,2))^2+(m_new(p,3)-m(p,3))^2+(m_new(p,4)-m(p,4))^2+(m_new(p,5)-m(p,5))^2)
    
    if(sum1<T)
        m(p,1)=floor(m_new(p,1));
        m(p,2)=floor(m_new(p,2));
        m(p,3)=floor(m_new(p,3));
        m(p,4)=floor(m_new(p,4));
        m(p,5)=floor(m_new(p,5));
        time=10;
    else
       m(p,1)=floor(m_new(p,1));
        m(p,2)=floor(m_new(p,2));
        m(p,3)=floor(m_new(p,3));
        m(p,4)=floor(m_new(p,4));
        m(p,5)=floor(m_new(p,5));
    end
   end
end
for a=1:M
    for b=1:N
          serial=b+(a-1)*M
          R(a,b)=m(label(serial,3),1);
          G(a,b)=m(label(serial,3),2);
          B(a,b)=m(label(serial,3),3);
              
    end
end
final=zeros(size(img));
final(:,:,1)=R/255;
final(:,:,2)=G/255;
final(:,:,3)=B/255;
figure(1);
imshow(final,'InitialMagnification',67);
C=final-img./255;
figure(2);
imshow(C,'InitialMagnification',67);

