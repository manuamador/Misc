clear all
close all

load SRopldiff.mat
SR=SR';

ppp=0
for ooo=0:0.1:10
    tic
    ppp=ppp+1
    disp(ooo)
    for uuu=1:length(SR(1,:))
        %disp(uuu)
        
        critere=ooo;%en dBm
        
        Crit(ppp,uuu)=(critere);
        criterexpo=1;%en s
        SRi=((SR(:,uuu)./mean(SR(:,uuu))).^2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%   MODE STIRRING %%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %thetai = .01:.01:360;
        %SRi = interp1(theta,SR,thetai,'spline');
        texp=[];
        ttexp=[];
        TEXP=[];
        Z=[];
        tr=90;%temps en s de rotation d'un tour
        thetap=2*pi/tr; %vitesse de rotation du brasseur en rad/s.
        T=1; %periode de fonctionnement en s
        Lt=lcm(T,tr); %durée de la mesure
        %Lt=1/thetap*2*pi %durée de la mesure totale
        
        rho_f=1; %rapporty cyclique de fonctionnement de la machine
        dt=1/thetap*2*pi/length(theta);
        t=dt:dt:Lt;
        t1=dt:dt:T;%une période
        Fu=ones(round(rho_f*length(t1)),1);
        Fu=[Fu;zeros(length(t1)-length(Fu),1)];
        
        Functionning=Fu;
        while length(Functionning)<length(t)
            Functionning=[Functionning;Fu];
        end
        Functionning=Functionning(1:length(t));
        
        power=SRi;
        while length(power)<length(t)
            power=[power;SRi];
        end
        power=power(1:length(t));
        
        essai=power.*Functionning;
        essaidB=10*log10(essai)+3;
        pmax(ppp,uuu)=max(essaidB);
        U=[];
        U=find(essaidB>critere);
        Susceptibility=[];
        %for u=1:length(U)
        Susceptibility(U)=essaidB(U);
        %end
        
        Susceptibility=[Susceptibility zeros(1,length(t)-length(Susceptibility))];
        
        figure(1)
        hold on
        plot(10*log10(power)+3,'--b')
        plot(essaidB,'-g','LineWidth',1)
        plot(Susceptibility,'-r','LineWidth',2)
        plot(critere*(ones(1,length(t))),'--k','LineWidth',2)
        
        grid on
        xlabel('Time [s]')
        ylabel('Level [dB]')
        hold off
        pause
        pfailure(ppp,uuu)=length(U)/length(essaidB);
        
        if length(U)==0
            disp('pas de défaut')
            result(ppp,uuu)=0;
        else
            
            tessais=[];
            texpo=[];
            for i=1:1:length(U)-1
                tessais(1)=U(1);
                if U(i)+1~=U(i+1)
                    tessais=[tessais;U(i);U(i+1)];
                end
            end
            
            if length(tessais)==1
                tessais(2)=U(length(U));
            end
            
            dessais=(tessais(2:2:length(tessais))-tessais(1:2:length(tessais)-1))*(t(2)-t(1));
            texpomoyen(ppp,uuu)=mean(dessais);
            texpomax(ppp,uuu)=max(dessais);
            for i=1:length(dessais)
                if dessais(i)>criterexpo
                    dureeessai(i)=(t(2)-t(1))*tessais(2*i);
                    result(ppp,uuu)=1;
                else
                    dureeessai(i)=NaN;
                end
            end
            if mean(dureeessai)~=NaN
                tempsessai(ppp,uuu)=nanmin(dureeessai);
            else
                disp('pas de défaut')
                result(ppp,uuu)=0;
            end
        end
    end
toc    
end

%save('resrho_1v90expo_1.mat','texpomax','texpomoyen','tempsessai','lamb','result','Crit','pfailure')

