function [] = ViewAnimation(input)

file                = input.file;
dletaT              = input.deltaT;
thicknessMultiplier = input.thicknessMultiplier;
refractoryDuration  = input.refractoryDuration;
excitatoryProb      = input.excitatoryProb;
inhibitoryProb      = input.inhibitoryProb;
attenuationProb     = input.attenuationProb;
showTimes           = input.showTimes;

%% Calculations
if (showTimes)
    tic; 
end

data = readSwc(file);
nNodes = size(data,1); 
[cC, cP] = calculateConnections(data);
neighbours = findNeighbours(cC,cP);  % stores the neighbours of each compartment
[t, rSoma, data] = timeToReachSoma(data); % rename to distanceToSoma

if (showTimes)
    fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc); 
end

%% Initial Drawing
if (showTimes)
    tic; 
end

colours = getTypeColours(data(:,2));        % colour according to type
f = drawNeuron(cC, data, thicknessMult, colours, 1); % draws the full neuron and saves handles to each line

if (showTimes)
    fprintf('Time taken to draw neuron for the first time: %.2f seconds\n',toc); 
end

%% Simulation/Animation
states = zeros(m-1,1); % keeps track of the state of each compartment
runSimulation(states, f, colours, state2duration, p_h, p_k, neighbours, deltaT, rSoma); % simulates the progression of signals within the neuron
