function [max_speed]=get_max_speed_LD(speed)

%   INPUT
%       speed: matrice con righe i bambini e colonne le velocita dei tre
%       livelli (senza i NaN)

%   OUTPUT
%       max_speed: matrice con righe i bambini colonne velocita  massima
%       per ogni esecuzione

% LD: deve essermi sfuggita, ma non fa quello che ci aspettiamo: quando
% avevo parlato di prendere il 10%, intendevo il più alto e mediavo, non il
% primo 10% (come avete fatto voi) propongo qui la mia soluzione

% sarebbe corretto prima filtrare
speed_filt = lowpass(speed,10,250);
speed_th = nanmin(speed_filt) + range(speed_filt).*0.9;
speed_high = speed_filt(speed_filt > speed_th);
max_speed = nanmedian(speed_high);


% vel=speed; %crea vettore vel contenente velocità del bambino 
%     for indice=1: (size(vel,1))*10/100
%         vmax(indice,1)= max(vel); %trovo il massimo
%             for it=1:size(vel,1) %reitero tutto il vettore di velocità 
%                 c=0; %variabile c aggiunta cosicchè valore massimo viene posto a zero solo 1 volta anche se si ripete
%                     if vel(it,1)==vmax(indice,1) %se la velocità nel vettore corrisponde al massimo trovato prima, quella velocità è posta a 0
%                        vel(it,1)=0;
%                        c=c+1;
%                            if c==1;
%                                 break
%                            end
%                     end
%             end
%     end
% 
%     max_speed =nanmean(vmax);

end
 