function dist = distToSoma(neighbours)
% For each compartment, calculates the distance (in terms of the number of
% compartments) from the soma (which is a single compartment, #1).

[nCompartments, ~] = size(neighbours);
dist = nan(nCompartments,1);

dist(1) = 0; % first compartment is soma
for i = 2:nCompartments
    
    % since parents must always have a lower ID that the daughter compartment, the parent with the
    % lowest ID will be the compartment that leads towards the soma
    
    parent = min(neighbours(i,:)); % parent compartment
    dist(i) = dist(parent) + 1;
    
end