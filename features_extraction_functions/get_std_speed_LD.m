function [std_speed] = get_std_speed_LD (speed,cutoff)
% INPUT
%     bambino: matrice con le seguenti colonne
%     1: tempo
%     2: posizione x
%     3: posizione y
%     cutoff: frequenza di taglio (passabasso)
% OUTPUT
%     deviazione standard

%speed = get_speed(bambino);
speed = lowpass(speed,cutoff,250);
% LD ho solo aggiunto la gestione dei NaN
std_speed = nanstd(speed);
end