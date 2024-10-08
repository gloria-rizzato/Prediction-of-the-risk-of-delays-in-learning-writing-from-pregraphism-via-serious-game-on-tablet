function [counter1,counter2]= get_numero_errori (cross_correct_ele,counter1,counter2)

%counter1, counter2 sono contatori che vanno inizializzati a zero 
% all'interno del for che cicla i bambini, e prima del for che cicla le prove 


%calcolo il numero di errori totali di un bambino 
for c=1:3
    if ~isempty(cross_correct_ele)
        if cross_correct_ele(1,c)~=1
            counter1=counter1+1;
        end
    end
end

%calcolo il numero di esecuzioni per bambino con almeno un errore
if ~isempty(cross_correct_ele)
    errori= find(cross_correct_ele(1,:)~=1);
               if length(errori)>=1
                   counter2=counter2+1;
               end
end

        
end





