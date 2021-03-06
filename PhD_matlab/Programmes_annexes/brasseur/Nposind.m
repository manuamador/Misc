clear all
load ttrnd6palesgraphoptimRxRyRz.mat

for i=1:40
    X=find(Rx(:,i)>0.37);
    x0=X(1);
    x1=X(length(X));
    nx(i)=360/(x1-x0);
    
    Y=find(Ry(:,i)>0.37);
    y0=Y(1);
    y1=Y(length(Y));
    ny(i)=360/(y1-y0);
    
    Z=find(Rz(:,i)>0.37);
    z0=Z(1);
    z1=Z(length(Z));
    nz(i)=360/(z1-z0);
    
end

f=100:100:4000;

plot(f,nx,f,ny,f,nz)


for i=1:40
    
    R=mean([Rx(:,i) Ry(:,i) Rz(:,i)],2)
    X=find(R>0.37);
    x0=X(1);
    x1=X(length(X));
    n(i)=360/(x1-x0);
    
end

f=100:100:4000;

plot(f,n)



clear all
load ttrnd6palesgraphoptimRxRyRz10deg.mat
theta=175:186;
thetai=175:.1:186;

Rxi=interp1(theta,Rx,thetai,'spline');
Ryi=interp1(theta,Ry,thetai,'spline');
Rzi=interp1(theta,Rz,thetai,'spline');

for i=1:781
    X=find(Rxi(:,i)>0.37);
    x0=X(1);
    x1=X(length(X));
    nx(i)=3600/(x1-x0);
    
    Y=find(Ryi(:,i)>0.37);
    y0=Y(1);
    y1=Y(length(Y));
    ny(i)=3600/(y1-y0);
    
    Z=find(Rzi(:,i)>0.37);
    z0=Z(1);
    z1=Z(length(Z));
    nz(i)=3600/(z1-z0);
    
end
f=100e6:5e6:4000e6


plot(f,nx,f,ny,f,nz)


