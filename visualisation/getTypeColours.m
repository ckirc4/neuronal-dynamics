function colours = getTypeColours(types, colourOfType)
% assigns the colour of every compartment based on its type

nNodes = length(types);
nCompartments = nNodes - 1;

colours = nans(nCompartments,3);
for i = 1:nCompartments
    switch types(i)
        case 1 % soma
            colours(i,:) = colourOfType.soma;
        case 2 % axon
            colours(i,:) = colourOfType.axon;
        case 3 % basal dendrite
            colours(i,:) = colourOfType.dendrite;
        case 4 % apical dendrite
            colours(i,:) = colourOfType.dendrite;
        otherwise
            colours(i,:) = [0 0 0]; % black
    end
end

end