%% normalization
 for f=1:size(feature,2)
        [norm_feature(:,f),~, ~,~,~]= scaling_normalize (feature(:,f));

%     subplot(13,11,f)
%     histogram(norm_feature(:,f))
 end
 
 rischio_new= Rischio([1:82 84:90 92:114 116:126 129:206 208:247], [3]);
 norm_feature(:,139)= rischio_new;
 
%% standardization
    
for f=1:size(feature,2)
        [stand_feature(:,f),~, ~,~,~]= scaling_stand (feature(:,f));

%     subplot(13,11,f)
%     histogram(stand_feature(:,f))
 end
 
rischio_new= Rischio([1:82 84:90 92:114 116:126 129:206 208:247], [3]);
stand_feature(:,139)= rischio_new;
