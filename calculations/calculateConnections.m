function [compartmentList, nodeList] = calculateConnections(data)
% Calculates two arrays that directly relate the nodes and compartments
% (both ways).
%
% compartmentList   (nNodes-(nSomaNodes-1))*2 array
%       A list of compartments (rows) and which nodes (columns) they
%       connect. 
%       Each compartment must connect two nodes.
%       If the first compartment is the soma, then the first node is #0.
% nodeList:         nNodes*(maxConnections)+1 array
%       A list of nodes (rows) and which compartments (columns) they are 
%       connected by.
%       Each node is connected by at least one compartment.
%       The last column counts the number of connections (number of nonzero
%       entries per row).

nNodes = size(data,1); % number of rows
nSomaNodes = 0;

% count the number of nodes defining the soma
for thisNode = 1:nNodes
    if (data(thisNode,2) == 1) % soma
        nSomaNodes = nSomaNodes + 1;
    end
end

% initialise variables
compartmentList = nan(nNodes-(nSomaNodes-1),2);
nodeList = nan(nNodes,3); % for now, assume largest junction consists of two compartments

for i = 1:nNodes
    
    % The data rows correspond to the nodes
    % Compartment #1 connects nodes 1 and 2
    % Compartment #i connects nodes x and i+1 (x is the parent)
    compartmentList(i,2) = i+1;
    compartmentList(i,1) = data(i+1,7);
    
    N = compartmentList(i,1:2); % the two nodes that the i'th compartment connects
    
    maxCompartments = size(nodeList,2);
    
    % We now want to assign the two nodes in the N vector to their
    % corresponding positions in the nodes array
    assigned = [false false]; % whether each of the nodes has been assigned yet
    for col = 1:maxCompartments
        for nodeIndex = 1:2 % first or second node in N
            
            if ~assigned(nodeIndex)
                thisNode = N(nodeIndex); % the node number we are considering now
                if nodeList(thisNode,col) == 0 % whether the relevant position in the nodes array is occupied yet
                    nodeList(thisNode,col) = i; % this node is connected by the i'th compartment
                    assigned(nodeIndex) = true;
                elseif (col == maxCompartments && nodeList(thisNode,col) ~= 0) % have reached the max column, but this node hasn't been assigned yet
                    nodeList(thisNode,col+1) = i; % this row of cP is filled up, so extend it
                    assigned(nodeIndex) = true;
                end
            end
            
        end
    end
end
end