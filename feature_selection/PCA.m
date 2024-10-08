%feature selection con metodo della PCA

%% applico PCA normalization
clc
[coeff_n,score_n,latent_n,tsquared_n,explained_n]=pca(feature_def_n(:, [1:end-1])); 

 pos=1;
 pos1=1;
for r=1:(size(feature_def_n,1)-1)
    if rischio_new(r,1)==1
        score_n_r(pos,:)=score_n(r,:);
        pos=pos+1;
    else if rischio_new(r,1)==0
        score_n_td(pos1,:)=score_n(r,:);
        pos1=pos1+1;    
        end
    end
end

figure(1)
scatter3(score_n_r(:,1),score_n_r(:,2),score_n_r(:,3), 30, 'r','filled')
hold on
scatter3(score_n_td(:,1),score_n_td(:,2),score_n_td(:,3), 30, 'b')

axis equal
xlabel('1° componente principale')
ylabel('2° componente principale')
zlabel('3° componente principale')
title('3D plot feature normalizzate')

% screeplot
figure(2)
pareto(explained_n)
xlabel('Componente principale');
ylabel('Varianza spiegata(%)');
title('Screeplot feature normalizzate')




%% applico PCA standardization
clc
[coeff_s,score_s,latent_s,tsquared_s,explained_s]=pca(feature_def_s(:, [1:end-1])); 

 pos=1;
 pos1=1;
for r=1:size(feature_def_s,1)
    if rischio_new(r,1)==1
        score_s_r(pos,:)=score_s(r,:);
        pos=pos+1;
    else if rischio_new(r,1)==0
        score_s_td(pos1,:)=score_s(r,:);
        pos1=pos1+1;    
        end
    end
end

figure(3)
scatter3(score_s_r(:,1),score_s_r(:,2),score_s_r(:,3), 30, 'r','filled')
hold on
scatter3(score_s_td(:,1),score_s_td(:,2),score_s_td(:,3), 30, 'b')

axis equal
xlabel('1° componente principale')
ylabel('2° componente principale')
zlabel('3° componente principale')
title('3D plot feature standardizzate')

% screeplot
figure(4)
pareto(explained_s)
xlabel('Componente principale');
ylabel('Varianza spiegata(%)');
title('Screeplot feature standardizzate');

%% tolgo le feature (per norm tengo le prime 17 per stand le prime 18 così spiego circa 97% di varianza)



