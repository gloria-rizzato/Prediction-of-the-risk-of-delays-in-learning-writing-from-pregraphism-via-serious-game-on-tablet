function [ Pdim, Hdim]= disctwo_cont_outlier(feature,column,table)

[H,P]=lillietest(feature);

contA=1;
contN=1;
for child=1:size(feature,1)
    
    %se non c'è l'informazione nel file excell, metto NaN alla feature di
    %quel bambino e alla riga vuota del file excell
    if isempty(table(child,column))
        feature(child)=NaN;
        table(child,column)=NaN;
        
        %se la colonna alla riga childesima contiene 0, salvo il valore della
        % feature chialdesima in feature_N
        
    else if table(child,column)==0
            feature_N (contN)= feature(child);
            contN=contN+1;
        % se la colonna alla riga childesima contiene invece 1,
        %salvo il valore della feature childseima in feature_A
    else 
            feature_A(contA)=feature(child);
            contA=contA+1;
        end
    end 
end 


if P<=0.05 %rifiuto l'ipotesi= non è normale 
    
    %eseguo ranksum test 
    [Pdim,Hdim]=ranksum(feature_A,feature_N);
end
if P>0.05 % non rifiuto l'ipotesi= è normale 
    
    %eseguo ttest2
    [Hdim,Pdim]=ttest2(feature_A,feature_N);
end 
end 