function [speed] = get_speed(mat)
% INPUT
%     matrice con le seguenti colonne
%     1: tempo
%     2: posizione x
%     3: posizione y
% OUTPUT
%     vettore velocità
   
% smooth data with 5-point moving average
posx = smooth(mat(:,2));
posy = smooth(mat(:,3));

speed = [];
speed(1,1) = 0;
for pt = 2 : size(mat,1)
    if posx(pt)~= NaN  
    speed(pt,1) = norm([posx(pt) posy(pt)] - [posx(pt-1) posy(pt-1)]) / (mat(pt,1) - mat(pt-1,1));
    % if adjacent point have the same coordinate due to bad time or space
    % resolution, speed is not 0
    if speed(pt,1) == 0
        speed(pt,1) = speed(pt - 1,1);
    end
    end
end
speed(1,1) = speed(2,1); % to preserve vector length

% remove peaks due to pen up
% [~,out] = rmoutliers(speed); 
% speed(out,1) = 0;

% SE VOLETE FARE DIRETTAMENTE UN PASSABASSO, POTETE AGGIUNGERE ALLA 
% FUNZIONE IL PARAMETRO cutoff IN INPUT E DECOMMENTARE QUI
% speed = lowpass(speed,cutoff,250);
end