function neighbours = findNeighbours(compartmentList, nodeList)
% For each compartment (rows), lists the neighbouring compartments
% (columns)

[nCompartments, ~] = size(compartmentList);

% maxComp: maximum number of compartments that connect to a single node
maxComp = max(nodeList(:,end));

maxNeigh = (maxComp-1)*2; % theoretical maximum number of neighbours a compartment can have
mostNeigh = 0; % actual maximum
neighbours = nan(nCompartments, maxNeigh);

for i = 1:nCompartments % for each compartment
    % thisNeighbours: the neighbours of this compartment
    % thisNodes: the two nodes that this compartment connects
    thisNeighbours = nan(1,maxComp*2); % for now, allow twice as much space; will be handled in tidyUpNeighbours
    thisNodes = compartmentList(i,1:2);
    
    % declare all compartments connecting to either of these nodes as
    % neighbours of this compartment
    if thisNodes(1) == 0 % only true for soma compartment
        thisNeighbours(maxComp+1:maxComp*2) = nodeList(1,1:end-1);
    else % for any other compartment
        thisNeighbours(1:maxComp) = nodeList(thisNodes(1),1:end-1);
        thisNeighbours(maxComp+1:maxComp*2) = nodeList(thisNodes(2),1:end-1);
    end
    
    % n: the number of neighbours of this compartment
    [thisNeighbours, n] = tidyUpNeighbours(thisNeighbours,maxNeigh,i);
    if n > maxNeigh
        error('Illegal number of neighbouring compartments for compartment #%i',i)
    elseif n > mostNeigh
        mostNeigh = n;
    end
    neighbours(i,:) = thisNeighbours;
end

% trim zero columns
surplus = maxNeigh - mostNeigh;
neighbours = neighbours(:,1:end-surplus);

end


function [newNeighbours, n] = tidyUpNeighbours(oldNeighbours,maxNeighbours,thisCompartment)
% removes duplicates and zeros, and sorts neighbours

newNeighbours = nan(1,maxNeighbours);
n = 0; % keep counter of how many (new) neighbours there are

for i = 1:length(oldNeighbours)
    if oldNeighbours(i) == thisCompartment % this compartment can't be its own neighbour
        continue
    elseif isnan(oldNeighbours(i)) % ignore nans
        continue
    elseif ~isempty(find(newNeighbours==oldNeighbours(i),1)) % ignore duplicates
        continue
    else
        n = n+1;
        newNeighbours(n) = oldNeighbours(i);
    end
end

newNeighbours = sort(newNeighbours);

end