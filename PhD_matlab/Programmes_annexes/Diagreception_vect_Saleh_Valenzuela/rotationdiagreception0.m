%Example.m sample program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       CHANNEL IMPULSE RESPONSE, PULSED SIGNAL RESPONSE        %
%                    & FREQUENCY RESPONSE                       %
%        by E. Amador (emmanuel.amador@insa-rennes.fr)          %
%                         IETR/DGA                              %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
tic
global Lt c R POS


c = 299792458;%
Lt = .5e-6; %Time-window length in seconds
nbre_elements = 1; %number of radiating elements
dmax = c*Lt; %maximal distance

%loading the Position matrix from the image generator
filename = sprintf('%delem_%dns1s8.mat',nbre_elements,round(Lt/(1e-9)));
load(filename)
toc
%Loss coefficient
R = .98;

%Reception point rectangular coordinates
X_1 = 4;
Y_1 = 2;
Z_1 = 1;

[Sx,Sy,Sz,t,azim,elev] = CIRvect(X_1,Y_1,Z_1);
toc
tau = Lt; %length of the pulse in seconds
f0 = 1e9; %monochromatic pulse frequency

N = round(5*Lt*f0) %number of points for the chosen time-window (Lt)
tt = 0:Lt/(N-1):Lt; %time scale
x = 0:1/((N-1)/Lt):tau;
s = sin(2*pi*f0*x); %pulsed signal

Snz=zeros(1,N);
zn=round((N-1)*t./Lt);

% for j=1:1:length(Signalz)
%     if zn(j)<N+1
% %         Snx(zn(j))=Snx(zn(j))+Sx(j);
% %         Sny(zn(j))=Sny(zn(j))+Sy(j);
%         Snz(zn(j))=Snz(zn(j))+Sz(j);
%     end
% end


% D=5% taille du syst�me en lambda
% 
% n = 50;
% xa = D*rand(n,1);
% ya = D*rand(n,1);
% za = D*rand(n,1);
% Ia = complex(rand(n,1),rand(n,1));
% S = 2;
% save('ant.mat','xa','ya','za','Ia','S','n')
% 
% load('ant.mat')
D=5% taille du syst�me en lambda

D=1% taille du syst�me en lambda

n =3;
dx=0.25
xa = 1:dx:dx*n+1;%D*rand(n,1);
ya = ones(1,n);%D*rand(n,1);
za = ones(1,n);%D*rand(n,1);

[Ia, dph] = dolph3(1, dx, n, 5)


S =2;
%Pulsed signal

CIRz=[];
CONVz=[];
M=360;

for o=2*pi/M:2*pi/M:2*pi
disp(o/(2*pi))
azimp=azim+o;    
fr = fres(pi/2-elev, pi-azimp, n, xa, ya, za, Ia);
fa = fantres(fr, pi/2-elev, pi-azimp, S);


% Signalx=Sx.*fa;
% Signaly=Sy.*fa;
Signalz=Sz.*fa;


% Snxa=zeros(1,N);
% Snya=zeros(1,N);
Snza=zeros(1,N);


for j=1:1:length(Signalz)
    if zn(j)<N+1
%         Snxa(zn(j))=Snxa(zn(j))+Signalx(j);
%         Snya(zn(j))=Snya(zn(j))+Signaly(j);
        Snza(zn(j))=Snza(zn(j))+Signalz(j);
    end
end
sigconvz=conv(s,Snza);
CIRz=[CIRz;Snza];
CONVz=[CONVz;sigconvz(1:N)];
clear Signalx Signaly Signalz
toc
end
%
%plot(tt,Snz,tt,Snza./sqrt(sum(Snza.^2)/sum(Snz.^2)))
% for i=1:M
%     
% U=find(cumsum(CIRz(i,:).^2)/sum(CIRz(i,:).^2)>0.63);
% tau(i)=tt(min(U));
% figure(1)
% subplot(3,1,1)
% plot(tt,CIRz(i,:), 'DisplayName', 'Snza', 'YDataSource', 'Snza'); 
% ylim([-0.1 0.1])
% title(num2str(i))
% subplot(3,1,2)
% plot(tt,cumsum(CIRz(i,:).^2)/sum(CIRz(i,:).^2), 'DisplayName', 'Snza', 'YDataSource', 'Snza'); figure(gcf)
% title(num2str(i))
% subplot(3,1,3)
% plot(tt,CONVz(i,:), 'DisplayName', 'Snza', 'YDataSource', 'Snza'); 
% title(num2str(i))
% ylim([-1 1])
% getframe;
% end
figure(1)
%polar(2*pi/M:2*pi/M:2*pi,((tau-min(tau))/max(tau-min(tau))))
polar(2*pi/M:2*pi/M:2*pi,(tau-min(tau))/min(tau))
figure(5)
plot(2*pi/M:2*pi/M:2*pi,tau)

(max(tau)-min(tau))/min(tau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Diag
nt = 100;
np = 191;
theta2 = linspace(0, pi, nt);
phi2 = linspace(0, 2*pi, np);
[thetaa, phia] = meshgrid(theta2, phi2);
frant = fres(thetaa, phia, n, xa, ya, za, Ia);
faant = fantres(frant, thetaa, phia, S);
d1ant = Directivite(faant, thetaa, phia)
tracediag(faant,thetaa, phia);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%