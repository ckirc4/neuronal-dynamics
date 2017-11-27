% This script centralises all main functions. 
% Input variables work as follows: for each function, first load the
% default input variable. Then, use . notation to alter specific properties
% (a list of all properties, including a description and default value, is
% provided). 

%% View Animation 
% Opens a window that provides a visual presentation of the neuron
% simulation. 
% 
% Input properties: 
%   file:   
%       the link or path to the .swc file that is to be simulated. Enter
%       empty string to open a dialog window in which the file can be
%       selected. If the given file/link is invalid, the dialog window will
%       also open.
%       Default: ''        
%   deltaT: 
%       the minimum time between frames, in seconds. This is only useful
%       for small neurons where calculations take less than deltaT.
%       Default: 0.1
%   thicknessMultiplier:
%       multiplies the thickness value of all branches as they are given in
%       the .swc file.
%       Default: 1
%   refractoryDuration:
%       how many steps the refractory period lasts for.
%       Default: 5
%   excitatoryProb:
%       probability of an excitatory synaptic input at any compartment per
%       step. This causes a susceptible compartment to fire.
%       Default: 0.01
%   inhibitoryProb:
%       probability of an inhibitory synaptic input at any compartment per
%       step. This causes a susceptible compartment, which then propagates
%       along the dendritic branches.
%       Default: 0
%   attenuationProb:
%       probability that an active compartment fails to pass on an
%       electrical signal to its neighbours.
%       Default: 0.01
%   showTimes:
%       whether or not the times required for calculations and the initial
%       visualisation should be displayed in the command window.
%       Default: false

input = getViewAnimationInput();
ViewAnimation();








%% Templates
%   name:
%       description
%       Default:
input = getFunctionNameInput();
FunctionName();