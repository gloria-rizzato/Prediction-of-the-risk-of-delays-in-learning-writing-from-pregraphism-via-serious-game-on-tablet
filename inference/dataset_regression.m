%creo dataset per la regressione su vout=NaN
load('feature_grezze_2.mat')

%matriciona in cui tolgo le righe che presentano NaN nella colonna della
%vout (colonna 107)
ind=1;
for r=1:size(feature_grezze_2,1)
    if ~isnan(feature_grezze_2(r,107))
        feature_grezze_regr(ind,:)=feature_grezze_2(r,:);
        ind=ind+1;
    end
end

%complementare della matrice sopra per cui conservo le righe che presentano
%NaN nella colonna vout
%ciclo for diverso perchè else mi dava problemi
pos=1;
for r=1:size(feature_grezze_2,1)
    if isnan(feature_grezze_2(r,107))==1
        feature_buchi(pos,:)=feature_grezze_2(r,:);
        pos=pos+1;
    end
end

%matrice con le sole righe che presentano NaN in vout ma senza la colonna
%vout che è l'output da predirre attraverso regressione
index=1;
for c=1:size(feature_grezze_2,2)
    if c~=107
        f_buchi(:,index)=feature_buchi(:,c);
        index=index+1;
    end
end

%% applico modello
%necessario avere il modello nel workspace
clc

yfit=trainedModel.predictFcn(f_buchi);

%% inserisco valori trovati con la regressione al posto dei NaN in vout
feature_vout=feature_grezze_2;
pos=1;

for r=1:size(feature_grezze_2,1)
    if isnan(feature_grezze_2(r,107))
        feature_vout(r,107)=yfit(pos,1);
        pos=pos+1;
    end
end

