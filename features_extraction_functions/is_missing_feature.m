function [vuoti,perc_vuoti]=is_missing_feature(feature)
%feature è una matrice dove per colonne ci sono le feature e per righe ci
%sono le osservazioni

% if size(feature,2)>size(feature,1)
%     vuoti=zeros(1,size(feature,2)); %feature messe sulla riga
%     cont=0;
%     for child=1:size(feature,2)
%         if isnan(feature(child))==1 || isempty(feature(child))==1
%             vuoti(child)=1;
%             cont=cont+1;
%         end
%     end
%     perc_vuoti=(cont/size(feature,2))*100;  
%else 

    vuoti=zeros(size(feature,1),1); %feature messe sulla colonna
    cont=0;
    for child=1:size(feature,1)
        if isnan(feature(child,:))% || isempty(feature(child,1))
            vuoti(child,1)=1;
            cont=cont+1;
        end
    end
    perc_vuoti=(cont/size(feature,1))*100;
end
