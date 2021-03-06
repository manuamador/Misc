%pyramides
clear all
close all

h=0.035;
H=.45
L=.60
W=.60
N=4
M=4
dN=L/(8*N)
dM=W/(8*M)
P=h*ones(N*8+1,M*8+1);

P(2:8:N*8+1,:)=H/4;
P(:,2:8:M*8+1,:)=H/4;

P(8:8:N*8+1,:)=H/4;
P(:,8:8:M*8+1,:)=H/4;

P(1:8:N*8+1,:)=h;
P(:,1:8:M*8+1,:)=h;

P(1:8:N*8+1,:)=h;
P(:,1:8:M*8+1,:)=h;



P(3:8:N*8+1,3:8:M*8)=H/2;
P(4:8:N*8+1,3:8:M*8)=H/2;
P(5:8:N*8+1,3:8:M*8)=H/2;
P(6:8:N*8+1,3:8:M*8)=H/2;
P(7:8:N*8+1,3:8:M*8)=H/2;

P(3:8:N*8+1,4:8:M*8)=H/2;
P(4:8:N*8+1,4:8:M*8)=H/2;
P(5:8:N*8+1,4:8:M*8)=H/2;
P(6:8:N*8+1,4:8:M*8)=H/2;
P(7:8:N*8+1,4:8:M*8)=H/2;

P(3:8:N*8+1,5:8:M*8)=H/2;
P(4:8:N*8+1,5:8:M*8)=H/2;
P(5:8:N*8+1,5:8:M*8)=H/2;
P(6:8:N*8+1,5:8:M*8)=H/2;
P(7:8:N*8+1,5:8:M*8)=H/2;

P(3:8:N*8+1,6:8:M*8)=H/2;
P(4:8:N*8+1,6:8:M*8)=H/2;
P(5:8:N*8+1,6:8:M*8)=H/2;
P(6:8:N*8+1,6:8:M*8)=H/2;
P(7:8:N*8+1,6:8:M*8)=H/2;

P(3:8:N*8+1,7:8:M*8)=H/2;
P(4:8:N*8+1,7:8:M*8)=H/2;
P(5:8:N*8+1,7:8:M*8)=H/2;
P(6:8:N*8+1,7:8:M*8)=H/2;
P(7:8:N*8+1,7:8:M*8)=H/2;




P(4:8:N*8+1,4:8:M*8)=3*H/4;
P(5:8:N*8+1,4:8:M*8)=3*H/4;
P(6:8:N*8+1,4:8:M*8)=3*H/4;

P(4:8:N*8+1,5:8:M*8)=3*H/4;
P(5:8:N*8+1,5:8:M*8)=3*H/4;
P(6:8:N*8+1,5:8:M*8)=3*H/4;

P(4:8:N*8+1,6:8:M*8)=3*H/4;
P(5:8:N*8+1,6:8:M*8)=3*H/4;
P(6:8:N*8+1,6:8:M*8)=3*H/4;

% [HN,HM]=meshgrid(2:8:8*N+1,2:8:8*M+1);
% P(HN,HM)=H/4;
% [HN,HM]=meshgrid(8:8:8*N+1,8:8:8*M+1);
% P(HN,HM)=H/4;
% [HN,HM]=meshgrid(8:8:8*N+1,2:8:8*M+1);
% P(HN,HM)=H/4;
% [HN,HM]=meshgrid(2:8:8*N+1,8:8:8*M+1);
% P(HN,HM)=H/4;

% [HN,HM]=meshgrid(3:8:8*N+1,2:8:8*M+1);
% P(HN,HM)=H/4;
% [HN,HM]=meshgrid(2:8:8*N+1,3:8:8*M+1);
% P(HN,HM)=H/4;
% [HN,HM]=meshgrid(4:8:8*N+1,3:8:8*M+1);
% P(HN,HM)=H/4;
% [HN,HM]=meshgrid(3:8:8*N+1,4:8:8*M+1);
% P(HN,HM)=H/4;

% for i=2:4:4*N+1
%     for j=2:4:4*M+1
%         P(i,j)=H/2;
%     end
% end
% 
% for i=6:4:4*N+1
%     for j=6:4:4*M+1
%         P(i,j)=H/2;
%     end
% end
% 
% 
% for i=2:4:4*N+1
%     for j=6:4:4*M+1
%         P(i,j)=H/2;
%     end
% end
% 
% for i=6:4:4*N+1
%     for j=2:4:4*M+1
%         P(i,j)=H/2;
%     end
% end

%P(HN,HM)=H/2;



for i=5:8:8*N+1
    for j=5:8:8*M+1
        P(i,j)=H;
    end
end


x=1:8*N+1
y=1:8*M+1

 [XI,YI]=meshgrid(1:.5:8*N+1,1:.5:8*M+1);
% 
 [X,Y]=meshgrid(x,y);
% 
 PI = interp2(X,Y,P,XI,YI,'cubic');

P(4*N+1,4*M+1)=0;
fig=figure(1)
axes1 = axes('Visible','off','Parent',fig,...
    'DataAspectRatio',[1 1 1],...
    'CameraViewAngle',2.64522913471741);

surf(-L/2:dN/2:L/2,-W/2:dM/2:W/2,PI,'Parent',axes1,'Tag','meshz',...
    'EdgeLighting','flat',...
    'FaceLighting','none',...
    'FaceColor',[1 1 1]);

axis equal
axis vis3d
axis off

    xlim([-.8,.8])
    ylim([-.8,.8])
    zlim([0,.8])
A=[];
i=0;
%for theta=90:-5:-90;
    %    for phi=0:5:359
            view(phi,theta)
           %annotation(.3,.3,['theta=',num2str(theta),'°, phi=',num2str(phi),'°'])
            getframe;
         %   filename=sprintf('py-%d.png',i);
          %  saveas(fig,filename,'png')
            %importfile(filename)
           % A=[A;theta phi sum(sum(cdata))/3];
           % delete(filename)
            %       close all
            i=i+1;
    %    end
        
    %end
%     save('airepyramide.mat','A')