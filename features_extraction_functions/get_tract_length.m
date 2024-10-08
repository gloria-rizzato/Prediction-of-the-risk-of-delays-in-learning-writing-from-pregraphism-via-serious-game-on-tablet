function tot_length = get_tract_length (mat)
% INPUT
%     matrice con le seguenti colonne
%     2: posizione x
%     3: posizione y
% OUTPUT
%     lunghezza totale del tratto

tot_length = 0;
for pt = 2 : size(mat,1)
    tot_length = tot_length + norm(mat(pt,1:2) - mat(pt - 1,1:2));
end
end