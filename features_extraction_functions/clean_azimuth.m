function [azimuth] = clean_azimuth(azimuth)
% INPUT
%     vettore azimuth 
% OUTPUT
%     se l'azimuth è bimodale, lo riporto tutto a una delle due distribuzioni
for k=1:size(azimuth,1)
    soglia_azimuth_pos = nanmin(azimuth(azimuth(k) > (nanmin(azimuth) + range(azimuth)/2)));
    media_azimuth_alta = nanmean(azimuth(azimuth(k) >= soglia_azimuth_pos));
    media_azimuth_bassa = nanmean(azimuth(azimuth(k) <= soglia_azimuth_pos));
    std_azimuth_alta = nanstd(azimuth(azimuth(k) >= soglia_azimuth_pos));
    std_azimuth_bassa = nanstd(azimuth(azimuth(k) <= soglia_azimuth_pos));

    if (media_azimuth_alta - 3*std_azimuth_alta) - (media_azimuth_bassa + 3*std_azimuth_bassa) > 0
        azimuth(azimuth(k) >= soglia_azimuth_pos) = azimuth(azimuth(k) >= soglia_azimuth_pos) - nanmax(azimuth);
    end
end
end