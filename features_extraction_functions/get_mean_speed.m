function [mean_speed, speed_filt] = get_mean_speed (speed, cutoff)
% INPUT
%     mat: matrice con le seguenti colonne
%     1: tempo
%     2: posizione x
%     3: posizione y
%     cutoff: frequenza di taglio (passabasso)
% OUTPUT
%     velocità media

%speed = get_speed(mat);

speed_filt = lowpass(speed,cutoff,250); 
mean_speed = nanmean(speed_filt);
end


