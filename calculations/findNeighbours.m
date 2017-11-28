function c = findNeighbours(cC, cP)
% c is an (m-1)*x matrix that lists the neighbouring compartments (columns)
% for each compartment (row)

[m, maxC] = size(cP);

maxN = maxC*2-2; % maximum number of neighbours a compartment can have
c = zeros(m-1,maxN);

for i = 1:m-1 % for each compartment
    neighbours = zeros(1,maxC*2);
    points = cC(i,1:2);
    
    % declare all compartments that the points connect as neighbours
    neighbours(1:maxC) = cP(points(1),:); % includes zeros and duplicates
    neighbours(maxC+1:maxC*2) = cP(points(2),:);
    
    neighbours = tidyUpNeighbours(neighbours,maxN,i);
    if length(neighbours) > maxN
        error('Illegal number of neighbouring compartments')
    end
    c(i,:) = neighbours;
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