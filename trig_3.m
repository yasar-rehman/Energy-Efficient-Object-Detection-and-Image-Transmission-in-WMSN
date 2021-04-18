%packet forwarding machenism
%packet transmission strategy
clear all
clc
% set(0,'DefaultFigureWindowStyle','docked');

%--------------------------------------------------------------------------
%generation of random topology
Sx=randi(100,1,30); %define WMSN node x locations. Generate a random 10 x location from 1 upto 100
Sy=randi(100,1,30); %define WMSN node y locations
net2=[];
net3=[];
dest=[0,0]; %destination node
d2_est=[];
flag=0;

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
 Energy_consumption=[];
 Energy_total_consume=[];
 Energy_direct=[];
 Energy_total_direct=[];
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Define WMSN node location
Ax=randi(100,1,10); %define anchor nodes x axis
Ay=randi(100,1,10); %define anchor nodes y axis
%--------------------------------------------------------------------------
%define random battery charge state
St_charge=randi(300,1,30);

%--------------------------------------------------------------------------
%candidates anchor nodes storage
Can_An=[];
%--------------------------------------------------------------------------
%formation of network path setting
A1=[]; %anchor node 1
A2=[];
A3=[];
A4=[];
A5=[];
A6=[];
A7=[];
A8=[];
A9=[];
A10=[];
%--------------------------------------------------------------------------
%form a node location matrix 

for i=1:length(Sx)
    net2=[net2,[i;Sx(:,i);Sy(:,i);St_charge(:,i)]]; %formation of network topology
    %i= sensor node number
    %Sx= sensor node x axis
    %Sy= sensor node y axis
    %St_charge= sensor node battery state
end
%formation of relying node topology
for i=1:length(Ax)
    net3=[net3,[i;Ax(:,i);Ay(:,i);St_charge(:,i)]];
end
R=50; %radio range in feets
R1=50;
%--------------------------------------------------------------------------

%formation of network based on anchor nodes
figure('Color','w','Position',[100 100 700 600]) %define figure
    set(gca,'FontSize',8,'YGrid','off') %set the properties
    xlabel('\it x \rm [ft] \rightarrow') %set the x label
    ylabel('\it y \rm [ft] \rightarrow') %set the y label
    hold on;
    plot(net3(2,:),net3(3,:),'r*','MarkerSize',6,'MarkerFaceColor','k'); %plot initial nodes
    plot(net2(2,:),net2(3,:),'ko','MarkerSize',4,'MarkerFaceColor','b');
    legend('RN Nodes','MN Nodes')
    hold on;
    for j=1:numel(net3(1,:))
        for jTemp=1:numel(net3(1,:))
%         for jTemp=1:numel(net3(1,:))
         X1=net3(2,j); %assume the reference node x axis
         Y1=net3(3,j); %assume the reference nody y axis
         X2=net3(2,jTemp); %assume the other node
         Y2=net3(3,jTemp); %assume the other node
         xSide=abs(X2-X1); %x coordinate calcualtion
         ySide=abs(Y2-Y1); %y coordinate calculation
         d=sqrt(xSide^2+ySide^2); %distance estimate
         if (d<R1)&&(j~=jTemp)%distance threshold
             vertice1=[X1,X2]; 
             vertice2=[Y1,Y2];       
             plot(vertice1,vertice2,'-.b','LineWidth',0.1);
             hold on;
         end
         end
    end
         
   
    
v=net2(1,:);
    vv=v';
    s=int2str(vv);
    text(net2(2,:)+1,net2(3,:)+2,s,'FontSize',8,'VerticalAlignment','Baseline');
%--------------------------------------------------------------------------
v=net3(1,:);
    vv=v';
    s=int2str(vv);
    text(net3(2,:)+1,net3(3,:)+2,s,'FontSize',12,'VerticalAlignment','Baseline');

%--------------------------------------------------------------------------
figure('Color','w','Position',[100 100 700 600]) %define figure
    set(gca,'FontSize',8,'YGrid','off') %set the properties
    xlabel('\it x \rm [ft] \rightarrow') %set the x label
    ylabel('\it y \rm [ft] \rightarrow') %set the y label
    hold on;
    plot(net3(2,:),net3(3,:),'r*','MarkerSize',6,'MarkerFaceColor','k'); %plot initial nodes
    plot(net2(2,:),net2(3,:),'ko','MarkerSize',4,'MarkerFaceColor','b');
    legend('RN Nodes','MN nodes')
    hold on;
    for j=1:numel(net3(1,:))
%         for jTemp=1:numel(net3(1,:))
         X1=net3(2,j); %assume the reference node x axis
         Y1=net3(3,j); %assume the reference nody y axis
         for  j1=1:numel(net2(1,:))
         X2=net2(2,j1); %assume the other node
         Y2=net2(3,j1); %assume the other node
         xSide=abs(X2-X1); %x coordinate calcualtion
         ySide=abs(Y2-Y1); %y coordinate calculation
         d=sqrt(xSide^2+ySide^2); %distance estimate
         if (d<R)&&(j~=j1)&&net2(4,j1)>50 %distance threshold and energy threshold
             vertice1=[X1,X2]; 
             vertice2=[Y1,Y2];
             if j==1
                 A1=[A1,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==2
                  A2=[A2,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==3
                  A3=[A3,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==4
                  A4=[A4,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==5
                  A5=[A5,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==6
                  A6=[A6,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==7
                  A7=[A7,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==8
                  A8=[A8,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==9
                  A9=[A9,[j1;X2;Y2;net2(4,j1);d]];
             elseif j==10
                  A10=[A10,[j1;X2;Y2;net2(4,j1);d]];
             end
                 
            
             plot(vertice1,vertice2,'--m','LineWidth',0.1);
             hold on;
         end
         end
    end
         
   
    
v=net2(1,:);
    vv=v';
    s=int2str(vv);
    text(net2(2,:)+1,net2(3,:)+2,s,'FontSize',8,'VerticalAlignment','Baseline');
%--------------------------------------------------------------------------
v=net3(1,:);
    vv=v';
    s=int2str(vv);
    text(net3(2,:)+1,net3(3,:)+2,s,'FontSize',12,'VerticalAlignment','Baseline');
%--------------------------------------------------------------------------
%every sensor node will monitor an environment
%define a random threshold for each sensor node
% thres_hold=randi(10,1,30);
thres_hold=6*ones(1,1);
 for z=1:7
for i=1:numel(net2(1,:))
    flag=0;
    if thres_hold(i)>5 %transmit image frame detection
        target_n=net2(:,i);
        %find an anchor node that have the following target_n node
        %coordinates
        for jj=1:numel(A1(1,:))
        if A1(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A1(:,jj);1]];
            EE=length(A1)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
             EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
            
        end
        end
 %-------------------------------------------------------------------------
         for jj=1:numel(A2(1,:))
        if A2(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A2(:,jj);2]];
            EE=length(A2)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
            
        end
         end
 %-------------------------------------------------------------------------
          for jj=1:numel(A3(1,:))
        if A3(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A3(:,jj);3]];
           EE=length(A3)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
          end
 %-------------------------------------------------------------------------
           for jj=1:numel(A4(1,:))
        if A4(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A4(:,jj);4]];
            EE=length(A4)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
           end
  %------------------------------------------------------------------------
            for jj=1:numel(A5(1,:))
        if A5(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A5(:,jj);5]];
            EE=length(A5)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
            end
 %-------------------------------------------------------------------------
             for jj=1:numel(A6(1,:))
        if A6(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A6(:,jj);6]];
           EE=length(A6)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE] ;
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
             end
%--------------------------------------------------------------------------
              for jj=1:numel(A7(1,:))
        if A7(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A7(:,jj);7]];
            EE=length(A7)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
              end
 %-------------------------------------------------------------------------
               for jj=1:numel(A8(1,:))
        if A8(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A8(:,jj);8]];
            EE=length(A8)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
               end
 %-------------------------------------------------------------------------
                for jj=1:numel(A9(1,:))
        if A9(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A9(:,jj);9]];
            EE=length(A9)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
        end
                end
 %-------------------------------------------------------------------------
                 for jj=1:numel(A10(1,:))
        if A10(1:end-1,jj)==target_n(:,1)
            Can_An=[Can_An,[A10(:,jj);10]];
           EE=length(A10)*(I_mote_a_ton*VB*Ttx)*(120*160);
            Energy_consumption=[Energy_consumption,EE];
            EE1=length(A1)*(I_mote_a_ton*VB*Ttx)*(240*320);
             Energy_direct=[Energy_direct,EE1];
            
        end
                 end
  %------------------------------------------------------------------------
  %selection of target Anchor node based on minimum distance
  if ~isempty(Can_An)
      [target_ad,ind_loc]=min(Can_An(end-1,:));
      target_An_loc=Can_An(end,ind_loc);
      Can_An=[];
      
      if ind_loc==1
              target_An=A1;
      elseif target_An_loc==2
              target_An=A2;
      elseif target_An_loc==3
              target_An=A3;
      elseif target_An_loc==4
              target_An=A4;
      elseif target_An_loc==5
              target_An=A5;
      elseif target_An_loc==6
              target_An=A6;
      elseif target_An_loc==7
              target_An=A7;
      elseif target_An_loc==8
              target_An=A8;
      elseif target_An_loc==9
              target_An=A9;
      elseif target_An_loc==10
              target_An=A10;
      end
  end
 %-------------------------------------------------------------------------
%       figure('Color','w','Position',[100 100 700 600]) %define figure
%     set(gca,'FontSize',8,'YGrid','off') %set the properties
%     xlabel('\it x \rm [ft] \rightarrow') %set the x label
%     ylabel('\it y \rm [ft] \rightarrow') %set the y label
%     hold on
%      plot(net3(2,:),net3(3,:),'r*','MarkerSize',6,'MarkerFaceColor','k'); %plot initial nodes
%      
%     plot(net2(2,:),net2(3,:),'ko','MarkerSize',4,'MarkerFaceColor','b'); 
%     legend('RN Node','MN Node')
%     
% v=net2(1,:);
%     vv=v';
%     s=int2str(vv);
%     text(net2(2,:)+1,net2(3,:)+2,s,'FontSize',8,'VerticalAlignment','Baseline')
% %--------------------------------------------------------------------------
% v=net3(1,:);
%     vv=v';
%     s=int2str(vv);
%     text(net3(2,:)+1,net3(3,:)+2,s,'FontSize',12,'VerticalAlignment','Baseline')
%    
%     
%     %-------------------------------------------------------------------------
%       for jj_2=1:numel(target_An(1,:))
%           if net2(:,end)==target_An(1:end-1,jj_2)
%               flag=1;
%               %print the path through intermediate node of target_An 
%                plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%                plot([net3(2,ind_loc),target_An(2,ind_loc+1:end)],[net3(3,ind_loc),target_An(3,ind_loc+1:end)],'--r*','MarkerSize',6,'MarkerFaceColor','r')
% %                plot(vertice1,vertice2,'-.b','LineWidth',0.1);
%           end
%       end
%       if flag==1
%           flag=1
%           
%       else
%           flag=0
%    %-----------------------------------------------------------------------
%           %target handover
%           for jj_2=1:numel(target_An(1,:))
%               
%           if  numel(A1(1,:))>=jj_2 & net2(:,end)==A1(1:end-1,jj_2)& flag==0
%               %print the path through intermediate node of target_An 
%               plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,ind_loc),net3(2,1)],[net3(3,ind_loc),net3(3,1)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,1),A1(2,:)],[net3(3,1),A1(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r')
%               
%                flag=1;
%    %-----------------------------------------------------------------------
%          elseif  numel(A2(1,:))>=jj_2 & net2(:,end)==A2(1:end-1,jj_2)&flag==0
%               %print the path through intermediate node of target_An 
%             plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%             plot([net3(2,ind_loc),net3(2,2)],[net3(3,ind_loc),net3(3,2)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,2),A2(2,:)],[net3(3,2),A2(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A3(1,:))>=jj_2 & net2(:,end)==A3(1:end-1,jj_2)& flag==0
%               %print the path through intermediate node of target_An 
%               plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,ind_loc),net3(2,3)],[net3(3,ind_loc),net3(3,3)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,3),A3(2,:)],[net3(3,3),A3(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A4(1,:))>=jj_2 & net2(:,end)==A4(1:end-1,jj_2)&flag==0
%               %print the path through intermediate node of target_An 
%              plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%              plot([net3(2,ind_loc),net3(2,4)],[net3(3,ind_loc),net3(3,4)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,4),A4(2,:)],[net3(3,4),A4(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r')
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A5(1,:))>=jj_2 & net2(:,end)==A5(1:end-1,jj_2)& flag==0
%               %print the path through intermediate node of target_An
%               plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,ind_loc),net3(2,5)],[net3(3,ind_loc),net3(3,5)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,5),A5(2,:)],[net3(3,5),A5(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A6(1,:))>=jj_2 & net2(:,end)==A6(1:end-1,jj_2)& flag==0
%               %print the path through intermediate node of target_An
%               plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,ind_loc),net3(2,6)],[net3(3,ind_loc),net3(3,6)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,6),A6(2,:)],[net3(3,6),A6(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A7(1,:))>=jj_2 & net2(:,end)==A7(1:end-1,jj_2)& flag==0
%               %print the path through intermediate node of target_An 
%             plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%             plot([net3(2,ind_loc),net3(2,7)],[net3(3,ind_loc),net3(3,7)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,7),A7(2,:)],[net3(3,7),A7(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A8(1,:))>=jj_2 & net2(:,end)==A8(1:end-1,jj_2)&flag==0
%               %print the path through intermediate node of target_An
%          plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%          plot([net3(2,ind_loc),net3(2,8)],[net3(3,ind_loc),net3(3,8)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,8),A8(2,:)],[net3(3,8),A8(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r')
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A9(1,:))>=jj_2 & net2(:,end)==A9(1:end-1,jj_2)&flag==0
%               %print the path through intermediate node of target_An 
%                plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%                plot([net3(2,ind_loc),net3(2,9)],[net3(3,9),net3(3,1)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,9),A9(2,:)],[net3(3,9),A9(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%    %-----------------------------------------------------------------------
%     elseif  numel(A10(1,:))>=jj_2 & net2(:,end)==A10(1:end-1,jj_2)&flag==0
%               %print the path through intermediate node of target_An 
%                plot([target_n(2),net3(2,ind_loc)],[target_n(3),net3(3,ind_loc)],'-bs','MarkerSize',6,'MarkerFaceColor','b'),hold on
%                plot([net3(2,ind_loc),net3(2,10)],[net3(3,ind_loc),net3(3,10)],'-bo','MarkerSize',6,'MarkerFaceColor','b'),hold on
%               plot([net3(2,10),A10(2,:)],[net3(3,10),A10(3,:)],'--r*','MarkerSize',6,'MarkerFaceColor','r') 
%               flag=1;
%           else
%               flag=0;
%           end
%           end
%       end
%     end
    end
    Energy_total_consume=[Energy_total_consume,sum(Energy_consumption)]
    Energy_total_direct=[Energy_total_direct,sum(Energy_direct)];
end
 end
              
%     plot(net3(2,:),net3(3,:),'r*','MarkerSize',6,'MarkerFaceColor','k'); %plot initial nodes
%     plot(net2(2,:),net2(3,:),'ko','MarkerSize',4,'MarkerFaceColor','b');    

  
      
  %------------------------------------------------------------------------
