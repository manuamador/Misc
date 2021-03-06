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
Lt = 6e-6; %Time-window length in seconds
nbre_elements = 1; %number of radiating elements
dmax = c*Lt; %maximal distance

%loading the Position matrix from the image generator
filename = sprintf('%delem_%dns1s8e111.mat',nbre_elements,round(Lt/(1e-9)));
load(filename)
toc
%Loss coefficient
R = .998;
tau=-3/(2*c*log(R))
%Reception point rectangular coordinates
X_1 = 4;
Y_1 = 2;
Z_1 = 1;

[Sx,Sy,Sz,t,azim,elev] = CIRvect(X_1,Y_1,Z_1);
toc

D=5% taille du syst�me en lambda

% n = 50;
% xa = D*rand(n,1);
% ya = D*rand(n,1);
% za = D*rand(n,1);
% Ia = complex(rand(n,1),rand(n,1));
% S = 2;
% save('ant.mat','xa','ya','za','Ia','S','n')
% 
% load('ant.mat')

n =9;
dx=0.25
xa = 1:dx:dx*n+1;%D*rand(n,1);
ya = ones(1,n);%D*rand(n,1);
za = ones(1,n);%D*rand(n,1);

[Ia, dph] = dolph3(1, dx, n, 20)


S = 2;

%Pulsed signal
tau = Lt; %length of the pulse in seconds
f0 = 1e9; %monochromatic pulse frequency

N = round(10*Lt*f0) %number of points for the chosen time-window (Lt)
tt = 0:Lt/(N-1):Lt; %time scale
x = 0:1/((N-1)/Lt):tau;
s = sin(2*pi*f0*x); %pulsed signal

CIRz=[];
CONVz=[];
FFTz=[];
M=360;

for o=[0, pi/3, pi/2]
disp(o/(2*pi))
azimp=azim+o;    
fr = fres(mod(pi/2-elev,pi), mod(pi-azimp,2*pi), n, xa, ya, za, Ia);
fa = fantres(fr,mod(pi/2-elev,pi),mod(pi-azimp,2*pi), S);

% Signalx=Sx.*fa;
% Signaly=Sy.*fa;
Signalz=Sz.*fa;


% Snx=zeros(1,N);
% Sny=zeros(1,N);
Snz=zeros(1,N);
% Snxa=zeros(1,N);
% Snya=zeros(1,N);
Snza=zeros(1,N);
zn=round((N-1)*t./Lt);

for j=1:1:length(Signalz)
    if zn(j)<N+1
%         Snx(zn(j))=Snx(zn(j))+Sx(j);
%         Sny(zn(j))=Sny(zn(j))+Sy(j);
      %  Snz(zn(j))=Snz(zn(j))+Sz(j);
        
%         Snxa(zn(j))=Snxa(zn(j))+Signalx(j);
%         Snya(zn(j))=Snya(zn(j))+Signaly(j);
        Snza(zn(j))=Snza(zn(j))+Signalz(j);
    end
end
sigconvz=conv(s,Snza);
CIRz=[CIRz;Snza];
CONVz=[CONVz;sigconvz(1:N)];

Fs = N/Lt; %sampling frequency
T = 1/Fs;                     % sample length
L = N;                  %Number of points
tt = (0:L-1)*T;                % time...

NFFT = 2^nextpow2(N); % Next power of 2 from length of y
%Yx = fft((Sx),NFFT)/N;
%Yy = fft((Sy),NFFT)/N;
Yz = fft((Snza),NFFT);
f = Fs/2*linspace(0,1,NFFT/2);

% Three axis frequency response
%FFTx=abs(Yx(1:NFFT/2));
%FFTy=abs(Yy(1:NFFT/2));
FFTz=[FFTz;abs(Yz(1:NFFT/2))];
freq=f;

clear Signalx Signaly Signalz
toc
end
%
%plot(tt,Snz,tt,Snza./sqrt(sum(Snza.^2)/sum(Snz.^2)))
%for i=1
    
% U=find(cumsum(CIRz(i,:).^2)/sum(CIRz(i,:).^2)>0.63);
% tau(i)=tt(min(U));
figure(2)
subplot(2,1,1)
plot(tt/1e-6,CIRz(1,:).^2, 'DisplayName', 'Snza', 'YDataSource', 'Snza'); 
xlim([0 1])
ylim([0 0.002])
%xlim([0 100e-9])
xlabel('time [s]')
ylabel('[V/m]')
grid on
title(num2str(1))
subplot(2,1,2)
plot(freq/1e6,20*log10(FFTz(1,:)),'DisplayName', 'Snza', 'YDataSource', 'Snza');
xlim([0 300])
ylim([-50 30])
xlabel('frequency [MHz]')
ylabel('[dBm/Hz]')
title(num2str(1))
grid on

figure(1)
subplot(2,1,1)
plot(tt/1e-6,CIRz(2,:).^2, 'DisplayName', 'Snza', 'YDataSource', 'Snza'); 
xlim([0 1])
ylim([0 0.002])
%xlim([0 100e-9])
xlabel('time [s]')
ylabel('[V/m]')
grid on
title(num2str(2))
subplot(2,1,2)
plot(freq/1e6,20*log10(FFTz(2,:)),'DisplayName', 'Snza', 'YDataSource', 'Snza');
xlim([0 300])
ylim([-50 30])
xlabel('frequency [MHz]')
ylabel('[dBm/Hz]')
title(num2str(1))
grid on

% subplot(3,1,3)
% plot(tt,CONVz(i,:), 'DisplayName', 'Snza', 'YDataSource', 'Snza'); 
% title(num2str(i))
% %xlim([0 100e-9])
% ylim([-3 3])
% xlabel('time [s]')
% ylabel('[V/m]')
% grid on
getframe;
  %filename=sprintf('fileantenne18dbsslobes_%d.png',i)
 % saveas(gcf,filename,'png')
%end
figure(6)
polar(2*pi/M:2*pi/M:2*pi,((tau-min(tau))/max(tau-min(tau))))
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