function [compartmentList, nodeList] = calculateConnections(data)
% Calculates two arrays that directly relate the nodes and compartments
% (both ways).

% compartmentList   (nNodes-(nSomaNodes-1))*2 array
%       A list of compartments (rows) and which nodes (columns) they
%       connect. 
%       Each compartment must connect two nodes.
%       If the compartment is the soma, then the first node is 0, the
%       second nSomaNodes.

% nodeList:         nNodes*(maxConnections+1) array
%       A list of nodes (rows) and which compartments (columns) they are 
%       connected by.
%       Each node is connected by at least one compartment.
%       The last column counts the number of connections (number of nonzero
%       entries per row).
%       If a node is exclusively part of the soma, the first value is 1,
%       and the last value is 0. The node connecting the soma to the rest
%       of the neuron must have a first value of 1.

nNodes = size(data,1); % number of rows
nSomaNodes = 0;

% count the number of nodes defining the soma
for thisNode = 1:nNodes
    if (data(thisNode,2) == 1) % soma
        nSomaNodes = nSomaNodes + 1;
        
        if thisNode - nSomaNodes > 0
            error('The soma must be exclusively specified first in the data, but found a soma node at id #%i',thisNode);
        end
    end
end

% initialise variables
compartmentList = nan(nNodes-(nSomaNodes-1),2);
nodeList = nan(nNodes,2); % for now, assume largest junction consists of two compartments
nodeSum = nan(nNodes,1); % count the number of nonzero entries per row, appended to nodeList later

for i = 1:nNodes
    % The data rows correspond to the nodes.
    % Compartment #1 connects nodes 0 and nSomaNodes (special case).
    % Compartment #i connects nodes x and i+nSomaNodes, where x is the
    % parent (general case).
    
    if (i <= nSomaNodes) % special case
        nodeList(i,1) = 1;
        nodeSum(i) = 0;
        compartmentList(1,:) = [0 nSomaNodes];
        
    elseif (i > nSomaNodes) % general case
        currentCompartment = i - (nSomaNodes-1); % the compartment number we are considering for this value of i
        
        compartmentList(currentCompartment,2) = i; % upper node
        compartmentList(currentCompartment,1) = data(i,7); % lower (parent) node
        
        N = compartmentList(currentCompartment,1:2); % the two nodes that the current compartment connects
        
        maxCompartments = size(nodeList,2); % currently, the array assumes at most this many compartments per node - may change for this ndoe
        
        % We now want to assign the two nodes in the N vector (i.e. the two
        % nodes connected by the current compartment) to their corresponding
        % positions in the nodes array
        
        assigned = [false false]; % whether each of the nodes has been assigned yet
                
        for nodeIndex = 1:2 % first or second node in N
            thisNode = N(nodeIndex); % the node number we are considering now
            
            for col = 1:maxCompartments
                if assigned(nodeIndex)
                    break; % go to next node
                end
                
                if isnan(nodeList(thisNode,col)) % whether the relevant position in the nodes array is occupied yet
                    nodeList(thisNode,col) = currentCompartment; % this node is connected by the current compartment
                elseif (col == maxCompartments) % have reached the max column, but this node hasn't been assigned yet
                    nodeList(:,col+1) = nan; % extend row
                    nodeList(thisNode,col+1) = currentCompartment; % assign compartment as above
                elseif (col > maxCompartments)
                    error('Something went wrong.');
                else
                    continue; % no column available; try next column
                end
                assigned(nodeIndex) = true;
                % increment nodeSum
                if isnan(nodeSum(thisNode))
                    nodeSum(thisNode) = 1;
                else 
                    nodeSum(thisNode) = nodeSum(thisNode) + 1;
                end
            end
            
        end
        
    end
end

% append nodeSum to nodeList
nodeList = [nodeList nodeSum];
end