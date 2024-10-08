function [ampiezza_primo_picco, posizione_primo_picco, ampiezza_banda, energia_10] = contenuto_frequenza (norma, freq,soglia_banda)

%norma = norma/nanmax(norma);

[ampiezza_primo_picco,posizione_primo_picco] = findpeaks(norma, freq,'SortStr', 'descend','NPeaks', 2);

norma = norma/nanmax(norma);
norma = smooth(norma,20);

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
%un'imprecisione)

if ~isempty(fine_banda)
                if size(fine_banda,1)==1 || (size(fine_banda,1)==2 && fine_banda(2,1)==2)
                    ampiezza_banda=10;
                else if  fine_banda(2,1)==2
                    ampiezza_banda=freq((fine_banda(3,1))-1,1); %qui prendiamo come ampiezza banda la frequenza 
                    %corrispondente alla posizione prima di quella in cui norm_x passa sotto alla soglia per la 
                    %prima volta (nel caso particolare che rientra negli if
                    %-> al terzo posto di fine_banda, altrimenti al secondo posto come nell'else)
                    else
                    ampiezza_banda=freq((fine_banda(2,1))-1,1);                   
                    end
                end
else
    ampiezza_banda = NaN;
end   
    
 energia_10= 0.004*sum(norma.^2);
end