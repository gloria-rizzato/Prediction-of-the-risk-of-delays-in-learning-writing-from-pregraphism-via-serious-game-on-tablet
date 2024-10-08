function [max_speed]=get_max_speed(speed)

%   INPUT
%       speed: matrice con righe i bambini e colonne le velocita�dei tre
%       livelli (senza i NaN)

%   OUTPUT
%       max_speed: matrice con righe i bambini colonne velocita� massima
%       per ogni esecuzione

% LD: deve essermi sfuggita, ma non fa quello che ci aspettiamo: quando
% avevo parlato di prendere il 10%, intendevo il pi� alto e mediavo, non il
% primo 10% (come avete fatto voi) propongo qui la mia soluzione

%speed_filt = lowpass(speed,cutoff,250); COMMENTO perch� la speed che passo
%� gi� filtrata
speed_th = nanmin(speed) + range(speed).*0.9;
speed_high = speed(speed > speed_th);
max_speed = nanmedian(speed_high);



end
 