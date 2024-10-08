function [centroide_x, centroide_y]= get_centro(bambino)
   centroide_x = nanmedian(bambino(:,2)); 
   centroide_y = nanmedian(bambino(:,3));
end
        