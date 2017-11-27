function [cC, cP] = calculateConnections(data)
% cC is a (m-1)*2 matrix that records the two points (columns) each 
% compartment (row) is connected to.
% cP is a m*x matrix that records the compartments (columns) each point
% (row) is connected with. 

m = size(data,1);

cC = zeros(m-1,2); % which two points connect each compartment?
cP = zeros(m,3); % which compartments does each point connect?

for i = 1:m-1 % i are the compartment numbers, i.e. i+1'th row of the data is the i'th compartment
    % for cC
    cC(i,1) = i+1; % k'th compartment connected by k+1'th point
    cC(i,2) = data(i+1,7); % other point is the parent
    
    % for cP
    P = cC(i,1:2); % the two points that the i'th compartment connects to
    
    numC = size(cP,2);
    done = [0 0]; % whether the two P values have been filled into cP yet
    for c = 1:numC % columns
        for p = 1:2
            thisP = P(p);
            if cP(thisP,c) == 0
                if ~done(p)
                    cP(thisP,c) = i;
                    done(p) = 1;
                end
            elseif c == numC && cP(thisP,c) ~= 0
                cP(thisP,c+1) = i; % this row of cP is filled up, so extend it
            end
        end
    end
end
end