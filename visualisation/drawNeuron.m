function f = drawNeuron(cC, data, thicknessMult, colours, fig)
% draws initial 3D plot and returns a vector of handles to each compartment

coords = data(:,3:5); % isolate coordinates in data
r = data(:,6); % isolate compartment radii

[m,~] = size(coords);

if nargin == 5
    figure(fig);
end
 cla('reset'); hold on; axis equal;

for i = 2:m % start at 2 because first point is only a reference point, not connected to anything
    % soma has red outline
    if data(i,2) == 1
        outline = 'r';
    else
       outline = 'none'; 
    end
    
    % plot individual lines
   pt(1:2) = cC(i-1,:); % there will always be 2 points connecting a compartment
       f(i-1) = ...
           plot3([coords(pt(1),1); coords(pt(2),1)], ...
           [coords(pt(1),2); coords(pt(2),2)], ...
           [coords(pt(1),3); coords(pt(2),3)], ...
           'Color', colours(i-1,:), ...
           'LineWidth', r(i)*thicknessMult, ...
           'MarkerEdgeColor',outline); % TODO: find a way to outline the soma
end

drawnow;
hold off;

end