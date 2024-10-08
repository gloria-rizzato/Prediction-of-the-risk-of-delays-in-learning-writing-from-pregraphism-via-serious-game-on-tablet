clearvars -except feature norm_feature stand_feature rischio_new 
clc
%% NORMALIZZAZIONE
%% correlazione feature normalizzate con rischio

clc
X= norm_feature;

for f=1:size(feature,2)
   [rho_n_rischio(f), pval_n_rischio(f)]= corr(X(:,f), X(:,139), 'Type','Spearman','Rows','complete');
end 
for r=1:size(pval_n_rischio,2)
        if pval_n_rischio(r)>0.05 % NaN quelle che correlano poco
            rho_n_rischio(r)=NaN;
        end
        if abs(rho_n_rischio(r))<0.1 
            rho_n_rischio(r)=NaN;
        end
end


figure
hP=heatmap (pval_n_rischio,'Title','heatmap norm p-value rischio');
figure
hR=heatmap(abs(rho_n_rischio),'Title','heatmap norm rho rischio');

find(~isnan(rho_n_rischio));

%tengo le feature con rho ~= NaN
feature_norm_post_rischio = norm_feature(:, [24    41    43    45    47    60    65    79    85    89    90   103   110   111   115   118   120   122   123 ...
                125   132   137   138]); 
%% correlazione tra feature

clc
Y=  feature_norm_post_rischio;

[rho_n, pval_n]=corr(Y,'Type','Spearman', 'Rows','complete');

for r=1:size(pval_n,2)
    for c=1:size(pval_n,2)
        if pval_n(r,c)>0.05
            rho_n(r,c)=NaN;
        end
    end
end 

figure
hP=heatmap (pval_n,'Title','heatmap norm p-value');
figure
hR=heatmap(abs(rho_n),'Title','heatmap norm rho');

%%
clc

rho= tril(rho_n);
w=1;
for r=1:size( rho_n,1)
    for c=1:r
        if  abs(rho_n(r,c))> 0.9
            alta_corr{w}=[r;c];
            w=w+1;
        end
    end
end
%% non serve più questo codice perchè in alta_corr abbiamo solo una coppia
% num=0;
% counter=zeros(1,23);
% for k=1:23
%     for j=1:24
%         if alta_corr{1,j}(1,1)==k
%             num=num+1;
%         end
%             if alta_corr{1,j}(2,1)==k
%                 num=num+1;
%             end
%             
%         counter(k)=num;
%     end
%     num=0;
% end
% [counter_ord,colonne_corr]=sort(counter,'descend');            

%% in definitiva avrà
feature_def_n=  feature_norm_post_rischio(:, [1:22]);
feature_def_n(:,23)=rischio_new;

%% STANDARDIZZAZIONE
%% correlazione feature standardizzate - rischio
close all
clc

for f=1:size(feature,2)
   [rho_s_rischio(f), pval_s_rischio(f)]= corr(stand_feature(:,f), stand_feature(:,139), 'Type','Spearman','Rows','complete');
end 

for index=1:size(pval_s_rischio,2)
    if pval_s_rischio(index)>0.05
        rho_s_rischio(index)= NaN;
    end
    if abs(rho_s_rischio(index))< 0.1
        rho_s_rischio(index)= NaN;
    end
end

figure
hP=heatmap (pval_s_rischio,'Title','p-value feature stand - rischio');
figure
hR=heatmap(abs(rho_s_rischio),'Title','heatmap stand feature - rischio abs(rho)');


find(~isnan(rho_s_rischio));

%% tengo solo le feature con rho~=NaN

clc
close all

not_delete= find(~isnan(rho_s_rischio));
feature_stand_post_rischio= stand_feature(:, [24 41 43 45 47 60 65 79 85 89 90 103 110 111 115 118 120 122 123 125 132 137 138]);

%% correlazione tra feature
close all
clc

[rho_s, pval_s]=corr(feature_stand_post_rischio,'Type','Spearman', 'Rows','complete');

for r=1:size(pval_s,2)
    for c=1:size(pval_s,2)
        if pval_s(r,c)>0.05
            rho_s(r,c)=NaN;
        end
    end
end
figure
hP=heatmap (pval_s,'Title','heatmap stand p value');
figure
hR=heatmap(abs(rho_s),'Title','heatmap stand abs(rho)');

%%
rho= tril(rho_s);
w=1;
for r=1:size( rho_s,1)
    for c=1:r
        if  abs(rho_s(r,c))> 0.9
            alta_corr{w}=[r;c];
            w=w+1;
        end
    end
end

%% in definitiva avrà
close all
clc

feature_def_s= feature_stand_post_rischio(:, [1:22]);
feature_def_s= [feature_def_s rischio_new];









