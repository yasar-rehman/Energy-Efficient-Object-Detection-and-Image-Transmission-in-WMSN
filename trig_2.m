%packet transmission strategy
%--------------------------------------------------------------------------
%generation of random topology
Sx=randi(100,1,30); %define WMSN node x locations. Generate a random 10 x location from 1 upto 100
Sy=randi(100,1,30); %define WMSN node y locations
net2=[];
net3=[];
dest=[0,0]; %destination node
d2_est=[];
%--------------------------------------------------------------------------
%Define WMSN node location
Ax=randi(100,1,10); %define anchor nodes x axis
Ay=randi(100,1,10); %define anchor nodes y axis
%--------------------------------------------------------------------------
%define random battery charge state
St_charge=randi(300,1,30);
%--------------------------------------------------------------------------
%form a node location matrix 

for i=1:length(Sx)
    net2=[net2,[i;Sx(:,i);Sy(:,i);St_charge(:,i)]]; %formation of network topology
    
end
for i=1:length(Ax)
    net3=[net3,[i;Ax(:,i);Ay(:,i);St_charge(:,i)]];
end
R=50; %radio range in feets
R1=50;
%--------------------------------------------------------------------------
%print the network based on radio range

figure('Color','w','Position',[100 100 700 600]) %define figure
    set(gca,'FontSize',8,'YGrid','off') %set the properties
    xlabel('\it x \rm [ft] \rightarrow') %set the x label
    ylabel('\it y \rm [ft] \rightarrow') %set the y label
    hold on;
    plot(net2(2,:),net2(3,:),'ko','MarkerSize',5,'MarkerFaceColor','k'); %plot initial nodes
    
    hold on;
    for j=1:numel(net2(1,:))
        for jTemp=1:numel(net2(1,:))
         X1=net2(2,j); %assume the reference node x axis
         Y1=net2(3,j); %assume the reference nody y axis
         X2=net2(2,jTemp); %assume the other node
         Y2=net2(3,jTemp); %assume the other node
         xSide=abs(X2-X1); %x coordinate calcualtion
         ySide=abs(Y2-Y1); %y coordinate calculation
         d=sqrt(xSide^2+ySide^2); %distance estimate
         if (d<R)&&(j~=jTemp) %distance threshold
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
%print the network based on battery charge state
figure('Color','w','Position',[100 100 700 600]) %define figure
    set(gca,'FontSize',8,'YGrid','off') %set the properties
    xlabel('\it x \rm [ft] \rightarrow') %set the x label
    ylabel('\it y \rm [ft] \rightarrow') %set the y label
    hold on;
    plot(net2(2,:),net2(3,:),'go','MarkerSize',5,'MarkerFaceColor','k'); %plot initial nodes
    hold on;
    for j=1:numel(net2(1,:))
        for jTemp=1:numel(net2(1,:))
         X1=net2(2,j); %assume the reference node x axis
         Y1=net2(3,j); %assume the reference nody y axis
         X2=net2(2,jTemp); %assume the other node
         Y2=net2(3,jTemp); %assume the other node
         xSide=abs(X2-X1); %x coordinate calcualtion
         ySide=abs(Y2-Y1); %y coordinate calculation
         d=sqrt(xSide^2+ySide^2); %distance estimate
         if (d<R)&&(j~=jTemp)&&net2(4,j)>100 %distance threshold
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
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------

%formation of network based on anchor nodes
figure('Color','w','Position',[100 100 700 600]) %define figure
    set(gca,'FontSize',8,'YGrid','off') %set the properties
    xlabel('\it x \rm [ft] \rightarrow') %set the x label
    ylabel('\it y \rm [ft] \rightarrow') %set the y label
    hold on;
    plot(net3(2,:),net3(3,:),'r*','MarkerSize',6,'MarkerFaceColor','k'); %plot initial nodes
    plot(net2(2,:),net2(3,:),'ko','MarkerSize',4,'MarkerFaceColor','b');
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
         if (d<R1)&&(j~=j1)&&net2(4,j1)>150 %distance threshold
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
%every sensor node will monitor an environment
