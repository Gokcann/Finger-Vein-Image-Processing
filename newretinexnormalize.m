
clc
clear
close all

%input al�yoruz.
image = imread(strcat('14.png'));		
image = im2double(image);
%parmak d���nda kalan yerler belirleniyor.
bolge=lee_usage(image);					

%gerekli de�i�kenler olu�turuluyor.
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

[n_rows,n_columns] = size(image);			

    diff = zeros(n_rows,n_columns);
%konvol�syon i�lemi uygulan�yor.
        convoluted_image = convolution(image(:,:),sigma*2/2);			
        diff(:,:) = log(image(:,:))-log(convoluted_image);
%retinex filtresi i�lemleri yap�l�yor.
    MSRCR = diff.*(log(125*image(:,:))-log(sum(image,3)));				
    s_min = prctile(MSRCR(:),s1);
    s_max = prctile(MSRCR(:),100-s2);

%sonu� normalize ediliyor.
    output_MSRCR = 255*(MSRCR-s_min)/(s_max-s_min);						
    output_MSRCR(MSRCR<=s_min) = 0;
    output_MSRCR(MSRCR>=s_max) = 255;
    output_image=output_MSRCR;
	%parmak d���nda kalan b�lge siliniyor.
 for i=1:size(image,1)
        for j=1:size(image,2)
    cikti(i,j)=output_image(i,j)*bolge(i,j);					
    
    
        end
        end 
 cikti(isnan(cikti))=0;

%kutu i�lemleri
 k=1;l=1;
 sayac=1;
j=1;

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
				%Orjinal g�r�nt� ve Retinex uygulanm�� g�r�nt� kutulan�yor.
   tamkutu(sayac,x,y)=cikti(a,b);          				
   kutu(sayac,x,y)=cikti(a,b);
   orjikutu(x,y)=image(a,b)*bolge(a,b)*255;
 orji(sayac,x,y)=image(a,b)*bolge(a,b)*255;
 
 orjireti(x,y)=cikti(a,b)*bolge(a,b);
   yeni(a,b)=cikti(a,b);
 sonori(a,b)=image(a,b)*bolge(a,b)*255;
 

 
        end
       
   
    end 
   sifirsizorji=1;
   sifirsizreg=1;
     clear  yeniorjisifirsiz;
   clear yenirexsifirsiz;
   yeniorjisifirsiz(1)=0;
   yenirexsifirsiz(1)=0;
  %ortalama ve standart sapma hesab� i�in g�r�nt�deki
  %siyah pikseller i�lem d���nda tutuluyor.
         for indisi=1:size(orjikutu,1)					 
        for indisj=1:size(orjikutu,2)					
            if(orjikutu(indisi,indisj)>0)
                yeniorjisifirsiz(sifirsizorji)=orjikutu(indisi,indisj);
                sifirsizorji=sifirsizorji+1;
            end
             if(orjireti(indisi,indisj)>0)
                yenirexsifirsiz(sifirsizreg)=orjireti(indisi,indisj);
                sifirsizreg=sifirsizreg+1;
            end
        end
         end
%ortalama ve standart sapma hesaplan�yor.
 orjiort(sayac)=mean2(yeniorjisifirsiz);				
 orjistd(sayac)=std2(yeniorjisifirsiz);

 
 retiort(sayac)=mean2(yenirexsifirsiz);
 retistd(sayac)=std2(yenirexsifirsiz);

   
     sayac=sayac+1;
   j=j+1;
    
        end
        
   end 
   
   
     fis=readfis('kurallar');
%standart sapma ve ortalama de�erleri normalize edilerek 0-1 aral���na �ekiliyor.
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
		 %ortalama ve standart sapma de�erleri 
		 %Mamdani bulan�k ��karsama sistemine g�nderiliyor.
   w(i)=evalfis(input,fis);						
    end											
    
      for i=1:sayac
orjiort(i)=orjiort(i)*maxort;
orjistd(i)=orjistd(i)*maxstd;
retiort(i)=retiort(i)*maxretort;
retistd(i)=retistd(i)*maxrest;
     
        
    end
%kutular�n tekrar birle�tirilme i�lemleri.
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

    
  
        enson2(k,l)=(orji(sayac,x,y)*(w2))+(kutu(sayac,x,y)*(1-w2));

        end 
       
        
    end
       sayac=sayac+1;
     j=j+1;
      

        end
        
   end 


sayac=1;
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
   fislikutu(x,y)=enson2(a,b);          
   
 

        end
    end
	%Bulan�k ��karsama sistemi uygulanm�� kutular�n
	%ortalama ve standart sapma de�erleri bulunuyor.
    fisliort(sayac)=mean2(fislikutu);					
     fislistd(sayac)=std2(fislikutu);					
     sayac=sayac+1;
        end
       
   
    end 
%Orijinal, Retinex filtresi uygulanm�� ve 
%Bulan�k ��karsama sisteminden ��km�� g�r�nt�ler
%Ekrana yazd�r�l�yor.
figure													
subplot(3,1,1)											
imshow(image)											
title('OR�J�NAL');
subplot(3,1,2)
imshow(uint8(enson2));
title('FIS');
subplot(3,1,3)
imshow(uint8(cikti));
title('RETINEX');