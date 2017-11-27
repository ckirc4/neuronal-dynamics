function [compartments, nodes] = calculateConnections(data)
% Calculates two arrays that directly relate the nodes and compartments
% (both ways).
%
% compartments   (nNodes-1)*2 array
%       Which nodes (columns) the compartments (rows) connect
%       Each compartment must connect two nodes
% nodes:         nNodes*x array
%       Which compartments (columns) the nodes (rows) are connected by
%       Each node is connected by at least one compartment
%       (1 if the node is at an endpoint)

nNodes = size(data,1);

compartments = zeros(nNodes-1,2);
nodes = zeros(nNodes,3); % for now, assume largest junction consists of three compartments

for i = 1:nNodes-1
    
    % The data rows correspond to the nodes
    % Compartment #1 connects nodes 1 and 2
    % Compartment #i connects nodes x and i+1 (x is the parent)
    compartments(i,2) = i+1;
    compartments(i,1) = data(i+1,7);
    
    N = compartments(i,1:2); % the two nodes that the i'th compartment connects
    
    maxCompartments = size(nodes,2);
    
    % We now want to assign the two nodes in the N vector to their
    % corresponding positions in the nodes array
    assigned = [false false]; % whether each of the nodes has been assigned yet
    for col = 1:maxCompartments
        for nodeIndex = 1:2 % first or second node in N
            
            if ~assigned(nodeIndex)
                thisNode = N(nodeIndex); % the node number we are considering now
                if nodes(thisNode,col) == 0 % whether the relevant position in the nodes array is occupied yet
                    nodes(thisNode,col) = i; % this node is connected by the i'th compartment
                    assigned(nodeIndex) = true;
                elseif (col == maxCompartments && nodes(thisNode,col) ~= 0) % have reached the max column, but this node hasn't been assigned yet
                    nodes(thisNode,col+1) = i; % this row of cP is filled up, so extend it
                    assigned(nodeIndex) = true;
                end
            end
            
        end
    end
end
end