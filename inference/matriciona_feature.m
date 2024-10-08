%creo la matrice di feature togliendo i bambini problematici e sistemando
%con mediana (vin con velocità media, vout non taccata, da fare
%regressione)
clearvars -except feature_grezze 
clc

for child=1:82
        feature_new1= feature_grezze(1:82,:);
end

for child=84:90
    feature_new2= feature_grezze(84:90,:);
end

for child=92:114
    feature_new3= feature_grezze(92:114,:);
end

for child=116:126
    feature_new4= feature_grezze(116:126,:);
end

for child=129:206
    feature_new5= feature_grezze(129:206,:);
end

for child=208:247
    feature_new6= feature_grezze(208:247,:);
end

feature_grezze_2= [feature_new1;feature_new2; feature_new3; feature_new4; feature_new5; feature_new6 ];


%%
%metto la mediana 

for child=1:size(feature_grezze_2, 1)
    for feature=1: size(feature_grezze_2,2)
        if feature~=106 && feature~=107
            if isnan(feature_grezze_2(child, feature))
                mediana_feature= nanmedian(feature_grezze_2(:,feature));
                feature_grezze_2(child, feature)= mediana_feature;
            end
        end
    end
end

%% metto la velocità media in vin in tunnel quadrato

feature= 106; %feature vin
feature_meanspeed= 79;

for child=1:size(feature_grezze_2,1)
    if isnan(feature_grezze_2(child, feature))
        feature_grezze_2(child, feature)= feature_grezze_2(child, feature_meanspeed);
    end
end








