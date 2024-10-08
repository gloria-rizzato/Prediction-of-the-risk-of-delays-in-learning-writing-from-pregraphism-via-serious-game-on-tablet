function [diff]=get_SNvpd(speed)

%INPUT
% speed: velocità calcolata con la funzione get_speed



%OUTPUT
% all matrice con le seguenti righe:
%       1: picchi
%       2: posizione picchi
%segnale_filtrato: velocità filtrata


%progetto il filtro di butterworth passa basso del quarto ordine (come da
%letteratura)

[B10,A10]= butter(4, 10/125, 'low');
[B5, A5]= butter(4, 5/125, 'low');

%filtro il segnale con il filtro progettato

segnale_filtrato_10=filtfilt(B10,A10,speed');%%%%%%%%%%%
segnale_filtrato_5=filtfilt(B5,A5,speed');%%%%%%%%%%%%%%

%trovo i picchi e le rispettive posizioni

[pks10, locs10]= findpeaks(segnale_filtrato_10);
[pks5, locs5]= findpeaks(segnale_filtrato_5);

%unisco in un'unica matrice picchi e posizione picchi

all_10= [pks10; locs10];
all_5= [pks5; locs5];

diff= size(all_10,2) - size(all_5,2);

end