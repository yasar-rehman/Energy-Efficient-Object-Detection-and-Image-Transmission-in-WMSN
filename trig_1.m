%function trig_1 computes the 2D-DWT of an image and transmit it to the
%sink node
%the input to the function is the image 


function [aL,hL,Lh,hh,E_dwt]=trig_1(frame_i)
[LL1,HL1,LH1,HH1]=dwt2(frame_i,'db2');
aL=LL1;
hL=HL1;
Lh=LH1;
hh=HH1;
[r,c]=size(frame_i);
%--------------------------------------------------------------------------
%computing the energy 
E_dwt=r*c*(10+12+2+2);



end
