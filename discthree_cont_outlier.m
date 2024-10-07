function [ Pmano, c, means, H ]= discthree_cont_outlier(feature,mano_dominante)


[H,P]=lillietest(feature);

for child=1:size(feature,1)   
    %se non c'è l'informazione nel file excell, metto NaN alla feature di
    %quel bambino e alla riga vuota del file excell
    if isempty(mano_dominante(child))
        feature(child)=NaN;
        mano_dominante(child)=NaN;
    end             
end 


    if P<0.05 %rifiuto l'ipotesi= non è normale 
        %eseguo kruskal wallis test 
        [Pmano,anovatabmano, statsmano]=kruskalwallis(feature,mano_dominante);
    end
    if P>=0.05 % non rifiuto l'ipotesi= è normale 
        %eseguo one-way anova
        [Pmano,anovatabmano, statsmano]=anova1(feature,mano_dominante);
    end 
    
    if Pmano<0.05
        [c,means,H,gnames] = multcompare(statsmano,'CType','bonferroni');
        [gnames(c(:,1)), gnames(c(:,2)), num2cell(c(:,3:6))];
    end
end 
    