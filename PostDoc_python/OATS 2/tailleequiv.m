clear java
clear all
c=3e8;

R = 10;  %radius (m)
f=1e6:1e6:10e9;
lambda=c./f;
h=1;
Reflec=1;
%EUT
%positions of the dipoles and amplitude and phase

%random EUT
n=10; %number of dipoles

R_eut=.3; %m

theta_eut=acos(2*rand(n,1)-1);
phi_eut=2*pi*rand(n,1);
x=R_eut*cos(phi_eut).*sin(theta_eut);
y=R_eut*sin(phi_eut).*sin(theta_eut);
z=R_eut*cos(theta_eut);
tilt=pi/2*ones(n,1);%acos(2*rand(n,1)-1);
azimut=2*pi*rand(n,1);

ld=.1

amplitude=ones(n,1);
phas=2*pi*rand(n,1);

I = [x y z tilt azimut amplitude phas];


%Free space caracterisation (perfect anechoic chamber)
phi=(1:8:360)*pi/180;
theta=(1:8:180)*pi/180;

[PHIac,THETAac]=meshgrid(phi,theta);
tic
for i=1:length(theta)
    for j=1:length(phi)
        X=R*cos(PHIac(i,j))*sin(THETAac(i,j));
        Y=R*sin(PHIac(i,j))*sin(THETAac(i,j));
        Z=R*cos(THETAac(i,j));
        DX = X-I(:,1);
        DY = Y-I(:,2);
        DZ = Z-I(:,3);
        
        dist = sqrt(DX.^2+DY.^2+DZ.^2);
        
        dp=repmat(dist,1,length(f));
        fp=repmat(f,length(dist),1);
        phaseI=repmat(I(:,7),1,length(f));
        phase=2*pi*dp.*fp/c+phaseI;
        ca    = cos(I(:,4));
        sa    = sin(I(:,4));
        cb    = cos(I(:,5));
        sb    = sin(I(:,5));
        
        
        distx = ((-sb).^2+(1-(-sb).^2).*ca).*DX+(-sb.*cb.*(1-ca)).*DY+(cb.*sa).*DZ;
        disty = (-sb.*cb.*(1-ca)).*DX+((cb).^2+(1-cb.^2).*ca).*DY+(sb.*sa).*DZ;
        distz = (-cb.*sa).*DX+(-sb.*sa).*DY+ca.*DZ;
        DXY=sqrt(DX.^2+DY.^2);
        clear DX DY DZ DXY
        distxy = sqrt(distx.^2+disty.^2);
        costheta = distz./dist;
        sintheta = distxy./dist;
        cosphi   = distx./distxy;
        sinphi   = disty./distxy;
        L =repmat(I(:,6),1,length(f))*1./dp*ld*c./fp/2*377; %Amplitude & free space attenuation
        clear distx disty distz distxy
        clear dist dp
        %Projection in the usual rectangular coordinates
        Exx = sum(exp(1i*phase).*L.*repmat(((((-sb).^2+(1-(-sb).^2).*ca).*(-sintheta.*costheta.*cosphi)+(-sb.*cb.*(1-ca)).*(-sintheta.*costheta.*sinphi)+(-cb.*sa).*(-sintheta.*(-sintheta)))),1,length(f)));
        Eyy = sum(exp(1i*phase).*L.*repmat((((-sb.*cb.*(1-ca)).*(-sintheta.*costheta.*cosphi)+((cb).^2+(1-(cb).^2).*ca).*(-sintheta.*costheta.*sinphi)+(-sb.*sa).*(-sintheta.*(-sintheta)))),1,length(f)));
        Ezz = sum(exp(1i*phase).*L.*repmat((((cb.*sa).*(-sintheta.*costheta.*cosphi)+(sb.*sa).*(-sintheta.*costheta.*sinphi)+ca.*(-sintheta.*(-sintheta)))),1,length(f)));
        
        Ethac(i,j,:)= Exx*cos(THETAac(i,j))*cos(PHIac(i,j))+Eyy*cos(THETAac(i,j))*sin(PHIac(i,j))-Ezz*sin(THETAac(i,j));
        Ephac(i,j,:)= -Exx*sin(PHIac(i,j))+Eyy*cos(PHIac(i,j));
        Erac(i,j,:) = Exx*sin(THETAac(i,j))*cos(PHIac(i,j))+Eyy*sin(THETAac(i,j))*sin(PHIac(i,j))+Ezz*cos(THETAac(i,j));
        
        
        clear Exx Eyy Ezz
        
    end
end
toc


%
%
%
% nt = length(THETAac(1,:));
% np = length(PHIac(:,1));
%
% dtheta = pi/nt;
% dphi = (2*pi)/np;
%
% for i=1:length(f)
%     Fa2=abs(Ephac(:,:,i)).^2+abs(Ethac(:,:,i)).^2;
%     Fa=Fa2/max(max(Fa2));
%     omega = sum(sum((Fa) .* sin(THETAac)*dtheta*dphi));
%     Dac(i) = 4*pi / omega;
% end
%
% ka=2*pi./lambda*R_eut;
%
% k=1:.1:20;
% Dmaxth=1/2*(0.577+log((4*k).^2+8*k)+1./(8*k.^2+16*k));
% kk=5:.1:10;
% Dmaxth2=0.982+log(kk);
%
%
% plot(ka,Dac,k,Dmaxth)



%%%OATS
I(:,3)=I(:,3)+h;
Ip = I;
Ip(:,3)=-Ip(:,3);
Ip(:,6)=Reflec*Ip(:,6);

POS=[I;Ip];

tic
for i=1:length(theta)
    for j=1:length(phi)
        X=R*cos(PHIac(i,j))*sin(THETAac(i,j));
        Y=R*sin(PHIac(i,j))*sin(THETAac(i,j));
        Z=R*cos(THETAac(i,j));
        DX = X-POS(:,1);
        DY = Y-POS(:,2);
        DZ = Z-POS(:,3);
        
        dist = sqrt(DX.^2+DY.^2+DZ.^2);
        
        dp=repmat(dist,1,length(f));
        fp=repmat(f,length(dist),1);
        phaseI=repmat(POS(:,7),1,length(f));
        phase=2*pi*dp.*fp/c+phaseI;
        ca    = cos(POS(:,4));
        sa    = sin(POS(:,4));
        cb    = cos(POS(:,5));
        sb    = sin(POS(:,5));
        
        
        distx = ((-sb).^2+(1-(-sb).^2).*ca).*DX+(-sb.*cb.*(1-ca)).*DY+(cb.*sa).*DZ;
        disty = (-sb.*cb.*(1-ca)).*DX+((cb).^2+(1-cb.^2).*ca).*DY+(sb.*sa).*DZ;
        distz = (-cb.*sa).*DX+(-sb.*sa).*DY+ca.*DZ;
        DXY=sqrt(DX.^2+DY.^2);
        clear DX DY DZ DXY
        distxy = sqrt(distx.^2+disty.^2);
        costheta = distz./dist;
        sintheta = distxy./dist;
        cosphi   = distx./distxy;
        sinphi   = disty./distxy;
        L =repmat(POS(:,6),1,length(f))*1./dp;%*ld*c./fp/2*377; %Amplitude & free space attenuation
        clear distx disty distz distxy
        clear dist dp
        %Projection in the usual rectangular coordinates
        Exx = sum(exp(1i*phase).*L.*repmat(((((-sb).^2+(1-(-sb).^2).*ca).*(-sintheta.*costheta.*cosphi)+(-sb.*cb.*(1-ca)).*(-sintheta.*costheta.*sinphi)+(-cb.*sa).*(-sintheta.*(-sintheta)))),1,length(f)));
        Eyy = sum(exp(1i*phase).*L.*repmat((((-sb.*cb.*(1-ca)).*(-sintheta.*costheta.*cosphi)+((cb).^2+(1-(cb).^2).*ca).*(-sintheta.*costheta.*sinphi)+(-sb.*sa).*(-sintheta.*(-sintheta)))),1,length(f)));
        Ezz = sum(exp(1i*phase).*L.*repmat((((cb.*sa).*(-sintheta.*costheta.*cosphi)+(sb.*sa).*(-sintheta.*costheta.*sinphi)+ca.*(-sintheta.*(-sintheta)))),1,length(f)));
        
        Ethoats(i,j,:)= Exx*cos(THETAac(i,j))*cos(PHIac(i,j))+Eyy*cos(THETAac(i,j))*sin(PHIac(i,j))-Ezz*sin(THETAac(i,j));
        Ephoats(i,j,:)= -Exx*sin(PHIac(i,j))+Eyy*cos(PHIac(i,j));
        Eroats(i,j,:) = Exx*sin(THETAac(i,j))*cos(PHIac(i,j))+Eyy*sin(THETAac(i,j))*sin(PHIac(i,j))+Ezz*cos(THETAac(i,j));
        
        
        clear Exx Eyy Ezz
        
    end
end
toc



nt = length(THETAac(1,:));
np = length(PHIac(:,1));

dtheta = pi/nt;
dphi = (2*pi)/np;

for i=1:length(f)
    Fa2=abs(Ephac(:,:,i)).^2+abs(Ethac(:,:,i)).^2;
    Fa=Fa2/max(max(Fa2));
    omega = sum(sum(Fa .* sin(THETAac)*dtheta*dphi));
    Dac(i) = 4*pi / omega;
end

for i=1:length(f)
    Fa2=abs(Ephoats(:,:,i)).^2+abs(Ethoats(:,:,i)).^2;
    Fa=Fa2/max(max(Fa2));
    omega = sum(sum(Fa .* sin(THETAac)*dtheta*dphi));
    Doats(i) = 4*pi / omega;
end

ka=2*pi./lambda*5*R_eut;
kab=2*pi./lambda*(max(POS(:,3))-min(POS(:,3)));
k=1:.1:6;
Dmaxth=1/2*(0.577+log(4*k.^2+8*k)+1./(8*k.^2+16*k));
kk=5:.1:max(ka);
Dmaxth2=0.982+log(kk);

plot(ka,Dac,'b',ka,Doats,'r',kab,Doats,'--r',k,Dmaxth,'k',kk,Dmaxth2,'k')
xlim([0 max(ka)])

%kab=7/2.5*ka

% rac=squeeze(mean(mean(abs(Ethac(:,:,:)),1),2))./squeeze(mean(mean(abs(Ephac(:,:,:)),1),2));
% roats=squeeze(mean(mean(abs(Ethoats(:,:,:)),1),2))./squeeze(mean(mean(abs(Ephoats(:,:,:)),1),2));
% rth=squeeze(mean(mean(abs(Ethoats(:,:,:)),1),2))./squeeze(mean(mean(abs(Ethac(:,:,:)),1),2));
% rph=squeeze(mean(mean(abs(Ephoats(:,:,:)),1),2))./squeeze(mean(mean(abs(Ephac(:,:,:)),1),2));


% figure(1)
% subplot(2,1,1)
% plot(ka,squeeze(mean(mean(abs(Ethac(:,:,:)),1),2)),ka,squeeze(mean(mean(abs(Ethoats(:,:,:)),1),2)),kab,squeeze(mean(mean(abs(Ethoats(:,:,:)),1),2)))
% grid on
% legend('E_\theta AC','E_\theta OATS','E_\theta OATS \alpha a')
% subplot(2,1,2)
% plot(ka,squeeze(mean(mean(abs(Ephac(:,:,:)),1),2)),ka,squeeze(mean(mean(abs(Ephoats(:,:,:)),1),2)),kab,squeeze(mean(mean(abs(Ephoats(:,:,:)),1),2)))
% grid on
% legend('E_\phi AC','E_\phi OATS','E_\phi OATS \alpha a')
%
% figure(2)
% plot(ka,rac,ka,roats)
% grid on
% legend('E_\theta/E_\phi (AC)','E_\theta/E_\phi (OATS)')
%
%
% figure(3)
% plot(ka,rth,ka,rph)
% grid on
% legend('E_\theta(OATS)/E_\theta(AC)','E_\phi(OATS)/E_\phi(AC)')


% figure(4)
% for i=1:length(f)
% subplot(2,2,1)
% imagesc(phi,theta,abs(Ethac(:,:,i)))
% colorbar
% axis equal
% axis tight
% subplot(2,2,3)
% imagesc(phi,theta,abs(Ephac(:,:,i)))
% colorbar
% axis equal
% axis tight
% subplot(2,2,2)
% imagesc(phi,theta,abs(Ethoats(:,:,i)))
% colorbar
% axis equal
% axis tight
% subplot(2,2,4)
% imagesc(phi,theta,abs(Ephoats(:,:,i)))
% colorbar
% axis equal
% axis tight
% getframe;
% end