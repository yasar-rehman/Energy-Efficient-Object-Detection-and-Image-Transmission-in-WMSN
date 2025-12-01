%%
%---------------SCENARIO 1--------------------------%
%IMAGE HISTOGRAM IS BELOW THRESHOLD

clear all
clc
set(0,'DefaultFigureWindowStyle','docked');
% set(0,'InitialMagnification','fit');
path(path,'\scenario4\video data set\winterDriveway\input');
%--------------------------------------------------------------------------
count_detect=0;
count_undetect=0;
count_detected=[];
count_undetected=[];
al_pha=0.2;
st='InitialMagnification';
pr='Fit';

 a='0';b='0';c='0';d='0';e='0';f='0';
%--------------------------------------------------------------------------
%Background update algorithm 
for i=250:999
    if i<10
    I_b=imread(cat(1,['in',a,b,c,d,e,num2str(i),'.jpg']));
    elseif i>=10&i<100
         I_b=imread(cat(1,['in',a,b,c,d,num2str(i),'.jpg']));
    elseif i>=100&i<999
        I_b=imread(cat(1,['in',a,b,c,num2str(i),'.jpg']));
    elseif i>=1000&i<1999
         I_b=imread(cat(1,['in',a,b,num2str(i),'.jpg']));
    end
    %----------------------------------------------------------------------
   I_b=rgb2gray(I_b);
   figure(1); imshow(I_b,st,pr)
    if i-250==0
     I_back=I_b; % background image
    [row_n,col_n]=size(I_b);
    I_b1=I_back(1:row_n/2,1:col_n/2); %getting first 32 x 32 pixel image
    I_b2=I_back(1:row_n/2,(col_n/2)+1:col_n); %getting the second 32 x 32 image
    I_b3=I_back(row_n/2+1:row_n,1:col_n/2); %getting the third 32 x 32 image
    I_b4=I_back(row_n/2+1:row_n,col_n/2+1:col_n);
    
    %----------------------------------------------------------------------
    %computing the histogram
    [nI_b1,I_b1loc]=imhist(I_b1); %computing the histograms of b1
    [nI_b2,I_b2loc]=imhist(I_b2); %computing the histograms of b2
    [nI_b3,I_b3loc]=imhist(I_b3); %computing the histograms of b3
    [nI_b4,I_b4loc]=imhist(I_b4); %computing the histograms of b4
        
  
    else
    %----------------------------------------------------------------------
    %Background updatation
    I_back=al_pha*I_back+(1-al_pha)*I_b;
    figure(2), imshow(I_back,st,pr)
    
    %----------------------------------------------------------------------
   %division of the given image into four regions
    I_c=I_b; % current image
    [row_n,col_n]=size(I_c);
    figure(3)
    subplot(2,2,1)
    I_c1=I_c(1:row_n/2,1:col_n/2); %getting first 32 x 32 pixel image
    imshow(I_c1,st,pr)
    I_c2=I_c(1:row_n/2,(col_n/2)+1:col_n); %getting the second 32 x 32 image
    subplot(2,2,2)
    imshow(I_c2,st,pr)
    
    I_c3=I_c(row_n/2+1:row_n,1:col_n/2); %getting the third 32 x 32 image
    subplot(2,2,3)
    imshow(I_c3,st,pr)
    
    I_c4=I_c(row_n/2+1:row_n,col_n/2+1:col_n);
    subplot(2,2,4)
    imshow(I_c4,st,pr)
    I_set_im={I_c1,I_c2,I_c3,I_c4}; %image set
    
    %----------------------------------------------------------------------
    %finding the absolute histogram
    [nI_c1,I_c1loc]=imhist(I_c1); %computing the histograms of b1
    [nI_c2,I_c2loc]=imhist(I_c2); %computing the histograms of b2
    [nI_c3,I_c3loc]=imhist(I_c3); %computing the histograms of b3
    [nI_c4,I_c4loc]=imhist(I_c4); %computing the histograms of b4
    %----------------------------------------------------------------------
    %computing the absolute histogram subtraction for motion detection
    f_g1=abs(nI_b1-nI_c1); %computing the histogram in the first block
    f_g2=abs(nI_b2-nI_c2); %computing the histogram in the second block
    f_g3=abs(nI_b3-nI_c3); %computing the histogram in the 3rd block
    f_g4=abs(nI_b4-nI_c4); %computing the histogram in the 4th block
    %----------------------------------------------------------------------
    %calculating the mean
%     f_g1_m=mean(f_g1);
%     f_g2_m=mean(f_g2);
%     f_g3_m=mean(f_g3);
%     f_g4_m=mean(f_g4);
%     %----------------------------------------------------------------------
%     %calculating the varience
%     f_g1_v=f_g1-(f_g1_m*ones(size(f_g1)));
%     f_g2_v=f_g2-(f_g2_m*ones(size(f_g2)));
%     f_g3_v=f_g3-(f_g3_m*ones(size(f_g3)));
%     f_g4_v=f_g4-(f_g4_m*ones(size(f_g4)));
    
    %----------------------------------------------------------------------
    %calculate the varience 
    f_g1_v=var(f_g1);
    f_g2_v=var(f_g2);
    f_g3_v=var(f_g3);
    f_g4_v=var(f_g4);
    %----------------------------------------------------------------------
    %finding the covarience between background and current image
    f_g1_cov=cov(nI_b1,nI_c1); %computing the histogram covarience in the first block
    f_g2_cov=cov(nI_b2,nI_c2); %computing the histogram covarience in the second block
    f_g3_cov=cov(nI_b3,nI_c3); %computing the histogram covariance the 3rd block
    f_g4_cov=cov(nI_b4,nI_c4); %computing the histogram covariance in the 4th block
    
    
    %----------------------------------------------------------------------
    %finding Threshold values 
    T1=sum(f_g1_v); %determining the first Threshold
    T2=sum(f_g2_v); %determining the second Threshold
    T3=sum(f_g3_v); %determining the 3rd Threshold
    T4=sum(f_g4_v); %determining the 4th Threshold
    T_t=[T1,T2,T3,T4]; % arranging every threshold
    for j=1:length (T_t)
        if T_t(j)>1000
            display('activity detected')
            count_detect=count_detect+1;
            count_detected=[count_detected,[count_detect;i]];
%--------------------------------------------------------------------------
%Apply 2D-DWT and trigger Transmission data to the sink node
[aL,hL,Lh,hh,E_dwt]=trig_1(I_set_im{j});
%--------------------------------------------------------------------------
%Transfer of image data to the sink node using anchor node router
%--------------------------------------------------------------------------
        else
            display('no activity')
            count_undetect=count_undetect+1;
            count_undetected=[count_undetected,[count_undetect;i,E_dwt]];
    
    
        end 
        
    end
    display(cat(1,['----next image',num2str(i),'----']))
    end
   
end
    
