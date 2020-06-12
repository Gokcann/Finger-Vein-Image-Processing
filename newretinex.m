% This script aims at demonstrating the efficiency of the method
clc
clear
close all

% Parameters
image = imread(strcat('24.png'));
image = im2double(image);

bolge=lee_usage(image);







% Running the MSRCR algorithm
sigma = 25;
orjiort = zeros(1, 161)
orjistd = zeros(1,161);
retistd=zeros(1,161);
retiort=zeros(1,161);
w=zeros(1,161);
kutu=zeros(161,38,40);
orji=zeros(161,38,40);
s1 = 15;
s2 = 5;
%---------------------------%
[n_rows,n_columns] = size(image);
%output_image = zeros(n_rows,n_columns);
    diff = zeros(n_rows,n_columns);
    % Loop for each scales
        % Single scale retinex
       % for sigma = sigmas
        convoluted_image = convolution(image(:,:),sigma*2/2);
        diff(:,:) = log(image(:,:))-log(convoluted_image);
       % end
    % Multiscale retinex
    %MSR = 1/3*sum(diff,3);
    % Color restauration
    MSRCR = diff.*(log(125*image(:,:))-log(sum(image,3)));
    
    %output_image(:,:,color) = simplest_color_balance(MSR,s1,s2);
    
    % Cliping the extreme pixels
    s_min = prctile(MSRCR(:),s1);
    s_max = prctile(MSRCR(:),100-s2);

    % Simplest color balancing
    output_MSRCR = 255*(MSRCR-s_min)/(s_max-s_min);
    output_MSRCR(MSRCR<=s_min) = 0;
    output_MSRCR(MSRCR>=s_max) = 255;
    output_image=output_MSRCR;
 for i=1:size(image,1)
        for j=1:size(image,2)
    cikti(i,j)=output_image(i,j)*bolge(i,j);
    
    
        end
        end 
 cikti(isnan(cikti))=0;

 figure
 imshow(uint8(cikti));
 
 
 %kutulama denemesi
 k=1;l=1;
 sayac=1;
j=1;

 % k=k+40;
  %j=j+38;
  %enson=zeros(380,672);
 
   for i=0:38:379
        for j=0:40:639
 
    for a=i+1:i+38
       
        for b=j+1:j+40
           
            
            x=mod(a,39);
            y=mod(b,41);
            if(x==0)
                x=1; 
            end
                if(y==0)
                    y=1; 
                end
               
   kutu(sayac,x,y)=cikti(a,b)/255;
 orji(sayac,x,y)=image(a,b)*bolge(a,b);
 
   yeni(a,b)=cikti(a,b)/255;
 sonori(a,b)=image(a,b)*bolge(a,b);
 
 eskorj(x,y)=image(a,b)*bolge(a,b);
 eskutu(a,b)=cikti(a,b)/255;
 
        end
       
   
    end 
   
   j=j+1;
   
 orjiort(sayac)=mean2(orji);
 orjistd(sayac)=std2(orji);
 
 retiort(sayac)=mean2(kutu);
 retistd(sayac)=std2(kutu);
 
 eskort=mean2(eskutu);
 eskstd=std2(eskutu);
 
  reteskort=mean2(eskorj);
 reteskstd=std2(eskorj);
   % ortsapma(orji);
    % ortsapma(kutu);
    
    
     %fis hesaplamaca
      fis=readfis('kurallar');
      input=[eskort,eskstd,reteskort,reteskstd];
  was=evalfis(input,fis);
  
    sayac=sayac+1;
    %kutu iþlemi baþladý
 
     
    
      
  
    
     %kutu iþlemi bitti
  
   %imshow((enson));
        end
        
   end 
   
   
     fis=readfis('kurallar');
  
  maxort=max(orjiort);
  maxstd=max(orjistd);
  maxretort=max(retiort);
  maxrest=max(retistd);
    for i=1:sayac
orjiort(i)=orjiort(i)/maxort;
orjistd(i)=orjistd(i)/maxstd;
retiort(i)=retiort(i)/maxretort;
retistd(i)=retistd(i)/maxrest;
       
         input=[orjiort(i),orjistd(i),retiort(i),retistd(i)];
   w(i)=evalfis(input,fis);
    end

  sayac=1;
    for i=0:38:379
        for j=0:40:639
          
             for k=i+1:i+38
               for l=j+1:j+40
            
                 x=mod(k,39);
              
                 
                 y=mod(l,41);
              
                  if(x==0)
                        x=1; 
                 end
                if(y==0)
                    y=1; 
                end
 
    w2=w(sayac);

    
  
        enson2(k,l)=(orji(sayac,x,y)*(1-w2))+(kutu(sayac,x,y)*w2);

        end 
       
        
    end
       sayac=sayac+1;
     j=j+1;
      
  
    
     %kutu iþlemi bitti
  
   %imshow((enson));
        end
        
   end 
% end
%cikma=medfilt2(enson);

figure
subplot(3,1,1)
imshow(image)
title('orj image');
subplot(3,1,2)
imshow((enson2));
title('fisli image');
subplot(3,1,3)
imshow(uint8(cikti));
title('retinex');

%imshow(uint8(cikti));
%kutulama denemesi bitti
%show


