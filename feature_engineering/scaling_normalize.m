function [scaled, max_f, min_f, mean_f, std_f]= scaling_normalize(feature)

scaled= normalize(feature,'range');
max_f=max(scaled);
min_f=min(scaled);
mean_f= nanmean(scaled);
std_f=std(scaled);
end 