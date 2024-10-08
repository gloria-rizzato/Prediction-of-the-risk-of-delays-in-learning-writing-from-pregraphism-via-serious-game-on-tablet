function [std_speed] = get_std_speed(speed)
% INPUT
%     bambino: matrice con le seguenti colonne
%     1: tempo
%     2: posizione x
%     3: posizione y
%     cutoff: frequenza di taglio (passabasso)
% OUTPUT
%     deviazione standard

%speed = get_speed(bambino);
%speed = lowpass(speed,cutoff,250); COMMENTO perchè passo già la speed
%filtrata
std_speed = nanstd(speed);
end