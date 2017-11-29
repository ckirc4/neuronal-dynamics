function neighbours = findNeighbours(compartments, nodes)
% For each compartment (rows), lists the neighbouring compartments
% (columns)

% maxComp: maximum number of compartments that connect to a single node
[nNodes, maxComp] = size(nodes);

maxNeigh = (maxComp-1)*2; % theoretical maximum number of neighbours a compartment can have
mostNeigh = 0; % actual maximum
neighbours = zeros(nNodes-1, maxNeigh);

for i = 1:nNodes-1 % for each compartment
    % thisNeighbours: the neighbours of this compartment
    % thisNodes: the two nodes that this compartment connects
    thisNeighbours = zeros(1,maxComp*2); % for now, allow twice as much space; will be handled in tidyUpNeighbours
    thisNodes = compartments(i,1:2);
    
    % declare all compartments connecting to either of these nodes as
    % neighbours to this compartment
    thisNeighbours(1:maxComp) = nodes(thisNodes(1),:);
    thisNeighbours(maxComp+1:maxComp*2) = nodes(thisNodes(2),:);
    
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

newNeighbours = zeros(1,maxNeighbours);
n = 0; % keep counter of how many (new) neighbours there are

for i = 1:length(oldNeighbours)
    if oldNeighbours(i) == thisCompartment % this compartment can't be its own neighbour
        continue
    elseif oldNeighbours(i) == 0 % ignore zeros
        continue
    elseif ~isempty(find(newNeighbours==oldNeighbours(i),1)) % ignore duplicates
        continue
    else
        n = n+1;
        newNeighbours(n) = oldNeighbours(i);
    end
end

end