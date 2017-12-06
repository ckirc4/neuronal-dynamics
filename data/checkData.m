function checkData(data)
% Makes sure the data has the correct structure so that no unexpected
% behaviour occrs when running the simulation.

%% Soma exists
if ((data(1,2) ~= 1) && (data(1,7) ~= -1))
    error('No soma found.')
end

%% Soma specified at beginning of data 
previousWasSoma = true;
for i = 2:size(data,1)
    if (data(i,2) == 1) % is soma
        if ~previousWasSoma
            error('Node #%i is a soma, but has to be defined at the beginning of the data.',i)
        end
    else
        previousWasSoma = false;
    end
end

%% Compartments connect to the soma only via the very first node
for i = 2:size(data,1)
    parent = data(i,7);
    if (data(parent,2) == 1) % parent is soma
        if (parent ~= 1)
            error('Compartment #%i connects to soma node #%i, but should be #1',i,parent)
        end
    end
end

%% Parents have lower IDs than any of their daughter compartments (i.e. branches split away from soma)
for i = 2:size(data,1)
   parent = data(i,7);
   if (parent > i)
       error('Node #%i''s parent (#%i) is illegal.',i,parent)
   elseif (parent == i)
       error('Node #%i connects to itself.')
   elseif (parent < 1)
       error('Node #%i''s parent (#%i) is a nonexistent node.',i,parent)
   end
end

end