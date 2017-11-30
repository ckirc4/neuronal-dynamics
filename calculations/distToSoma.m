function [dist, somaNodes] = distToSoma(data)
% For each compartment, calculates the distance (in terms of the number of
% compartments) from the soma. 
% The soma is treated as a single compartment,
% where somaIds contains the data entries (id's) that correspond to the
% soma. [note: usually, they are two or three, representing a spherical or
% cylindrical shape respectively]

[nNodes,~] = size(data);

types = data(:,2); % the i'th row defines the type of the (i-1)'th compartment
parents = data(1:end,7); % parents in terms of nodes

% count the number of nodes corresponding to the soma
nSomaNodes = 0;
somaNodes = [];

for thisNode = 1:nNodes
    if types(thisNode) == 1 
        nSomaNodes = nSomaNodes+1;
        somaNodes(nSomaNodes) = thisNode;
    end
end

if isempty(somaNodes)
    warning('Soma is not specified - this may have undesired consequences.')
end

% in the standardised swc files, we expect the dendrites to be children of
% the very first point - check that there are no children of the other soma
% nodes
for i = 2:nSomaNodes
   for j = 2:nNodes
      if parents(j) == somaNodes(i)
         % some node is connected to an undesired soma node
         warning('Node #%i is connected to #%i (soma), but should connect to #1',j,i);
      end
   end
end

% calculate distance to reach soma from each compartment
dist = zeros(nNodes-1,1);

for thisNode = 2:nNodes
    thisCompartment = thisNode - 1;
    if types(parents(thisNode)) == 1 % parent is soma
        if types(thisNode) == 1 % child is soma
            dist(thisCompartment) = 0;
        else
            dist(thisCompartment) = 1;
        end
    else
        dist(thisCompartment) = dist(parents(thisNode)) + 1; % parent's time + 1
    end
end

end