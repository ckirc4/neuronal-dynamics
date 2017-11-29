function [t, rSoma, data] = timeToReachSoma(data)
% calculates the number of steps it takes for a signal to reach the soma,
% i.e. the soma compartment that this branch is connected to. soma is
% treated as a single compartment, where the soma rows in the data are
% contained within rSoma.

[m,~] = size(data);

types = data(:,2);
parents = data(1:end,7); % length of m

% count the number of soma points/compartments
n = 0;
rSoma = [];

for s = 2:m
    if types(s) == 1 
        n = n+1;
        rSoma(n) = s-1; % compartment number s is part of soma
    end
end

if isempty(rSoma)
    data(1:2,2) = 1;
    types(1:2) = 1;
    rSoma = [1];
    warning('No soma found - converting the first two points into soma points')
elseif length(rSoma) == 1
    rSoma = [1];
    warning('Soma is only described by a single point - this may have undesired consequences')
end

% calculate time (steps) to reach soma from each compartment
t = zeros(m-1,1);

for i = 2:m
    if types(parents(i)) == 1 % parent is soma
        if types(i) == 1 % child is soma
            t(i-1) = 0;
        else
            t(i-1) = 1;
        end
    else
        t(i-1) = t(parents(i)-1) + 1; % parent's time + 1
    end
end

end