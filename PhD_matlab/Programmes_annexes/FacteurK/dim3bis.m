clear
tic
K=[];
V2=[];
Kfinal=[];
sigma=.08;
N=30; %position de brasseur
Nfreq=200; %nombre de fréquences
Nexp=1000; %nombre d'expérience de la simulation de MC
a=0;
K=-40:1:30;
f0=1e9;
v2=2*sigma^2*10.^(K/10);
a=0
for f=1:1:length(v2);
    a=a+1;
    if mod(round(a/length(v2)*500000),10)==0
        disp(a/length(v2)*100)
    end
    
    %Génération du S21
    Sr=sigma*(randn(N,Nfreq,Nexp))+(sqrt(v2(f)))*cos(45);
    Si=sigma*(randn(N,Nfreq,Nexp))+(sqrt(v2(f)))*sin(45);

    %moyenne sur les positions de brasseur
    mr=mean(Sr,1).^2;
    mi=mean(Si,1).^2;


    vv=(mr+mi); %v^2

    ss=(var(Sr,0,1)+var(Si,0,1))*N/(N-1); %2*sigma^2
    %ss=2*0.08^2; %sigma déterministe

    %moyenne sur les fréquences
    k=mean(vv./ss,2)-1/N;
    %k=mean(vv./ss,2)-1/N;

    %moyenne sur les expériences (lissage de Monte Carlo)
    kmoy=mean(k,3);

    min95=prctile(k,5);
    max95=prctile(k,95);

    Kfinal=[Kfinal;kmoy min95 max95];

end
for i=1:1:length(Kfinal(:))
    if Kfinal(i)<0
        Kfinal(i)=0

    end
end






%******************
Kvrai_dB=-40:1:30;
Kvrai_lin=10.^(Kvrai_dB/10);
q025_lin=Kvrai_lin-1.96*sqrt(1/(N^2)+2*Kvrai_lin/N)/sqrt(Nfreq);
q975_lin=Kvrai_lin+1.96*sqrt(1/(N^2)+2*Kvrai_lin/N)/sqrt(Nfreq);

for i=1:1:length(q025_lin(:))
    if q025_lin(i)<0
        q025_lin(i)=0
        if q975_lin(i)<0
        q975_lin(i)=0
    end
    end
end


q025_dB=10*log10(q025_lin);
q975_dB=10*log10(q975_lin);
y=[Kvrai_dB;q025_dB;q975_dB];
%******************

figure(1)
hold on
plot(K,K,'LineWidth',1,'Color','k')
plot(K,10*log10(Kfinal(:,1)),'b')
plot(K,10*log10(Kfinal(:,2)),'g')
plot(Kvrai_dB,y(2,:),'b.');
plot(K,10*log10(Kfinal(:,3)),'g')
plot(Kvrai_dB,y(3,:),'b.');
legend('True values','Estimated values','Range of estimated values','Intervalle de confiance analytique')
title(['K-factor estimation for ',num2str(N),' stirrer positions, ',num2str(Nfreq),' frequencies and ',num2str(Nexp), ' Monte Carlo experiments'])
xlabel('K')
axis equal
ylabel('K estime')
grid on
hold off
toc
figure(2)
var_th=1/N^2+2*(10.^(K/10))/N;
plot(K,20*log10(Kfinal(:,2)),K,10*log10(var_th));


