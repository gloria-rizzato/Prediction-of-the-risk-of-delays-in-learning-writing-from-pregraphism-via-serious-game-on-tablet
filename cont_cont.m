function [ Plillie, rho, p_value ]= cont_cont(feature, anno, display)

%funzione che valuta la significatività del fattore confondente continuo su
%feature continua

%INPUT
%feture
%fattore confondente continuo
%display se si vuole vedere il boxplot

if display
    figure()
    boxplot(feature)
end

out= isoutlier(feature);
feature2= feature(~out);
anno= anno(~out);

%%la variabile di stratificazione è distribuita normalmente?
[H,Plillie]=lillietest(feature2);

if Plillie <= 0.05 %vuol dire che la feature non è distribuita normalmente (rifiuto ipotesi)
     
    %correlazione di Spearman
    [rho, p_value]= corr(anno, feature2, 'Type', 'Spearman', 'rows', 'complete');
else 
    %correlazione di Pearson (quindi feature normale)
    
    [rho, p_value]= corr(anno, feature2, 'Type', 'Pearson', 'rows', 'complete');
end
end

    
   
    

    

