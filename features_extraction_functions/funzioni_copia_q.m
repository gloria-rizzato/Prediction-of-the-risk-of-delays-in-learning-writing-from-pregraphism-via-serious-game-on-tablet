% applico funzioni a copia_quadrato

clc
clearvars -except mat 
iOS=1;

%format long
quadrato=2;
iOS=1;
p_x=2;
p_y=3;
cutoff=10;

for child=1 : size(mat,1)
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child, quadrato}{livello, iOS})
            bambino{child,livello}=mat{child, quadrato}{livello, iOS}(:,:);
        end
    end
end

%% get speed

for child=1 : size(bambino,1)
    for livello=1:3
        if ~isempty(bambino{child,livello}) 
             speed{child,livello}= get_speed(bambino{child,livello}(:,[1 2 3]));
             time{child,livello}=bambino{child,livello}(:,1);
             azimuth{child,livello}=bambino{child,livello}(:,6);
             altitude{child,livello}=bambino{child,livello}(:,5);
             pressione{child,livello}=bambino{child,livello}(:,4);
        else 
             speed{child,livello}= NaN;
             time{child,livello}= NaN;
             azimuth{child,livello}= NaN;
             altitude{child,livello}= NaN;
        end
    end
end

%% get_mean_speed
%il filtro lowpass alla speed viene applicatouna sola volta in meanspeed(ottenendo speedCQ) e
%poi utilizzo questa variabile per tutto il resto dello script

mean_speed= NaN(size(speed,1),3);

for child=1:247
    for livello=1:3
      if ~isnan(speed{child,livello})
          [mean_speed(child,livello), speedCQ{child,livello}]=get_mean_speed(speed{child,livello},cutoff);
      end 
    end 
end

%% get_max_speed

max_speed= NaN(size(speedCQ,1),3);

for child=1 : size(speedCQ,1)
     for livello=1:3
        if ~isnan(speedCQ{child,livello}) 
             [max_speed(child,livello)]=get_max_speed(speedCQ{child,livello});
        end
     end
end

%% get_std velocità

std_speed= NaN(size(speedCQ,1),3);

for child=1 : size(speedCQ,1)
     for livello=1:3
        if ~isempty(speedCQ{child,livello})
            std_speed(child,livello)= get_std_speed(speedCQ{child,livello});
        end
    end     
end

%% picchi di velocità 

numero_picchi= NaN(size(speedCQ,1),3);

for child=1 : size(speedCQ,1)
    for livello=1:3
        if ~isempty(speedCQ{child,livello})
        numero_picchi(child,livello)= get_SNvpd(speedCQ{child,livello});
        end
    end
end

%% clean_azimuth 

for child=1: size(mat,1)
     for livello=1:3
        if ~isempty(azimuth{child,livello})
            azimuth_clean{child,livello}=clean_azimuth(azimuth{child,livello});
        end
    end
end


%% tilt: ci aspettiamo che la varianza di azimuth sia elevata per tutti i bambini, mentre per i disgrafici bassa..
% infatti essi mantengono costante l'azimuth (contrario per altitude)

for child=1:size(azimuth_clean,1)
    for livello=1:3
    varianza_az(child,livello)= var(azimuth_clean{child,livello});
    end
end


for child=1: size(altitude,1)
    for livello=1:3
    if isempty (altitude{child,livello})
        altitude{child,livello}= NaN;
    end
    varianza_alt(child,livello)= var(altitude{child,livello});
    end
end

%% tempo tratto con velocità sottosoglia

Tsottosoglia = NaN(size(speedCQ,1),3);

for child=1: size(mat,1)
    for livello=1:3
         if ~isempty(speedCQ{child,livello}) && ~isempty(time{child,livello})
            [Tsottosoglia(child,livello)]=get_sottosoglia(speedCQ{child,livello},time{child,livello}); 
        end
    end
end

%% airtime

tempo_in_aria = NaN(size(mat,1),3); 

for child=1 : size(mat,1)
    for livello=1:3
        if ~isempty(mat{child,quadrato})&& ~isempty(mat{child, quadrato}{livello, iOS})
            bambino_totale{child,livello}=mat{child, quadrato}{livello, iOS}(:,[1 4]);
            tempo_in_aria(child,livello)= get_airtime(bambino_totale{child,livello});
        end
    end 
end 

%% centroide

for child=1:size(mat,1)
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello, iOS})
            [centroide_x(child,livello), centroide_y(child,livello)]= get_centro(bambino{child,livello});
        else 
            centroide_x(child, livello)= NaN;
            centroide_y(child, livello)= NaN;
        end
    end
end

%% contenuto in frequenza velocità
ampiezza_bandaV=NaN(size(speedCQ,1),size(speedCQ,2));
energia_10V=NaN(size(speedCQ,1),size(speedCQ,2));
ampiezza_primo_picco_v= NaN(size(mat,1),3);
%ampiezza_secondo_picco_v= NaN(size(mat,1),3);
posizione_primo_picco_v= NaN(size(mat,1),3);
%posizione_secondo_picco_v= NaN(size(mat,1),3);


fs= 250;
soglia_banda= 0.1;
display=0;
for child=1:247
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello, iOS})
            [norm_x_fftV{child, livello},f_xV{child, livello}]= get_freq (speedCQ{child, livello},fs, display);
             norm_fftV{child,livello}=norm_x_fftV{child,livello}(find(f_xV{child,livello}<10),1);
             fV{child,livello}=f_xV{child,livello}(f_xV{child,livello}<10);
                
            [ampiezza_picchiV{child,livello}, posizione_picchiV{child,livello}, ampiezza_bandaV(child,livello),...
                energia_10V(child,livello)] = contenuto_frequenza (norm_fftV{child,livello}, fV{child,livello},...
                soglia_banda);
            if ~isempty(ampiezza_picchiV{child, livello})
                ampiezza_primo_picco_v(child,livello)=ampiezza_picchiV{child, livello}(1,1);
                %ampiezza_secondo_picco_v(child,livello)=ampiezza_picchiV{child, livello}(2,1);
                posizione_primo_picco_v(child,livello)=posizione_picchiV{child, livello}(1,1);
                %posizione_secondo_picco_v(child,livello)=posizione_picchiV{child, livello}(2,1);
                
            end
            
        end
    end
end

%% contenuto in frequenza pressione
ampiezza_bandaP=NaN(size(pressione,1),size(pressione,2));
energia_10P=NaN(size(pressione,1),size(pressione,2));
ampiezza_primo_picco_p= NaN(size(mat,1),3);
%ampiezza_secondo_picco_p= NaN(size(mat,1),3);
posizione_primo_picco_p= NaN(size(mat,1),3);
%posizione_secondo_picco_p= NaN(size(mat,1),3);



fs= 250;
soglia_banda= 0.1;
display=0;
for child=1:247
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello,iOS})
            [norm_x_fftP{child, livello},f_xP{child, livello}]= get_freq(pressione{child,livello},fs, display);
             norm_fftP{child,livello}=norm_x_fftP{child,livello}(find(f_xP{child,livello}<10),1);
             fP{child,livello}=f_xP{child,livello}(f_xP{child,livello}<10);
                
            [ampiezza_picchiP{child,livello}, posizione_picchiP{child,livello}, ampiezza_bandaP(child,livello),...
                energia_10P(child,livello)] = contenuto_frequenza (norm_fftP{child,livello}, fP{child,livello},...
                soglia_banda);
                if ~isempty(ampiezza_picchiP{child, livello})
                    if size(ampiezza_picchiP{child,livello},1)==1
                        ampiezza_primo_picco_p(child,livello)=ampiezza_picchiP{child, livello}(1,1);
                        %ampiezza_secondo_picco_p(child,livello)=NaN;
                        posizione_primo_picco_p(child,livello)=posizione_picchiP{child, livello}(1,1);
                        %posizione_secondo_picco_p(child,livello)=NaN;
                    else
                        ampiezza_primo_picco_p(child,livello)=ampiezza_picchiP{child, livello}(1,1);
                        %ampiezza_secondo_picco_p(child,livello)=ampiezza_picchiP{child, livello}(2,1);
                        posizione_primo_picco_p(child,livello)=posizione_picchiP{child, livello}(1,1);
                        %posizione_secondo_picco_p(child,livello)=posizione_picchiP{child, livello}(2,1);
                    end
                end
        end
    end
end

%% contenuto in frequenza azimuth
ampiezza_bandaAZ=NaN(size(azimuth_clean,1),size(azimuth_clean,2));
energia_10AZ=NaN(size(azimuth_clean,1),size(azimuth_clean,2));
ampiezza_primo_picco_az= NaN(size(mat,1),3);
% ampiezza_secondo_picco_az= NaN(size(mat,1),3);
posizione_primo_picco_az= NaN(size(mat,1),3);
% posizione_secondo_picco_az= NaN(size(mat,1),3);


fs= 250;
soglia_banda= 0.1;
display=0;
for child=1:247
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello,iOS})
            [norm_x_fftAZ{child, livello},f_xAZ{child, livello}]= get_freq(azimuth_clean{child,livello},fs, display);
             norm_fftAZ{child,livello}=norm_x_fftAZ{child,livello}(find(f_xAZ{child,livello}<10),1);
             fAZ{child,livello}=f_xAZ{child,livello}(f_xAZ{child,livello}<10);
                
            [ampiezza_picchiAZ{child,livello}, posizione_picchiAZ{child,livello}, ampiezza_bandaAZ(child,livello),...
                energia_10AZ(child,livello)] = contenuto_frequenza (norm_fftAZ{child,livello}, fAZ{child,livello},...
                soglia_banda);
            if ~isempty(ampiezza_picchiAZ{child, livello})
                if size(ampiezza_picchiAZ{child,livello},1)==1
                        ampiezza_primo_picco_az(child,livello)=ampiezza_picchiAZ{child, livello}(1,1);
%                         ampiezza_secondo_picco_az(child,livello)=NaN;
                        posizione_primo_picco_az(child,livello)=posizione_picchiAZ{child, livello}(1,1);
%                         posizione_secondo_picco_az(child,livello)=NaN;
                else
                    ampiezza_primo_picco_az(child,livello)=ampiezza_picchiAZ{child,livello}(1,1);
%                     ampiezza_secondo_picco_az(child,livello)=ampiezza_picchiAZ{child,livello}(2,1);
                    posizione_primo_picco_az(child,livello)=posizione_picchiAZ{child,livello}(1,1);
%                     posizione_secondo_picco_az(child,livello)=posizione_picchiAZ{child,livello}(2,1);
                end
              
            end
            
        end
    end
end

%% contenuto in frequenza altitude
ampiezza_bandaAL=NaN(size(altitude,1),size(altitude,2));
energia_10AL=NaN(size(altitude,1),size(altitude,2));
ampiezza_primo_picco_al= NaN(size(mat,1),3);
% ampiezza_secondo_picco_al= NaN(size(mat,1),3);
posizione_primo_picco_al= NaN(size(mat,1),3);
% posizione_secondo_picco_al= NaN(size(mat,1),3);


fs= 250;
soglia_banda= 0.05;
display=0;
for child=1:247
    for livello=1:3
        if ~isnan(altitude{child,livello}) 
            [norm_x_fftAL{child, livello},f_xAL{child, livello}]= get_freq(altitude{child,livello},fs, display);
             norm_fftAL{child,livello}=norm_x_fftAL{child,livello}(find(f_xAL{child,livello}<10),1);
             fAL{child,livello}=f_xAL{child,livello}(f_xAL{child,livello}<10);
                
            [ampiezza_picchiAL{child,livello}, posizione_picchiAL{child,livello}, ampiezza_bandaAL(child,livello),...
                energia_10AL(child,livello)] = contenuto_frequenza (norm_fftAL{child,livello}, fAL{child,livello},...
                soglia_banda);
               if ~isempty(ampiezza_picchiAL{child, livello})
                   if size(ampiezza_picchiAL{child,livello},1)==1
                        ampiezza_primo_picco_al(child,livello)=ampiezza_picchiAL{child, livello}(1,1);
%                         ampiezza_secondo_picco_al(child,livello)=NaN;
                        posizione_primo_picco_al(child,livello)=posizione_picchiAL{child, livello}(1,1);
%                         posizione_secondo_picco_al(child,livello)=NaN;
                   else
                        ampiezza_primo_picco_al(child,livello)=ampiezza_picchiAL{child,livello}(1,1);
%                         ampiezza_secondo_picco_al(child,livello)=ampiezza_picchiAL{child,livello}(2,1);
                        posizione_primo_picco_al(child,livello)=posizione_picchiAL{child,livello}(1,1);
%                         posizione_secondo_picco_al(child,livello)=posizione_picchiAL{child,livello}(2,1);
                   end
                
               end
            
        end
    end
end

%% is_missing feature
featureCQ=[max_speed,mean_speed,std_speed,numero_picchi,varianza_alt,varianza_az,Tsottosoglia,tempo_in_aria,centroide_x,...
    centroide_y,ampiezza_bandaAL, ampiezza_bandaAZ, ampiezza_bandaP, ampiezza_bandaV, ampiezza_primo_picco_al, ...
    ampiezza_primo_picco_az, ampiezza_primo_picco_p, ampiezza_primo_picco_v,energia_10AL, energia_10AZ,...
    energia_10P, energia_10V, posizione_primo_picco_al, posizione_primo_picco_az, posizione_primo_picco_p, ...
    posizione_primo_picco_v];

for f=1:size(featureCQ,2)   
    [vuoti,perc_vuoti]= is_missing_feature (featureCQ(:,f));
    VUOTI(:,f)=vuoti; %tre colonne per ogni feature
    PERC_VUOTI(1,f)=perc_vuoti;
end

h=heatmap(VUOTI);





           
