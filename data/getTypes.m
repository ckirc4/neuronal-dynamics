function compartmentTypes = getTypes(data)
% Assigns the type for each compartment

nodeTypes = data(:,2);
nNodes = length(nodeTypes);

compartmentTypes = nan(nNodes,1); % truncate at the end since soma might be defined by multiple nodes

% from bottom to top, extract the types until reaching the soma
for i = nNodes:-1:1
    compartmentTypes(i) = nodeTypes(i);
    if (nodeTypes(i) == 1) % reached soma
        compartmentTypes = compartmentTypes(i:end); % truncate
        break
    end
end