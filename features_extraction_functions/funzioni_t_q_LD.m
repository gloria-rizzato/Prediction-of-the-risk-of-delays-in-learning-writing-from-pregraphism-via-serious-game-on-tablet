%applico funzioni a es_iOS_t_q
close all
clc
%clearvars -except mat es_iOS_t_q significance
t_q=4;
iOS=1;


child = 1;
for prova=1:15
       A(prova)=mat{child,t_q}{prova,4}(1,1);
       W(prova)=mat{child,t_q}{prova,4}(1,2);
end
A_max=max(A);
W_min=10;
for prova=1:15
    if A(prova)==A_max
        if W(prova)<W_min
            W_min=W(prova);
        end
    end
end

% figure
% plot(A,W,'o')
    

%% get_speed
close all
clc

% LD for + if + break non è molto pulito come codice, si poteva usare while

for child=1: size(mat,1)
    for prova=1:size(mat{child,t_q},1)
        if ~isempty(es_iOS_t_q{child,prova})
            if mat{child,t_q}{prova,4}(1,1)==A_max && mat{child,t_q}{prova,4}(1,2)==W_min
                %chiamiamo la funzione get_speed e salviamo in speed la
                %velocità solo delle prove con A_max e W_min
                %salviamo time, azimuth, altitude i rispettivi
                %vettori di es_iOS già segmentati solo delle prove con
                %A_max e W_min
                 speed{child,1}= get_speed(es_iOS_t_q{child,prova});
                 time{child,1}=es_iOS_t_q{child,prova}(:,1);
                 azimuth{child,1}=es_iOS_t_q{child,prova}(:,6);
                 altitude{child,1}=es_iOS_t_q{child,prova}(:,5);
                 pressione{child,1}=es_iOS_t_q{child,prova}(:,4);
                break
            end
        end
    end
end


%% get_mean_speed
close all
clc

% LD l'inizializzazione sarebbe così
mean_speed= NaN(size(mat,1),1);
% mean_speed= NaN* ones(size(mat,1),1);

for child=1:247
    it=1;
    if ~isempty(speed{child})
        for indice=1: size(speed{child},1)
            if ~isnan(speed{child}(indice,1))
                %poichè il filtro lowpass non accetta i Nan togliamo da
                %speed i NaN 
                new_speed{child,1}(it,1)=speed{child,1}(indice,1);
                it=it+1;
            end
        end
         %chiamiamo get_mean_speed 
         % LD qui era commentato, come mai?
         if ~isempty(new_speed{child,1})
             [mean_speed(child,1)]=get_mean_speed(new_speed{child,1}, 10);
         end                 
        it=1;
        % memorizziamo in new_time, new_az, new_alt i rispettivi senza i
        % NaN
        if ~isempty(time{child})
             for indice=1: size(time{child},1)
                 if ~isnan(time{child}(indice, 1))
                     new_time{child,1}(it,1)=time{child}(indice,1);
                     new_az{child,1}(it,1)=azimuth{child}(indice,1);
                     new_alt{child,1}(it,1)=altitude{child}(indice,1);
                     new_pres{child,1}(it,1)=pressione{child}(indice,1);
                     it=it+1;
                 end
             end
         end
    end
 end


%% get_max_speed 
close all
clc

max_speed= NaN* ones(size(speed,1),1);

for child=1 : size(speed,1)
    if ~isempty(new_speed{child,1}) 
         [max_speed(child,1)]=get_max_speed(new_speed{child,1});
    end
end


%% get_std
close all
clc

% LD c'era errore di posizione di una parentesi e non funzionava
% l'assegnazione
std_speed= NaN* ones(size(speed,1), 1);

for child=1 : size(new_speed,1)
    if ~isempty(new_speed{child,1})
        % LD ho sostituito std con nanstd dentro la funzione. so che per come l'avete gestito
        % non dovrebbero essercene, ma sempre meglio essere generici
        std_speed(child,1)= get_std_speed_LD(new_speed{child,1}, 10);
    end
        
end
%% picchi di velocità
close all
clc

numero_picchi= NaN* ones(size(speed,1),1);

for child=1 : size(new_speed,1)
    if ~isempty(new_speed{child,1})
        numero_picchi(child,1)= get_SNvpd(new_speed{child,1});
    end
end
%% clean_azimuth
close all
clc

for child=1: size(mat,1)   
    if ~isempty(new_az{child})
        azimuth_clean{child,1}=clean_azimuth(new_az{child,1});
    end
end

%% tilt: ci aspettiamo che la varianza di azimuth sia elevata per tutti i bambini, mentre per i disgrafici bassa..
% infatti essi mantengono costante l'azimuth (contrario per altitude)
close all
clc

for child=1:size(azimuth_clean,1)
    varianza_az(child,1)= var(azimuth_clean{child,1});
    % LD ok senza controllo: se non c'è, var torna NaN
end


for child=1: size(new_alt,1)
    if isempty (new_time{child,1})
        new_alt{child,1}= NaN;
    end
    varianza_alt(child,1)= var(new_alt{child,1});
end

%% tempo tratto con velocità sottosoglia
close all
clc

Tsottosoglia = NaN* ones(size(speed,1),1);

for child=1: size(mat,1)
    if ~isempty(new_speed{child,1})
        % LD ho sostituito come nell'altro script
        [Tsottosoglia(child,1)]=get_sottosoglia_LD(new_speed{child,1},new_time{child,1}); 
    end
end

%% contenuto in frequenza velocità
close all
clc

ampiezza_bandaV=ones*NaN(size(new_speed,1),size(new_speed,2));
energia_10V=ones*NaN(size(new_speed,1),size(new_speed,2));
ampiezza_primo_picco_v= NaN*ones(size(mat,1),1);
ampiezza_secondo_picco_v= NaN*ones(size(mat,1),1);
posizione_primo_picco_v= NaN*ones(size(mat,1),1);
posizione_secondo_picco_v= NaN*ones(size(mat,1),1);

ampiezza_bandaV_LD = NaN(size(mat,1),1);

fs= 250;
soglia_banda= 0.05; % LD visto che nell'altro avevo proposto di cambiare soglia, qui lo farei coerente
display=0;
for child=1:247  
    if child ~= 220 %bambino senza prova con Amax e Wmin
        if ~isempty(mat{child,t_q}) && ~isempty(mat{child,t_q}{prova, iOS}) && ~isempty(new_speed{child,1})
          
                [norm_x_fftV{child,1},f_xV{child,1}]= get_freq (new_speed{child,1},fs, display);
                %problemi con il bambino 127 perchè proprio la prova con Amax e
                %Wmin è piena di vuoti (anche la colonna che indica i valori di
                %A e W)
                 norm_fftV{child,1}=norm_x_fftV{child,1}(find(f_xV{child,1}<10),1);
                 fV{child,1}=f_xV{child,1}(f_xV{child,1}<10);

                 % LD ho cambiato funzione come nell'altra, ma potete
                 % decidere voi quale usare tra la feature calcolata da voi
                 % e quella che ho calcolato io (era più per fare un check
                 % se cambiava di molto). però usiamo questa funzione che
                 % fa prima lo smooth
                [ampiezza_picchiV{child,1}, posizione_picchiV{child,1}, ampiezza_bandaV(child,1),...
                    ampiezza_bandaV_LD(child,1),energia_10V(child,1)] = contenuto_frequenza_LD (norm_fftV{child,1}, fV{child,1},...
                    soglia_banda);
                if ~isempty(ampiezza_picchiV{child, 1})
                    ampiezza_primo_picco_v(child,1)=ampiezza_picchiV{child, 1}(1,1);
                    ampiezza_secondo_picco_v(child,1)=ampiezza_picchiV{child, 1}(2,1);
                    posizione_primo_picco_v(child,1)=posizione_picchiV{child, 1}(1,1);
                    posizione_secondo_picco_v(child,1)=posizione_picchiV{child, 1}(2,1);
                end
                
            end
        end
end

%% contenuto in frequenza pressione

close all
clc

ampiezza_bandaP=ones*NaN(size(new_speed,1),size(new_speed,2));
energia_10P=ones*NaN(size(new_speed,1),size(new_speed,2));
ampiezza_primo_picco_p= NaN*ones(size(mat,1),1);
ampiezza_secondo_picco_p= NaN*ones(size(mat,1),1);
posizione_primo_picco_p= NaN*ones(size(mat,1),1);
posizione_secondo_picco_p= NaN*ones(size(mat,1),1);

ampiezza_bandaP_LD=NaN(size(new_speed,1),size(new_speed,2));

fs= 250;
soglia_banda= 0.05;
display=0;
for child=1:247
    if child ~= 220
        if ~isempty(mat{child,t_q}) && ~isempty(mat{child,t_q}{prova,iOS}) && ~isempty(new_pres{child,1})
            [norm_x_fftP{child,1},f_xP{child,1}]= get_freq(new_pres{child,1},fs, display);
             norm_fftP{child,1}=norm_x_fftP{child,1}(find(f_xP{child,1}<10),1);
             fP{child,1}=f_xP{child,1}(f_xP{child,1}<10);
                
            [ampiezza_picchiP{child,1}, posizione_picchiP{child,1}, ampiezza_bandaP(child,1),...
                ampiezza_bandaP_LD(child,1),energia_10P(child,1)] = contenuto_frequenza_LD (norm_fftP{child,1}, fP{child,1},...
                soglia_banda);
            if ~isempty(ampiezza_picchiP{child, 1})
                ampiezza_primo_picco_p(child,1)=ampiezza_picchiP{child, 1}(1,1);
                ampiezza_secondo_picco_p(child,1)=ampiezza_picchiP{child, 1}(2,1);
                posizione_primo_picco_p(child,1)=posizione_picchiP{child, 1}(1,1);
                posizione_secondo_picco_p(child,1)=posizione_picchiP{child, 1}(2,1);
            end
        end
    end
end

%% contenuto in frequenza azimuth
close all
clc

ampiezza_bandaAZ=ones*NaN(size(azimuth_clean,1),size(azimuth_clean,2));
energia_10AZ=ones*NaN(size(azimuth_clean,1),size(azimuth_clean,2));
ampiezza_primo_picco_az= NaN*ones(size(mat,1),1);
ampiezza_secondo_picco_az= NaN*ones(size(mat,1),1);
posizione_primo_picco_az= NaN*ones(size(mat,1),1);
posizione_secondo_picco_az= NaN*ones(size(mat,1),1);

ampiezza_bandaAZ_LD=NaN(size(azimuth_clean,1),size(azimuth_clean,2));

fs= 250;
soglia_banda= 0.05;
display=0;
for child=1:247
    if child ~= 220
        if ~isempty(mat{child,t_q}) && ~isempty(mat{child,t_q}{prova,iOS}) && ~isempty(azimuth_clean{child,1})
                [norm_x_fftAZ{child,1},f_xAZ{child,1}]= get_freq(azimuth_clean{child,1},fs, display);
                 norm_fftAZ{child,1}=norm_x_fftAZ{child,1}(find(f_xAZ{child,1}<10),1);
                 fAZ{child,1}=f_xAZ{child,1}(f_xAZ{child,1}<10);

                [ampiezza_picchiAZ{child,1}, posizione_picchiAZ{child,1}, ampiezza_bandaAZ(child,1),...
                    ampiezza_bandaAZ_LD(child,1),energia_10AZ(child,1)] = contenuto_frequenza_LD (norm_fftAZ{child,1}, fAZ{child,1},...
                    soglia_banda);
                if ~isempty(ampiezza_picchiAZ{child, 1})
                    if size(ampiezza_picchiAZ{child,1},1)==1
                        ampiezza_primo_picco_az(child,1)=ampiezza_picchiAZ{child, 1}(1,1);
                        ampiezza_secondo_picco_az(child,1)=NaN; % LD queste righe non servivano, avevate inizializzato
                        posizione_primo_picco_az(child,1)=posizione_picchiAZ{child, 1}(1,1);
                        posizione_secondo_picco_az(child,1)=NaN;
                    else
                        ampiezza_primo_picco_az(child,1)=ampiezza_picchiAZ{child,1}(1,1);
                        ampiezza_secondo_picco_az(child,1)=ampiezza_picchiAZ{child,1}(2,1);
                        posizione_primo_picco_az(child,1)=posizione_picchiAZ{child,1}(1,1);
                        posizione_secondo_picco_az(child,1)=posizione_picchiAZ{child,1}(2,1);
                    end
                end
        end
    end
end

%% contenuto in frequenza altitude

clc 
close all

ampiezza_bandaAL=ones*NaN(size(new_alt,1),size(new_alt,2));
energia_10AL=ones*NaN(size(new_alt,1),size(new_alt,2));
ampiezza_primo_picco_al= NaN*ones(size(mat,1),1);
ampiezza_secondo_picco_al= NaN*ones(size(mat,1),1);
posizione_primo_picco_al= NaN*ones(size(mat,1),1);
posizione_secondo_picco_al= NaN*ones(size(mat,1),1);

ampiezza_bandaAL_LD=NaN(size(new_alt,1),size(new_alt,2));

fs= 250;
soglia_banda= 0.05;
display=0;
for child=1:247
    if child ~= 220
         % LD aggiunto controllo all'if perché NaN non è vuoto
        if ~isempty(mat{child,t_q}) && ~isempty(mat{child,t_q}{prova,iOS}) && ~isempty(new_alt{child,1}) && length(new_alt{child,1})>1
                [norm_x_fftAL{child, 1},f_xAL{child, 1}]= get_freq(new_alt{child,1},fs, display);
                 norm_fftAL{child,1}=norm_x_fftAL{child,1}(find(f_xAL{child,1}<10),1);
                 fAL{child,1}=f_xAL{child,1}(f_xAL{child,1}<10);

                 % LD non so se era capitato anche a voi, ma ho trovato
                 % qualcuno per cui l'angolo non variava mai, quindi la
                 % frequenza era 0, quindi non trovava picchi
                if nanstd(norm_x_fftAL{child, 1}) > 0
                 [ampiezza_picchiAL{child,1}, posizione_picchiAL{child,1}, ampiezza_bandaAL(child,1),...
                    ampiezza_bandaAL_LD(child,1),energia_10AL(child,1)] = contenuto_frequenza_LD (norm_fftAL{child,1}, fAL{child,1},...
                    soglia_banda);
                else
                    ampiezza_picchiAL{child,1} = NaN;
                    posizione_picchiAL{child,1} = NaN;
                end
                if ~isempty(ampiezza_picchiAL{child, 1})
                     if size(ampiezza_picchiAL{child,1},1)==1
                        ampiezza_primo_picco_al(child,1)=ampiezza_picchiAL{child, 1}(1,1);
                        ampiezza_secondo_picco_al(child,1)=NaN;
                        posizione_primo_picco_al(child,1)=posizione_picchiAL{child, 1}(1,1);
                        posizione_secondo_picco_al(child,1)=NaN;
                   else
                        ampiezza_primo_picco_al(child,1)=ampiezza_picchiAL{child,1}(1,1);
                        ampiezza_secondo_picco_al(child,1)=ampiezza_picchiAL{child,1}(2,1);
                        posizione_primo_picco_al(child,1)=posizione_picchiAL{child,1}(1,1);
                        posizione_secondo_picco_al(child,1)=posizione_picchiAL{child,1}(2,1);
                     end
                end
        end
    end
end

%% steering law
%ATTENZIONE: IMPORTARE ANCHE LA TABELLA DELLA SIGNIFICANCE
clc
close all

% load sign_levels_r

setting=3;

alpha=0.05;

viz_regression=0;
R2=NaN*ones(size(mat,1),1);
IP=NaN*ones(size(mat,1),1);
RMSE=NaN*ones(size(mat,1),1);
significant=NaN*ones(size(mat,1),1);
global_MT=NaN*ones(size(mat,1),1);

for child=1:size(es_iOS_t_q,1)
    for prova= 1:15
        pos=1;
        if ~isempty(es_iOS_t_q{child,prova})     
                for indice=1: size(es_iOS_t_q{child, prova},1)
                    if ~isnan(es_iOS_t_q{child, prova}(indice, 1))
                        es_SAT{child, prova}(pos,1)= es_iOS_t_q{child, prova}(indice,1);
                        es_SAT{child, prova}(pos,2)= es_iOS_t_q{child, prova}(indice,2);
                        es_SAT{child, prova}(pos,3)= es_iOS_t_q{child, prova}(indice,3);
                        pos=pos+1;
                    end
                end
            MT(child, prova) = get_MT(es_SAT{child,prova}(:,1));
            settings{child, prova} = mat{child,t_q}{prova, setting};
            ID (child, prova)= get_ID(es_SAT{child, prova},settings{child, prova});
              
        end
    end
end

for child=1:size(mat,1)
       for prova = 1:15
          if ~isempty(ID(child,prova))
            [R2(child,1),IP(child,1),RMSE(child,1),significant(child,1),global_MT(child,1)]...
                = steering_law(ID(child,:),MT(child,:),significance,alpha,viz_regression);
          end
       end
end



%% is_missing feature
featureTQ=[mean_speed, max_speed, numero_picchi, varianza_alt, varianza_az, Tsottosoglia,ampiezza_bandaAL,...
    ampiezza_bandaP, ampiezza_bandaAZ, ampiezza_bandaV,ampiezza_primo_picco_al, ampiezza_primo_picco_az, ...
    ampiezza_primo_picco_p, ampiezza_primo_picco_v, ampiezza_secondo_picco_al, ampiezza_secondo_picco_az,...
    ampiezza_secondo_picco_p,ampiezza_secondo_picco_v,energia_10AL, energia_10AZ, energia_10P, energia_10V,...
    posizione_primo_picco_al, posizione_primo_picco_az,posizione_primo_picco_p, posizione_primo_picco_v,...
    posizione_secondo_picco_al, posizione_secondo_picco_az,posizione_secondo_picco_p, posizione_secondo_picco_v];

for f=1:size(featureTQ,2)   
    [vuoti,perc_vuoti]= is_missing_feature (featureTQ(:,f));
    VUOTI(:,f)=vuoti;
    PERC_VUOTI(1,f)=perc_vuoti;
end
h=heatmap(VUOTI);





