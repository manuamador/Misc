
tic
Lt=2e-6 %temps de la fen???tre temporelle


X=[1];
Y=[2];
Z=[1];
amplitude=[1];
Phaseelement=[0];
tilt=[pi/2-acos(sqrt(2/3))];
azimut=[pi/4];

POS=[];
POSP=[];
POSI=[];
%dimensions de la cavit�
l=4.5;
p=4.5;
h=4.5;

%calcul de l'ordre correspondant
c=3e8;
dmax=Lt*c %distance maximale des sources
ordre=round(dmax/min([l;p;h]))+1 %ordre maximal corrspondant
for z=1:1:length(X)



    for i=1:ordre
        for j=1:ordre
            if ((i*l)^2+(j*p)^2)<(dmax+l+p)^2

                POSP=[POSP; 2*i*l-X(z)	2*j*p+Y(z)	Z(z)    abs(2*i)-1  abs(2*j)      0	Phaseelement(z)	amplitude(z)   pi-tilt(z) mod(2*pi-azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p+Y(z)	Z(z)	abs(2*i)    abs(2*j)      0	Phaseelement(z)	amplitude(z)   tilt(z) mod(azimut(z),2*pi);
                            2*i*l-X(z)	2*j*p-Y(z)	Z(z)    abs(2*i)-1  abs(2*j)-1    0	Phaseelement(z)	amplitude(z)   tilt(z)   mod(pi+azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p-Y(z)	Z(z)	abs(2*i)    abs(2*j)-1	  0	Phaseelement(z)	amplitude(z)   pi-tilt(z)  mod(pi-azimut(z),2*pi)];
            end
        end
    end


    for i=-ordre:0
        for j=1:ordre
            if ((i*l)^2+(j*p)^2)<(dmax+l+p)^2

                POSP=[POSP; 2*i*l-X(z)	2*j*p+Y(z)	Z(z)    abs(2*i)+1  abs(2*j)      0	Phaseelement(z)	amplitude(z)   pi-tilt(z) mod(2*pi-azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p+Y(z)	Z(z)	abs(2*i)    abs(2*j)      0	Phaseelement(z)	amplitude(z)    tilt(z) mod(azimut(z),2*pi);
                            2*i*l-X(z)	2*j*p-Y(z)	Z(z)    abs(2*i)+1  abs(2*j)-1    0	Phaseelement(z)	amplitude(z)    tilt(z)  mod(pi+azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p-Y(z)	Z(z)	abs(2*i)    abs(2*j)-1	  0	Phaseelement(z)	amplitude(z)   pi-tilt(z)  mod(pi-azimut(z),2*pi)];
            end
        end
    end

    for i=-ordre:0
        for j=-ordre:0
            if ((i*l)^2+(j*p)^2)<(dmax+l+p)^2

                POSP=[POSP; 2*i*l-X(z)	2*j*p+Y(z)	Z(z)    abs(2*i)+1  abs(2*j)      0	Phaseelement(z)	amplitude(z)   pi-tilt(z) mod(2*pi-azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p+Y(z)	Z(z)	abs(2*i)    abs(2*j)      0	Phaseelement(z)	amplitude(z)    tilt(z) mod(azimut(z),2*pi);
                            2*i*l-X(z)	2*j*p-Y(z)	Z(z)    abs(2*i)+1  abs(2*j)+1    0	Phaseelement(z)	amplitude(z)    tilt(z)  mod(pi+azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p-Y(z)	Z(z)	abs(2*i)    abs(2*j)+1	  0	Phaseelement(z)	amplitude(z)   pi-tilt(z)  mod(pi-azimut(z),2*pi)];
            end
        end
    end

    for i=1:ordre
        for j=-ordre:0
            if ((i*l)^2+(j*p)^2)<(dmax+l+p)^2

                POSP=[POSP; 2*i*l-X(z)	2*j*p+Y(z)	Z(z)    abs(2*i)-1  abs(2*j)      0	Phaseelement(z)	amplitude(z)   pi-tilt(z) mod(2*pi-azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p+Y(z)	Z(z)	abs(2*i)    abs(2*j)      0	Phaseelement(z)	amplitude(z)    tilt(z) mod(azimut(z),2*pi);
                            2*i*l-X(z)	2*j*p-Y(z)	Z(z)    abs(2*i)-1  abs(2*j)+1    0	Phaseelement(z)	amplitude(z)    tilt(z)  mod(pi+azimut(z),2*pi);
                            2*i*l+X(z)	2*j*p-Y(z)	Z(z)	abs(2*i)    abs(2*j)+1	  0	Phaseelement(z)	amplitude(z)   pi-tilt(z)  mod(pi-azimut(z),2*pi)];
            end
        end
    end

        
        
        
        
toc
    end
    disp('3D')
    POSI=POSP;
    POSI(:,3)=h-POSI(:,3);
    %POSI(:,9)=pi+POSI(:,9);%changement de' tilt
    POSI(:,10)=mod(POSI(:,10)+pi,2*pi);%inversion de l'azimuth
for k=-ordre:ordre
    if mod(k,2)==0
        POS=[POS;POSP+[zeros(length(POSP),1) zeros(length(POSP),1) (k*h)*ones(length(POSP),1)   zeros(length(POSP),1)   zeros(length(POSP),1)  abs(k)*ones(length(POSP),1) zeros(length(POSP),1) zeros(length(POSP),1) zeros(length(POSP),1) zeros(length(POSP),1)]];
    else
        POS=[POS;POSI+[zeros(length(POSI),1) zeros(length(POSI),1) (k*h)*ones(length(POSI),1)   zeros(length(POSP),1)   zeros(length(POSI),1)  abs(k)*ones(length(POSI),1) zeros(length(POSI),1) zeros(length(POSI),1) zeros(length(POSI),1) zeros(length(POSI),1)]];
    end
    
end 
    toc
filename = sprintf('%delemIETR_%dns.mat',length(X),round(Lt/(1e-9)));   
save(filename,'POS')
toc
%clear POS

% 
% %%special antennes
% POSANT=[];
% for g=1:1:length(POS)
%     if (POS(g,4)+POS(g,5)+POS(g,6))<3 
%         ;
%         POSANT=[POSANT;POS(g,:)];
%         %disp(g)
%     end
% end
% 
% disp(POSANT)



