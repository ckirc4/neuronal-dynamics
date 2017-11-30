function [dist, somaNodes] = distToSoma(data)
% For each compartment, calculates the distance (in terms of the number of
% compartments) from the soma. 
% The soma is treated as a single compartment,
% where somaIds contains the data entries (id's) that correspond to the
% soma. [note: usually, they are two or three, representing a spherical or
% cylindrical shape respectively]

% The i'th compartment is defined by nodes #parents(i)+1 and #i+1, i.e. the
% "upper bound" nodes of that compartment and its parent's compartment

[nNodes,~] = size(data);
nCompartments = nNodes - 1;

types = data(:,2); % the i'th row defines the type of the (i-1)'th compartment
parents = data(2:end,7) - 1; % parents in terms of compartments
% parents(c) is the parent compartment of compartmnet number c

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
for thisSomaNode = 2:nSomaNodes
   for thisCompartment = (nSomaNodes-1):nCompartments
      if parents(thisCompartment) == somaNodes(thisSomaNode) - 1
         % some compartment is connected to an undesired soma node
         warning(['Compartment between nodes #%i and #%i is connected to the one '...
             'between #%i and #%i (soma), but should connect to the very first node'], ...
             thisCompartment,thisCompartment+1,thisSomaNode,thisSomaNode+1); 
      end
   end
end

% calculate distance to reach soma from each compartment
dist = zeros(nCompartments,1);

for thisNode = 2:nNodes
    thisCompartment = thisNode - 1;
    if parents(thisCompartment) == 0 
        % this compartment is attached to first node (i.e. doesn't have
        % parent compartment)
        
        if types(thisCompartment+1) == 1 % need +1 since types is in terms of nodes
            % this compartment is part of soma
            dist(thisCompartment) = 0;
        else
            % directly adjacent to soma
            dist(thisCompartment) = 1;
        end
        
    else
        % this compartment is attached to another compartment
        dist(thisCompartment) = dist(parents(thisCompartment)) + 1;
    end
%         
%         
%     
%     if types(parents(thisCompartment)) == 1 % parent is soma
%         if types(thisNode) == 1 % child is soma
%             dist(thisCompartment) = 0;
%         else
%             dist(thisCompartment) = 1;
%         end
%     else
%         dist(thisCompartment) = dist(parents(thisCompartment)) + 1; % parent's time + 1
%     end
end

end