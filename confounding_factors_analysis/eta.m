% mese e anno ---> devo settare mese_a=1 poichè Linda ha detto che
% consideriamo mese acquisizione= gennaio

close all
clc


mese_a=1;
anno_a=2020;

anno= NaN(size(caratt_new,1),1);

for child= 1: size(caratt_new)
    if ~isempty(caratt_new(child,1)) &&  ~isempty(caratt_new(child,2)) 
        if caratt_new(child,2) ~= 1
            anno(child,1)= anno_a - caratt_new(child,1) -1;
            cont= 12 - caratt_new(child,2);
            cont= cont + 1;
            cont= cont/12;
            anno(child,1)= anno(child,1) + cont;
        else
            anno(child,1)= anno_a - caratt_new(child,1);
        end
    end
end
%%
mediana= nanmedian(anno);

range_interquartile= iqr(anno,'all');


