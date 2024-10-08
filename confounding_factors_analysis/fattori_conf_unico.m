% analisi dei fattori confondenti


close all
clc
%clearvars -except feature Caratterizzazioneall

caratt_new= Caratterizzazioneall([1:82 84:90 92:114 116:126 129:206 208:247], [3:end]);


%% genere
close all 
clc

Pfattore_genere= zeros(1,138);
fattore=5;
for f=1:size(feature,2)
    if f== 104 || f==135
       [tab,chi2,P] = crosstab(feature(:,f),caratt_new(:,fattore));
    else     
        [P, H] = disctwo_cont(feature(:,f), fattore, caratt_new);
    end
    if isnan(P)
        [P,H]= disctwo_cont_outlier(feature(:,f), fattore, caratt_new);
    end
 
    Pfattore_genere(f)=P;
end

%% madrelingua
close all
clc

fattore=6;
for f=1:size(feature,2)
    if f== 104 || f==135
        [tab,chi2,P] = crosstab(feature(:,f),caratt_new(:,fattore));
    else     
        [P, H] = disctwo_cont(feature(:,f), fattore, caratt_new);
    end
    if isnan(P)
        [P,H]= disctwo_cont_outlier(feature(:,f), fattore, caratt_new);
    end
    
    Pfattore_madrelingua(f)=P;
end

%% dimestichezza tablet

close all
clc

Pfattore_dimestichezza=zeros(1, 138);
fattore=8;

for f=1:size(feature,2)
    if f== 104 || f==135
      [tab,chi2,P] = crosstab(feature(:,f),caratt_new(:,fattore));

    else     
    [P, H] = disctwo_cont(feature(:,f), fattore, caratt_new);
    end
    if isnan(P)
        [P,H]= disctwo_cont_outlier(feature(:,f), fattore, caratt_new);
    end 
    Pfattore_dimestichezza(f)=P;
end

%% mano dominante: attenzione al ciclo for! Fare scorrere f non tutta insieme, altrimenti stampa troppe fig
close all
clc

mano_dominante=NaN(size(caratt_new,1),1);
lateralita=NaN(size(caratt_new,1),1);
for child=1:241
    if ~isempty(caratt_new(child,3))
        mano_dominante(child)=caratt_new(child,3);
        lateralita(child)=caratt_new(child,4);
    end
end
mano_dominante(lateralita==1)=2;

for f=1:size(feature,2)
    if f== 104 || f==135
       [tab,chi2,P] = crosstab(feature(:,f), mano_dominante);
    else    
    [P] = discthree_cont(feature(:,f), mano_dominante);
    end
    if isnan(P)
        [P]= discthree_cont_outlier(feature(:,f), mano_dominante);
    end 
    Pfattore_manodominante(f)=P;
end

%% età

%fare andare prima eta!


close all
clc

display=0;
Pfattore_eta=zeros(1,138);
Rhofattore_eta=zeros(1, 138);

for f=1:size(feature,2)
    if f~= 104 && f~=135
         [ Plillie, rho, P ]= cont_cont(feature(:,f), anno, display);
         
    else
        [P, H] = disctwo_cont_eta(anno, feature(:,f));
         if isnan(P)
              [P,H]= disctwo_cont_eta_outlier(anno, feature(:,f));
         end
             
    end
    
    if isnan(P)
        [ Plillie, rho, P ]= cont_cont_outlier(feature(:,f), anno, display);
    end 
    
    if f~= 104 && f~=135
        Pfattore_eta(f)=P;
        Rhofattore_eta(f)= rho;
    else
        Pfattore_eta(f)=P;
        Rhofattore_eta(f)= NaN;
    end
        
end 

%% trasporto in excel Pfattore
close all
clc 

Pfattore= [Pfattore_genere; Pfattore_madrelingua; Pfattore_dimestichezza; Pfattore_manodominante; Pfattore_eta];


xlswrite('fatt_conf_matrice_.xls',Pfattore);

%% percentuali fattori confondenti


for row=1:size(Pfattore,1)
    cont=0;
    for col=1:size(Pfattore,2)
        if Pfattore(row, col)<0.05
            cont=cont+1;
            num(row)=cont;
        end
    end
    percentuale(row)= (num(row)/138)*100;
end

