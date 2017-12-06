function compartmentCoords = getCoords(data,compartmentList)
% Returns the two coordinates of the nodes that each compartment connects.
% The size of the output is nCompartments*6, where the columns are the x,
% y, z coordinates of the first node, followed by the coordinates of the
% second node.

% initiate variables
[nCompartments, ~] = size(compartmentList); 
compartmentCoords = nan(nCompartments,6);
nodeCoords = data(:,3:5);

% extract coordinates of the nodes and assign them to the array
for thisCompartment = 1:nCompartments
    
    if (thisCompartment == 1) % soma compartment
        
    end
    
    
    thisNodes = compartmentList(thisCompartment,1:2); % the two nodes that this compartment connects
    
    % first node
    compartmentCoords(thisCompartment,1:3) = nodeCoords(thisNodes(1),:);
    
    % second node
    compartmentCoords(thisCompartment,4:6) = nodeCoords(thisNodes(2),:);
end