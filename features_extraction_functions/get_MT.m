function [MT] = get_MT(mat)
% INPUT
%     mat: singolo bambino, singola esecuzione, la prima colonna è il tempo
%     deve essere già segmentata
% OUTPUT
%     MT: movement time

MT = mat(end,1) - mat(1,1);
end

