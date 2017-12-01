function col = getTypeColours(types)
m = length(types);

col = '';
for i = 2:m
    switch types(i)
        case 1 % soma
            col(i-1) = 'b'; % blue
        case 2 % axon
            col(i-1) = 'c'; % cyan
        case 3 % basal dendrite
            col(i-1) = 'g'; % green
        case 4 % apical dendrite
            col(i-1) = 'g'; % green
        otherwise
            col(i-1) = 'k'; % black
    end
end

col = col'; % want column vector
end