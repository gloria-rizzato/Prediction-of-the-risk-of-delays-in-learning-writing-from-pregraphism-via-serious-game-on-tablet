function [norm_x_fft,f_x] = get_freq (signal,fs,display)
% INPUT
%     signal: segnale di cui voglio calcolare la trasformata
%     fs: frequenza di campionamento
%     display: se voglio visualizzare
% OUTPUT
%     norm_x_fft: valore assoluto della trsformata
%     f_x: frequenze a cui la calcolo (periodica)

% tolgo la continua
signal = detrend(signal);

N = length(signal); % numero di campioni del segnale
x_fft = fft(signal); % trasformata di fourier
norm_x_fft = abs(x_fft/N*2);

f_x = [0:fs/N:fs-1/N]'; 

if display
    plot(f_x(1:ceil(N/2)),norm_x_fft(1:ceil(N/2)));
    hold on
    plot([0 f_x(ceil(N/2))],[0 0])
    xlabel('frequenza [Hz]')
    ylabel('ampiezza della FFT')
end
end