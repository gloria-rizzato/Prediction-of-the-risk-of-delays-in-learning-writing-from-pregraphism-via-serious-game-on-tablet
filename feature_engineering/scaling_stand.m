function [scaled, max_f, min_f, mean_f, std_f]= scaling_stand(feature)

scaled= normalize(feature); %normalize di default ha come metodo z-score
max_f=max(scaled);
min_f=min(scaled);
mean_f= nanmean(scaled);
std_f=std(scaled);
end 