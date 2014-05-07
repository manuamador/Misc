%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%    MODE TUNING  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all

load SRopldiff.mat
SR=SR';
for uuu=1:length(SR(1,:))
    
    SRi=((SR(:,uuu)./mean(SR(:,uuu))).^2);
    ppp=0;
    for ooo=0:0.1:10
        ppp=ppp+1
        critere=ooo %en dBm
        
        M=360;
        for N=1:M %positions de brasseurs
            disp(N)
         
            powerdB=10*log10(SRi)+3;
            
            essairand=0;
            posrand=0;
%             essaiequi=0;
%             posequi=0;
            nbressai=100;
            
            for u=1:nbressai
                
                %%% 1ère stratégie: 50 positions aléatoires
                posirand=sort(randi(length(SRi),N,1)); %pas de positions differentes
                %         posirand=[randi(length(SR))];
                %
                %         while length(posirand)<N
                %             a=randi(length(SR));
                %             if min(abs(posirand-a))<1000
                %                 posirand=[posirand;a];
                %             end
                %         end
                posirand=sort(posirand);
                for i=1:N;
                    P(i)=powerdB(posirand(i));
                end
                
                [vmax,posmax]=max(P);
                if vmax>critere
                    %disp('essai OK')
                    essairand=essairand+1;
                    %disp(posmax)
                    posrand=posrand+posirand(posmax)/length(SRi);
                    %else
                    % disp('echec')
                end
                
                %%% 2ème stratégie 50 positions équi-réparties
                
                %         START=randi(length(SR));
                %         for i=1:N;
                %             Q(i)=powerdB(mod(START+i*round((length(SR)/N)),length(SR))+1);
                %         end
                %
                %         [vmax,posmax]=max(Q);
                %         if vmax>critere
                %             %     disp('essai OK')
                %             %     disp(posmax)
                %             essaiequi=essaiequi+1;
                %
                %             posequi=posequi+posmax*round((length(SR)/N))/length(SR);
                %             %else
                %             %disp('echec')
                %         end
            end
            
            
            
            % disp('défaut rand')
            % essairand/nbressai*100
            % disp('temps rand en ° parcourus')
            % posrand
            %
            % disp('défaut equi')
            % essaiequi/nbressai*100
            % disp('temps rand en ° parcourus')
            % posequi
            
            NN(N)=N;
            effrand(N,uuu,ppp)=essairand/nbressai*100;
            %effequi(N)=essaiequi/nbressai*100;
            tempsrand(N,uuu,ppp)=posrand/90000*90;
            %tempsequi(N)=posequi;
            
        end
    end
end
