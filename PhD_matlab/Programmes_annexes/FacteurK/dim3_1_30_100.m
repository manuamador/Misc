clear

tic
K=[];
V2=[];
sigma=.08;
Nexp=100000;
Kfinal1=[];
Kfinal30=[];
Kfinal100=[];
%%%Nfreq=1
N=30; %position de brasseur
Nfreq=1; %nombre de fréquences
 %nombre d'expérience de la simulation de MC
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
    k=mean(vv./ss,2);%-1/N;
    %k=mean(vv./ss,2)-1/N;

    %moyenne sur les expériences (lissage de Monte Carlo)
    kmoy=mean(k,3);

    min95=prctile(k,2.5);
    max95=prctile(k,97.5);

    Kfinal1=[Kfinal1;kmoy min95 max95];

end
for i=1:1:length(Kfinal1(:))
    if Kfinal1(i)<0
        Kfinal1(i)=0;

    end
end

%%%NFreq=30

N=30; %position de brasseur
Nfreq=30; %nombre de fréquences
 %nombre d'expérience de la simulation de MC
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
    k=mean(vv./ss,2);%-1/N;
    %k=mean(vv./ss,2)-1/N;

    %moyenne sur les expériences (lissage de Monte Carlo)
    kmoy=mean(k,3);

    min95=prctile(k,2.5);
    max95=prctile(k,97.5);

    Kfinal30=[Kfinal30;kmoy min95 max95];

end
for i=1:1:length(Kfinal30(:))
    if Kfinal30(i)<0
        Kfinal30(i)=0;

    end
end


%%%%Nfreq=100
N=30; %position de brasseur
Nfreq=100; %nombre de fréquences
 %nombre d'expérience de la simulation de MC
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
    k=mean(vv./ss,2);%-1/N;
    %k=mean(vv./ss,2)-1/N;

    %moyenne sur les expériences (lissage de Monte Carlo)
    kmoy=mean(k,3);

    min95=prctile(k,2.5);
    max95=prctile(k,97.5);

    Kfinal100=[Kfinal100;kmoy min95 max95];

end
for i=1:1:length(Kfinal100(:))
    if Kfinal100(i)<0
        Kfinal100(i)=0;

    end
end






figure(1)
hold on
plot(K,K,'LineWidth',1,'Color','k')
plot(K,10*log10(Kfinal1(:,1)),'b')
plot(K,10*log10(Kfinal1(:,2)),'--b')
plot(K,10*log10(Kfinal30(:,2)),'-.r')
plot(K,10*log10(Kfinal100(:,2)),':g')
plot(K,10*log10(Kfinal1(:,3)),'--b')
plot(K,10*log10(Kfinal30(:,3)),'-.r')
plot(K,10*log10(Kfinal100(:,3)),':g')
legend('$K$','$\textrm{E}\left[\widehat{K_2}\right]$','CI with $N_\textrm{fr}=1$','CI with $N_\textrm{fr}=30$','CI with $N_\textrm{fr}=100$')
xlabel('$K$ in dB')
axis equal
ylabel('Estimation of $K$ in dB')
grid on
hold off
xlim([-40 30])
ylim([-40 30])
toc
