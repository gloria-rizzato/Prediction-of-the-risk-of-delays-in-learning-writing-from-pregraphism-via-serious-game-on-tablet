function airtime= get_airtime(bambino_totale)

%Input: matrice con tot righe e 2 colonne (1°tempo, 2° pressione)

%definisco onair: variabile che vale 0 se il bambino scrive, 1 se non
%scrive
%inizializzo a 0 perchè il bambino sta scrivendo (cambierà non appena 
%il bambino stacca per la prima volta la penna, diventando 1)
%è un booleano!
onair=0;  

%inizializzo a 0 il tempo totale in cui il bambino ha la penna staccata dal
%tablet
tempoTot=0;

% itero tutte le righe di bambino totale (quindi scorro tutte le pressioni)
for pos=1:size(bambino_totale,1)
    
% se onair==0(quindi fino ad adesso il bambino ha scritto) && se il valore 
%di pressione corrispondente a 'pos' vale 0 (il bambino STACCA)
%onair =1 (che significa la penna è in aria)
    if onair==0 && bambino_totale(pos,2)==0
        onair=1;
        
        timeUp= bambino_totale(pos,1); %salvo istante in cui
                                       %bimbo stacca
    end
%poi fa un secondo controllo
%deve valere che il bambino era in aria( quindi fino ad adesso onair==1) 
%ma la pressione corrispondente a 'pos' non vale più zero, quindi il
%bambino è tornato ad appoggiare la penna sul tablet
        if onair ==1 && bambino_totale(pos,2)~=0
            onair=0; %non sono più in aria
            
            timeDown=bambino_totale(pos,1); %salvo istnte in cui bimbo 
                                            %riprende a scrivere 
%eseguola differenza tra i due istanti                                            
            timeOnAir= timeDown- timeUp;
%tempoTot era a 0, ora gli sommo il nuovo intervallo; quindi diventerà di
%valore pari a tale intervallo e al prossimo for verrà aggiunto un altro
%intervallo(qualora il bambino stacchi nuovamente)
            tempoTot=tempoTot+ timeOnAir;
        end 
end 

%airtime è l'output della funzione: pari al tempo totale in aria calcolato 
airtime= tempoTot;
end
%figo perchè se ci pensate non tiene conto degli zeri finali (perchè
%calcola l'intervallo solo quando dopo una pressione nulla, questa torna ad
%essere diversa da zero 

            
        
        