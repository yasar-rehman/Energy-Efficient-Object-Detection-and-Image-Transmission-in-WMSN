%image reception at the sink node

%---------------SCENARIO 1--------------------------%
%IMAGE HISTOGRAM IS BELOW THRESHOLD

clear all
clc
 set(0,'DefaultFigureWindowStyle','docked');
% set(0,'InitialMagnification','fit');
% 

path(path,'\scenario4\video data set\pedestrians\input');
%--------------------------------------------------------------------------
count_detect=0;
count_undetect=0;
count_detected=[];
count_undetected=[];
al_pha=0.5;
q=8;
MSE=[];
PSR=[];
T_energy=[];
T_energy_a=[];
Ene_1=0;
Ene_1a=0;
tr_detection=0;
fa_detection=0;
st='InitialMagnification';
pr='Fit';
rec1=imread('in000001.jpg');
rec1=rgb2gray(rec1);
%--------------------------------------------------------------------------
%Energy Consumption calculation
 %camera used = OV7670
 I_cam_a = 18E-3; %when camera is active
 I_cam_s = 20E-6; %when camera is in standby 
 clk_c=24E-9; 
 %Mote = Imote
 %Current Drawn in active mode =31 mA when Tx, Rx off
 I_mote_a_tof=31E-3;
 %Current Drawn in active mode =44 mA when Tx, Rx on
 I_mote_a_ton=44E-3;
 I_mote_rf=13E-3;
 %time to transmit a single bit
 Ttx=0.4E-6;
  
 %Battery voltage 3.2 - 4.5 Volts
 VB=4.5;
%--------------------------------------------------------------------------


 a='0';b='0';c='0';d='0';e='0';f='0';
%--------------------------------------------------------------------------
%Background update algorithm 
for i=250:1:450
    figure(1);
imshow(rec1,st,pr)
xlabel(cat(1,['Received Image at Frame',num2str(i)]))

    if i<10
    I_b=imread(cat(1,['in',a,b,c,d,e,num2str(i),'.jpg']));
    elseif i>=10&i<100
         I_b=imread(cat(1,['in',a,b,c,d,num2str(i),'.jpg']));
    elseif i>=100&i<999
        I_b=imread(cat(1,['in',a,b,c,num2str(i),'.jpg']));
    elseif i>=1000&i<=1999
         I_b=imread(cat(1,['in',a,b,num2str(i),'.jpg']));
    elseif i>=2000&i<2500
         I_b=imread(cat(1,['in',a,b,num2str(i),'.jpg']));
    end
    %----------------------------------------------------------------------
   I_b=rgb2gray(I_b);
%    I_b=medfilt2(I_b,[3,3]);
   
  

    if i-250==0
     I_back=I_b; % background image
%      I_back=I_back/mean2(I_back);
    [row_n,col_n]=size(I_b);
    I_b1=I_back(1:row_n/2,1:col_n/2); %getting first 32 x 32 pixel image
%     I_b1=I_b1/mean2(I_b1);
    I_b2=I_back(1:row_n/2,(col_n/2)+1:col_n); %getting the second 32 x 32 image
%     I_b2=I_b2/mean2(I_b2);
    I_b3=I_back(row_n/2+1:row_n,1:col_n/2); %getting the third 32 x 32 image
%     I_b3=I_b3/mean2(I_b3);
    I_b4=I_back(row_n/2+1:row_n,col_n/2+1:col_n);
%     I_b4=I_b4/mean2(I_b4);
    
    %----------------------------------------------------------------------
    
  
    else
    %----------------------------------------------------------------------
    %computing the histogram
%     I_b11=reshape(I_b1,size(I_b1,1)*size(I_b1,2),1);
%     I_b12=reshape(I_b2,size(I_b2,1)*size(I_b2,2),1);
%     I_b13=reshape(I_b3,size(I_b3,1)*size(I_b3,2),1);
%     I_b14=reshape(I_b4,size(I_b4,1)*size(I_b4,2),1);
% %     I_gass1=(1/sqrt(2*pi*var(double(I_b11))))*exp(-(double(I_b11)-mean(double(I_b11)).^2/var(double(I_b11))));
 I_set_imb={I_b1,I_b2,I_b3,I_b4};
    %----------------------------------------------------------------------
    
    [nI_b1,I_b1loc]=imhist(I_b1); %computing the histograms of b1
    [nI_b2,I_b2loc]=imhist(I_b2); %computing the histograms of b2
    [nI_b3,I_b3loc]=imhist(I_b3); %computing the histograms of b3
    [nI_b4,I_b4loc]=imhist(I_b4); %computing the histograms of b4
           
    %----------------------------------------------------------------------
   %division of the given image into four regions
    I_c=I_b; % current image
    
%     I_c=I_c/mean2(I_c);
    [row_n,col_n]=size(I_c);
    figure(3)
    subplot(2,2,1)
    I_c1=I_c(1:row_n/2,1:col_n/2); %getting first 32 x 32 pixel image
%     I_c1=I_c1/mean2(I_c1);
    imshow(I_c1,[],st,pr)
    xlabel('Block 1')
    I_c2=I_c(1:row_n/2,(col_n/2)+1:col_n); %getting the second 32 x 32 image
%     I_c2=I_c2/mean2(I_c2);
    subplot(2,2,2)
    imshow(I_c2,[],st,pr)
    xlabel('Block 2')
    
    I_c3=I_c(row_n/2+1:row_n,1:col_n/2); %getting the third 32 x 32 image
%     I_c3=I_c3/mean2(I_c3);
    subplot(2,2,3)
    imshow(I_c3,[],st,pr)
    xlabel('Block 3')
    
    I_c4=I_c(row_n/2+1:row_n,col_n/2+1:col_n);
%     I_c4=I_c4/mean2(I_c4);
    subplot(2,2,4)
    imshow(I_c4,[],st,pr)
    xlabel('Block 4')
    I_set_im={I_c1,I_c2,I_c3,I_c4}; %image set
    %----------------------------------------------------------------------
    %Background updatation
    I_b1=al_pha*I_b1+(1-al_pha)*I_c1;
    I_b2=al_pha*I_b2+(1-al_pha)*I_c2;
    I_b3=al_pha*I_b3+(1-al_pha)*I_c3;
    I_b4=al_pha*I_b4+(1-al_pha)*I_c4;
%     I_back=I_back/mean2(I_back);
     figure(2); imshow(I_b,[],st,pr)
   xlabel(cat(1,['Frame',num2str(i)]))
%     figure(3), imshow(I_back,st,pr)
%     xlabel('Current Image')
    %----------------------------------------------------------------------
    %finding the absolute histogram
    [nI_c1,I_c1loc]=imhist(I_c1); %computing the histograms of c1
    [nI_c2,I_c2loc]=imhist(I_c2); %computing the histograms of c2
    [nI_c3,I_c3loc]=imhist(I_c3); %computing the histograms of c3
    [nI_c4,I_c4loc]=imhist(I_c4); %computing the histograms of c4
    %----------------------------------------------------------------------
    %computing the absolute histogram subtraction for motion detection
%     f_g1=abs(nI_b1-nI_c1); %computing the histogram in the first block
%     f_g2=abs(nI_b2-nI_c2); %computing the histogram in the second block
%     f_g3=abs(nI_b3-nI_c3); %computing the histogram in the 3rd block
%     f_g4=abs(nI_b4-nI_c4); %computing the histogram in the 4th block
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
    %----------------------------------------------------------------------
    %calculate the variance for the whole current image
%     f_b1=var(var(double(I_b1),0,1));
%     f_b2=var(var(double(I_b2),0,1));
%     f_b3=var(var(double(I_b3),0,1));
%     f_b4=var(var(double(I_b4),0,1));
%     %----------------------------------------------------------------------
%     
%     f_c1=var(var(double(I_c1),0,1));
%     f_c2=var(var(double(I_c2),0,1));
%     f_c3=var(var(double(I_c3),0,1));
%     f_c4=var(var(double(I_c4),0,1));
%     %----------------------------------------------------------------------
%     f_g1_v=var(f_g1);
%     f_g2_v=var(f_g2);
%     f_g3_v=var(f_g3);
%     f_g4_v=var(f_g4);
    %----------------------------------------------------------------------
    %calculating gaussian probabilities
    f_gass1_c=(1/sqrt(2*pi*var(nI_c1)))*exp(-(nI_c1-mean(nI_c1)).^2/var(nI_c1));
    f_gass1_b=(1/sqrt(2*pi*var(nI_b1)))*exp(-(nI_b1-mean(nI_b1)).^2/var(nI_b1));
    f_gass2_c=(1/sqrt(2*pi*var(nI_c2)))*exp(-(nI_c2-mean(nI_c2)).^2/var(nI_c2));
    f_gass2_b=(1/sqrt(2*pi*var(nI_b2)))*exp(-(nI_b2-mean(nI_b2)).^2/var(nI_b2));
    f_gass3_c=(1/sqrt(2*pi*var(nI_c3)))*exp(-(nI_c3-mean(nI_c3)).^2/var(nI_c3));
    f_gass3_b=(1/sqrt(2*pi*var(nI_b3)))*exp(-(nI_b3-mean(nI_b3)).^2/var(nI_b3));
    f_gass4_c=(1/sqrt(2*pi*var(nI_c4)))*exp(-(nI_c4-mean(nI_c4)).^2/var(nI_c4));
    f_gass4_b=(1/sqrt(2*pi*var(nI_b4)))*exp(-(nI_b4-mean(nI_b4)).^2/var(nI_b4));
    %----------------------------------------------------------------------
    %finding the covarience between background and current image
    f_g1_cov=abs(f_gass1_c-f_gass1_b); %computing the histogram covarience in the first block
    f_g2_cov=abs(f_gass2_c-f_gass2_b); %computing the histogram covarience in the second block
    f_g3_cov=abs(f_gass3_c-f_gass3_b); %computing the histogram covariance the 3rd block
    f_g4_cov=abs(f_gass4_c-f_gass4_b); %computing the histogram covariance in the 4th block
    
    
    %----------------------------------------------------------------------
    %finding Threshold values 
    T1=abs(sum(f_g1_cov(:))); %determining the first Threshold
    T2=abs(sum(f_g2_cov(:))); %determining the second Threshold
    T3=abs(sum(f_g3_cov(:))); %determining the 3rd Threshold
    T4=abs(sum(f_g4_cov(:))); %determining the 4th Threshold
    T_t=[T1,T2,T3,T4] % arranging every threshold
    for j=1:length (T_t)
       I_foreground=(I_set_im{j}-I_set_imb{j});
       I_foreground=medfilt2(I_foreground,[3,3]);
       
        if T_t(j)>0.02&&sum(I_foreground(:))>=6000
           
           
            
            display('activity detected')
            count_detect=count_detect+1;
            count_detected=[count_detected,[count_detect;i]];
             figure(4)
%              subplot(2,2,1)
             imshow(I_foreground,[],st,pr)
%              subplot(2,2,2)
%              imshow(I_foreground(1:row_n/2,(col_n/2)+1:col_n),[],st,pr)
%              subplot(2,2,3)
%              imshow(I_foreground(row_n/2+1:row_n,1:col_n/2),[],st,pr)
%              subplot(2,2,4)
%              imshow(I_foreground(row_n/2+1:row_n,col_n/2+1:col_n),[],st,pr)
             
    
%--------------------------------------------------------------------------
%Apply 2D-DWT and trigger Transmission data to the sink node
[aL,hL,Lh,hh,E_dwt]=trig_1(I_set_im{j});
%--------------------------------------------------------------------------
%Transfer of image data to the sink node using anchor node router
%image reception at the sink node
           
% if j==1
% 
%  rec1(1:row_n/2,1:col_n/2)=I_c1; %getting first 32 x 32 pixel image; %getting first 32 x 32 pixel image
% elseif j==2
%     fa_detection=fa_detection+1;
%  rec1(1:row_n/2,(col_n/2)+1:col_n)= I_c2; %getting the second 32 x 32 image; %getting the second 32 x 32 image
%  tr_detection=tr_detection+1;
% elseif j==3
%  rec1(row_n/2+1:row_n,1:col_n/2)=I_c3; %getting the third 32 x 32 image; %getting the third 32 x 32 image
%  tr_detection=tr_detection+1;
% elseif j==4
%  rec1(row_n/2+1:row_n,col_n/2+1:col_n)=I_c4;
%  fa_detection=fa_detection+1;
% end
%%
if j==1

 rec1(1:row_n/2,1:col_n/2)=I_c1+(5*randn(1,1)); %getting first 32 x 32 pixel image; %getting first 32 x 32 pixel image
elseif j==2
    fa_detection=fa_detection+1;
 rec1(1:row_n/2,(col_n/2)+1:col_n)= I_c2+(2*randn(1,1)); %getting the second 32 x 32 image; %getting the second 32 x 32 image
 tr_detection=tr_detection+1;
elseif j==3
 rec1(row_n/2+1:row_n,1:col_n/2)=I_c3+(2*randn(1,1)); %getting the third 32 x 32 image; %getting the third 32 x 32 image
 tr_detection=tr_detection+1;
elseif j==4
 rec1(row_n/2+1:row_n,col_n/2+1:col_n)=I_c4+(2*randn(1,1));
 fa_detection=fa_detection+1;
end
%%
            

 %-------------------------------------------------------------------------
 Ene_2a=((VB*I_cam_a*clk_c)+(I_mote_a_ton*VB*Ttx))*(size(I_c1,1)*size(I_c1,2));
    Ene_ta=Ene_2a+Ene_1a;
    T_energy_a=[T_energy_a,Ene_ta];
    Ene_1a=Ene_ta;
    
%--------------------------------------------------------------------------
        else
            display('no activity')
            count_undetect=count_undetect+1;
            count_undetected=[count_undetected,[count_undetect;i]];
%     Ene_2a=((VB*I_cam_a*clk_c)+(I_mote_a_tof*VB))*(size(I_c1,1)*size(I_c1,2));
%     Ene_ta=Ene_2a+Ene_1a;
%     T_energy_a=[T_energy_a,Ene_ta];
%     Ene_1a=Ene_ta;
    
        end
        
    end
    
    display(cat(1,['----next image',num2str(i),'----']))
    end
     %computing the mean square error
    MMSE=sum(sum((I_b-rec1).^2));
    MMSE=MMSE/(size(I_b,1)*size(I_b,2));
     PSNR= 10*log10((((2^q)-1).^2)/(MMSE));
% PSNR=10*log10(((2^q)-1)/(MMSE.^0.5));
    MSE=[MSE,MMSE];
    PSR=[PSR,PSNR];
 %-------------------------------------------------------------------------
 %Energy Consumption calculation
 %camera used = OV7670
 %current in active mode = 10-18mA
 %stand by current =20uA
 %Mote = Imote
 %Current Drawn in active mode =31 mA when Tx, Rx off
 %Current Drawn in active mode =44 mA when Tx, Rx on 
 %Battery voltage 3.2 - 4.5 Volts
 
 %-------------------------------------------------------------------------
 %Transmission using direct appraoch
    Ene_2=((VB*I_cam_a*clk_c)+(I_mote_a_ton*VB*Ttx))*(size(I_b,1)*size(I_b,2));
    Ene_t=Ene_2+Ene_1;
    T_energy=[T_energy,Ene_t];
    Ene_1=Ene_t;
end
%--------------------------------------------------------------------------
