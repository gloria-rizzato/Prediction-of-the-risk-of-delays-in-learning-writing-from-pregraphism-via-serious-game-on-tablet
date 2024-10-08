function [ampiezza_picchi, posizione_picchi, ampiezza_banda, ampiezza_LD, energia_10] = contenuto_frequenza_LD (norma, freq,soglia_banda)

% LD se non lo è già, normalizzo, in modo che la soglia sia una percentuale
norma = norma/nanmax(norma);

[ampiezza_picchi,posizione_picchi] = findpeaks(norma, freq,'SortStr', 'descend','NPeaks', 2);

% metodo per trovare l'ampiezza della banda di frequenza sopra a una certa soglia 
%%con pressione, altitude e azimuth_clean ci restituisce per ogni bambino-prova sempre 10 (anche se
% dal grafico non risulta così)

norma = smooth(norma,20); % LD media mobile per ridurre rumore

% LD provo con mia per confronto

ampiezza_LD_idx = find(norma > soglia_banda,1,'last'); % ultimo punto sopra soglia
if freq(ampiezza_LD_idx) > 10
    ampiezza_LD_idx = find(freq >= 10,1); % primo punto a freq >= 10
end
ampiezza_LD = freq(ampiezza_LD_idx);

 fine_banda=find(norma<soglia_banda);
%abbiamo notato che fine_banda (contenente tutti gli indici corrispondenti ai valori di norm_x sotto
%alla soglia) presenta sempre almeno l'indice 1 (perchè appunto la norm_x
%parte sempre da zero) 
%-> se fine banda contiene solo un valore (questo sarà = 1)  abbiamo
%dedotto che all'interno dell'intervallo 0-10Hz la norm_x non passi mai
%sotto al valore soglia e quindi la banda sia ampia 10Hz.
%-> succede anche che fine_banda contenga solo due valori (il primo sempre = 1)
%e nel caso in cui il secondo sia =2, abbiamo pensato si ricadesse sempre
%nel caso di prima di ampiezza banda =10Hz(anche se commettiamo
%un'imprecisione) -----------------------> per questo motivo e per il fatto
%che in pressione, altitude e azimuth_clean risulti sempre =10 (anche
%alzando la soglia) abbiamo proposto un altro metodo con booleano qui sotto
if size(fine_banda,1)==1 || (size(fine_banda,1)==2 && fine_banda(2,1)==2)
    ampiezza_banda=10;
else
    if  fine_banda(2,1)==2
        ampiezza_banda=freq((fine_banda(3,1))-1,1); %qui prendiamo come ampiezza banda la frequenza 
        %corrispondente alla posizione prima di quella in cui norm_x passa sotto alla soglia per la 
        %prima volta (nel caso particolare che rientra negli if
        %-> al terzo posto di fine_banda, altrimenti al secondo
        %posto come nell'else)
    else
        ampiezza_banda=freq((fine_banda(2,1))-1,1);                   
    end
end

%l'alternativa del booleano ci sembra scritta correttamente ma quando la si chiama nello script, 
% - nel caso in cui metto ampiezza_banda (calcolato come prima frequenza sopra alla banda - prima frequenza che 
%   che ritorna sotto alla banda) dentro al ciclo -> ritorna come errore che non riconosce la variabile fine_banda
% - nel caso in cui lo metto fuori -> ritorna che la funzione non ottiene
%   come output (come dovrebbe) la variabile ampiezza_banda
%%norm_x è si sviluppa su una riga per ogni bambino-prova, invece le
%%frequenze associate si sviluppano su una colonna per ogni b-p

%     sopra=0; %inizia sempre sotto soglia
%       c=0; 
%     for pos=1:size(norma,2)
%          if c<1 %con questa condizione sull'indice faccio fermare il
%                   %ciclo alla prima volta che norm_x ritorna sotto alla soglia
%             if sopra==0 && norma(1,pos)>soglia_banda
%                 sopra==1;
%                 f_inizio=freq(pos,1);
%             end
%             if sopra==1 && norma(1,pos)<soglia_banda
%                 sopra==0
%                 f_fine=freq(pos,1);
% % %                 ampiezza_banda=f_fine-f_inizio;
%                 c=c+1; 
%             end
%          end
%     end
% % %        ampiezza_banda=f_fine-f_inizio;
        
    
 energia_10= 0.004*sum(norma.^2);
end