function [ID] = get_ID(mat,settings)

% non sono centimetri ma un fattore di scala (poi ID è adimensionale)
A = settings(4,2);
W = settings(4,1);

if A == 0 % bug su tunnel ELE: non registrava le A
    A = range(settings(5:end,2));
end

ID = A/W;

end

