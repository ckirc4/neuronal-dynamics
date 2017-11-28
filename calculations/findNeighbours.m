function neighbours = findNeighbours(compartments, nodes)
% For each compartment (rows), lists the neighbouring compartments
% (columns)

% maxC: maximum number of compartments that a node is connected by
[nNodes, maxComp] = size(nodes);

maxNeigh = maxComp*2-2; % maximum number of neighbours a compartment can have
neighbours = zeros(nNodes-1, maxNeigh);

for i = 1:nNodes-1 % for each compartment
    % thisNeighbours: the neighbours of this compartment
    % thisNodes: the two nodes that this compartment connects
    thisNeighbours = zeros(1,maxComp*2); % for now, allow twice as much space; will be handled in tidyUpNeighbours
    thisNodes = compartments(i,1:2);
    
    % declare all compartments that the points connect as neighbours
    neighbours(1:maxComp) = nodes(points(1),:); % includes zeros and duplicates
    neighbours(maxComp+1:maxComp*2) = nodes(points(2),:);
    
    % 
    neighbours = tidyUpNeighbours(neighbours,maxNeigh,i);
    if length(neighbours) > maxNeigh
        error('Illegal number of neighbouring compartments')
    end
    neighbours(i,:) = neighbours;
end

end


function newN = tidyUpNeighbours(oldN,maxN,thisC)
newN = zeros(1,maxN);
n = 0;

for i = 1:length(oldN)
    if oldN(i) == thisC % neighbour can't be this compartment
        continue
    elseif oldN(i) == 0 % ignore zeros
        continue
    elseif isempty(find(newN==oldN(i),1)) % ignore duplicates
        n = n+1;
        newN(n) = oldN(i);
    end
end

end