clear
GPUstart
tic
K=[];
V2=[];
Kfinal=[];
sigma=.08;
Nexp=10000;
N=30;
Nfreq=30;
a=0
K=-40:1:30
f0=1e9;
v2=2*sigma^2*10.^(K/10);
a=0
for f=1:1:length(v2);
	a=a+1;
	     if mod(round(a/length(v2)*100),10)==0
         	disp(a/length(v2)*100)
     end

    Sr=sigma*GPUsingle(randn(N,Nfreq,Nexp));
    Si=sigma*GPUsingle(randn(N,Nfreq,Nexp))+(sqrt(v2(f)));


  
    vv=[];
    

       mr=sum(Sr)/N;
       mi=sum(Si)/N;
       vv=(mr.^2+mi.^2);


   
   ss=var(Sr)+var(Si);
    k=sum((vv./ss)-1/N)/Nfreq;
    
    kmoy=sum(k)/Nexp;
   % sig=std((vv./ss));


    min95=prctile(k,2.5);
    max95=prctile(k,97.5);

    Kfinal=[Kfinal;kmoy min95 max95];




V2=single(vv);

 
     moy=mean(V2);
     sig=std(V2);
     min95=prctile(V2,2.5);
     max95=prctile(V2,97.5);
  
    Kfinal=[Kfinal;moy sig/sigma^2/2 moy/sigma^2/2 min95/sigma^2/2 max95/sigma^2/2];
 end
%load ResultN100-10000.mat
%  figure,
% plot(20*log10(K),20*log10(Vfinal(:,5)),20*log10(K),20*log10(Vfinal(:,6)))
figure(1)
hold on
%plot(20*log10(K/2),20*log10(Vfinal(:,5)),20*log10(K/2),20*log10(Vfinal(:,6)),20*log10(K/2),20*log10(Vfinal(:,1)/sigma),20*log10(K/2),20*log10(K/2))
plot(K,K,'LineWidth',1,'Color','k')
plot(K,10*log10(Kfinal(:,3)),'b')
plot(K,10*log10(Kfinal(:,4)),'--g')
plot(K,10*log10(Kfinal(:,5)),'--r')
plot(K,10*log10(Kfinal(:,3)-2*Kfinal(:,2)/sqrt(30)),'--m')
plot(K,10*log10(Kfinal(:,3)-2*Kfinal(:,2)/sqrt(100)),'--g')
plot(K,10*log10(Kfinal(:,3)+2*Kfinal(:,2)/sqrt(30)),'--m')
plot(K,10*log10(Kfinal(:,3)+2*Kfinal(:,2)/sqrt(100)),'--g')
legend('True values','Estimated values','Centile @ 97.5%','Centile @ 2.5%','Range of estimated values with N=30','Range of estimated values with N=100')
%plot(20*log10(Result(:,1)),20*log10(Result(:,2)),'bo')
xlabel('K')
axis equal
ylabel('K estime')
grid on
% 
% figure,
% plot(10*log10(K),Kfinal(:,4))

%save TESTDUDSR1000.txt 'Vfinal'
     



    toc