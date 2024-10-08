% applico funzioni a copia_quadrato

clc
clearvars -except mat %speed
iOS=1;

format long
quadrato=2;
iOS=1;
p_x=2;
p_y=3;

for child=1 : size(mat,1)
    for prova=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child, quadrato}{prova, iOS})
            bambino{child,prova}=mat{child, quadrato}{prova, iOS}(:,:);
        end
    end
end

%% get speed

for child=1 : size(bambino,1)
    for prova=1:3
        if ~isempty(bambino{child,prova}) 
             speed{child,prova}= get_speed(bambino{child,prova});
             time{child,prova}=bambino{child,prova}(:,1);
             azimuth{child,prova}=bambino{child,prova}(:,6);
             altitude{child,prova}=bambino{child,prova}(:,5);
        else % LD aggiungo perché non avete inizializzato
            speed{child,prova}= NaN;
             time{child,prova}= NaN;
             azimuth{child,prova}= NaN;
             altitude{child,prova}= NaN;
        end
    end
end

%% get_mean_speed
% LD esiste già il comando per fare matrici di NaN (applicabile anche agli
% altri casi sotto)
% mean_speed= NaN* ones(size(speed,1),3);
mean_speed= NaN(size(speed,1),3);

for child=1:247
    for prova=1:3
      if ~isempty(speed{child,prova})
          mean_speed(child,prova)=get_mean_speed(speed{child,prova}, 10);
      end 
    end 
end 

%% get_max_speed

max_speed= NaN* ones(size(speed,1),3);

% ho fatto delle modifiche alla funzione get_max_speed perché non si
% comportava come mi aspettavo
% considerando il tempo che ci mette a filtrare, sarebbe stato meglio avere
% già un vettore di v filtrata senza rifarlo, ma non serve che modifichiate
% la funzione, tanto lo fate una volta sola e poi vi salvate la feature e
% agite solo su quella

for child=1 : size(speed,1)
     for prova=1:3
        if ~isempty(speed{child,prova}) 
             [max_speed(child,prova)]=get_max_speed_LD(speed{child,prova});
        end
     end
end

%% get_std

std_speed= NaN* ones(size(speed,1),3);

% LD: sempre più convinta che sarebbe stato meglio avere già una v filtrata

for child=1 : size(speed,1)
     for prova=1:3
        if ~isempty(speed{child,prova})
            std_speed(child,prova)= get_std_speed(speed{child,prova}, 10);
        end
    end     
end

%% picchi di velocità 

numero_picchi= NaN* ones(size(speed,1),3);

for child=1 : size(speed,1)
    for prova=1:3
        if ~isempty(speed{child,prova})
            numero_picchi(child,prova)= get_SNvpd(speed{child,prova});
        end
    end
end

%% clean_azimuth 

for child=1: size(mat,1)
     for prova=1:3
        if ~isempty(azimuth{child,prova})
            azimuth_clean{child,prova}=clean_azimuth(azimuth{child,prova});
        else
           azimuth_clean{child,prova}=NaN; % LD aggiunto 
        end
    end
end


%% tilt: ci aspettiamo che la varianza di azimuth sia elevata per tutti i bambini, mentre per i disgrafici bassa..
% infatti essi mantengono costante l'azimuth (contrario per altitude)

for child=1:size(azimuth_clean,1)
    for prova=1:3
        varianza_az(child,prova)= var(azimuth_clean{child,prova});
        % LD qui ok non mettere il controllo sul NaN perché risulta già dal
        % fatto che è stato messo prima
    end
end


for child=1: size(altitude,1)
    for prova=1:3
        if isempty (altitude{child,prova})
            altitude{child,prova}= NaN;
        end
        varianza_alt(child,prova)= var(altitude{child,prova});
    end
end

%% tempo tratto con velocità sottosoglia

Tsottosoglia = NaN* ones(size(speed,1),3);

for child=1: size(mat,1)
    for prova=1:3
         if ~isempty(speed{child,prova}) && ~isempty(time{child,prova})
            [Tsottosoglia(child,prova)]=get_sottosoglia(speed{child,prova},time{child,prova}); 
        end
    end
end

%% airtime

tempo_in_aria = NaN*ones(size(mat,1),3); 

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
close all
clc

fs= 250;
soglia_banda= 0.1; % LD alzerei la soglia, altrimenti satura spesso
display=0;

% clear ampiezza_bandaV ampiezza_LD

for child=1:247
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello, iOS})
            [norm_x_fftV{child, livello},f_xV{child, livello}]= get_freq (speed{child, livello},fs, display);
             norm_fftV{child,livello}=norm_x_fftV{child,livello}(find(f_xV{child,livello}<10),1);
             fV{child,livello}=f_xV{child,livello}(f_xV{child,livello}<10);
                
             % LD ho cambiato funzione ma non ho toccato la vostra
             % internamente, ritorna solo un valore in più. Non sono sempre
             % uguali il mio e il vostro perché io se torna sopra soglia lo
             % conto
            [ampiezza_picchiV{child,livello}, posizione_picchiV{child,livello}, ampiezza_bandaV(child,livello),...
                ampiezza_LD(child,livello),energia_10V(child,livello)] = contenuto_frequenza_LD (norm_fftV{child,livello}, fV{child,livello},...
                soglia_banda);
        end
    end
end

% close all
% figure
% subplot(1,3,1)
% plot(ampiezza_bandaV(:,1),ampiezza_LD(:,1),'o')
% subplot(1,3,2)
% plot(ampiezza_bandaV(:,2),ampiezza_LD(:,2),'o')
% subplot(1,3,3)
% plot(ampiezza_bandaV(:,2),ampiezza_LD(:,2),'o')
% 
% ch = 1; lev = 1;
% figure, hold on
% plot(f_xV{ch, lev},smooth(norm_x_fftV{ch, lev},10), 'LineWidth',2)
% plot(f_xV{ch, lev},norm_x_fftV{ch, lev})
% title(num2str(ampiezza_bandaV(ch, lev)))
% yline(soglia_banda,'r')
% 
% figure
% subplot(1,3,1)
% plot(ampiezza_LD(:,1),'o')
% subplot(1,3,2)
% plot(ampiezza_LD(:,2),'o')
% subplot(1,3,3)
% plot(ampiezza_LD(:,2),'o')

%% contenuto in frequenza pressione

fs= 250;
soglia_banda= 0.1; % LD ho alzato la soglia anche qui, ma in effetti saturava meno
% se volete potete anche fare 2 feature diverse con le 2 soglie
display=0;
for child=1:247
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello,iOS})
            [norm_x_fftP{child, livello},f_xP{child, livello}]= get_freq(mat{child, quadrato}{livello,iOS}(:,4),fs, display);
             norm_fftP{child,livello}=norm_x_fftP{child,livello}(find(f_xP{child,livello}<10),1);
             fP{child,livello}=f_xP{child,livello}(f_xP{child,livello}<10);
                
            [ampiezza_picchiP{child,livello}, posizione_picchiP{child,livello}, ampiezza_bandaP(child,livello),...
                ampiezza_LD_P(child,livello), energia_10P(child,livello)] = contenuto_frequenza_LD (norm_fftP{child,livello}, fP{child,livello},...
                soglia_banda);
        end
    end
end

% figure
% subplot(1,3,1)
% plot(ampiezza_LD_P(:,1),'o')
% subplot(1,3,2)
% plot(ampiezza_LD_P(:,2),'o')
% subplot(1,3,3)
% plot(ampiezza_LD_P(:,2),'o')

%% contenuto in frequenza azimuth

fs= 250;
soglia_banda= 0.1; % LD anche per questo potreste fare entrambe le soglie
display=0;
for child=1:247
    for livello=1:3
        if ~isempty(mat{child,quadrato}) && ~isempty(mat{child,quadrato}{livello,iOS})
            [norm_x_fftAZ{child, livello},f_xAZ{child, livello}]= get_freq(azimuth_clean{child,livello},fs, display);
             norm_fftAZ{child,livello}=norm_x_fftAZ{child,livello}(find(f_xAZ{child,livello}<10),1);
             fAZ{child,livello}=f_xAZ{child,livello}(f_xAZ{child,livello}<10);
                
            [ampiezza_picchiAZ{child,livello}, posizione_picchiAZ{child,livello}, ampiezza_bandaAZ(child,livello),...
                ampiezza_bandaAZ_LD(child,livello), energia_10AZ(child,livello)] = contenuto_frequenza_LD (norm_fftAZ{child,livello}, fAZ{child,livello},...
                soglia_banda);
        end
    end
end

% figure
% subplot(1,3,1)
% plot(ampiezza_bandaAZ_LD(:,1),'o')
% subplot(1,3,2)
% plot(ampiezza_bandaAZ_LD(:,2),'o')
% subplot(1,3,3)
% plot(ampiezza_bandaAZ_LD(:,2),'o')
%% contenuto in frequenza altitude

fs= 250;
soglia_banda= 0.05;
display=0;
for child=1:247
    for livello=1:3
        if ~isnan(altitude{child,livello}) 
            [norm_x_fftAL{child, livello},f_xAL{child, livello}]= get_freq(altitude{child,livello},fs, display);
             norm_fftAL{child,livello}=norm_x_fftAL{child,livello}(find(f_xAL{child,livello}<10),1);
             fAL{child,livello}=f_xAL{child,livello}(f_xAL{child,livello}<10);
                
            [ampiezza_picchiALT{child,livello}, posizione_picchiALT{child,livello}, ampiezza_bandaALT(child,livello),...
                ampiezza_bandaALT_LD(child,livello),energia_10ALT(child,livello)] = contenuto_frequenza_LD (norm_fftAL{child,livello}, fAL{child,livello},...
                soglia_banda);
        else
            'nan'
        end
    end
end

% figure
% subplot(1,3,1)
% plot(ampiezza_bandaALT_LD(:,1),'o')
% subplot(1,3,2)
% plot(ampiezza_bandaALT_LD(:,2),'o')
% subplot(1,3,3)
% plot(ampiezza_bandaALT_LD(:,2),'o')

%% is_missing feature
featureCQ=[mean_speed,max_speed,numero_picchi,varianza_alt,varianza_az,Tsottosoglia,tempo_in_aria,centroide_x,centroide_y];
%centroide è un formato da celle invece le altre feature sono delle
%semplici matrici, ma se metto le tonde quando chiamo get_centro mi dice
%che la conversione da cella a double non è possibile
for f=1:size(featureCQ,2)   
    [vuoti,perc_vuoti]= is_missing_feature (featureCQ(:,f));
    VUOTI(:,f)=vuoti; %tre colonne per ogni feature
    PERC_VUOTI(1,f)=perc_vuoti;
end

h=heatmap(VUOTI);

% LD is_missing_feature ritorna la percentuale di bambini che non hanno
% una certa feature. Poteva essere utile anche il contrario, cioè la
% percentuale di feature che non aveva un bambino, perché si può sempre
% scegliere se eliminare il bambino o la colonna
% comunque va bene, dall'heatmap si capisce

% OTTIMO LAVORO!




           