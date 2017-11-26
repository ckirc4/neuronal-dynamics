function output = readSwc(file)
% reads the SWC file and outputs it as a n*7 matrix

%% Find and open file
if nargin == 0
    file = openDialog(); % returns full file location
end

type = validateParameters(file);
id = openFile(file, type);

%% Find data
reachedData = false;

while ~reachedData
    thisLine = fgetl(id);
    if (thisLine == -1)
        % reached end of document
        error('No data found')
    elseif isempty(thisLine)
        % empty line
        continue;
    elseif strcmp(thisLine(1),'#')
        % is comment
        continue;
    else
        % must have reached data!
        reachedData = true;
    end
end

% thisLine now contains the first row of data

%% Parse data

a = zeros(1,7); % extract 7 pieces of information per line of data
i = 0;
reachedEnd = false;
while ~reachedEnd
    % check if end is reached
    if isequal(thisLine,-1) || isempty(thisLine)
        reachedEnd = true;
        continue;
    end
    
    i = i + 1;
    thisLineVector = parseLine(thisLine); % convert from string representation to vector
    verifyLineVector(thisLineVector,i);
    a(i,:) = thisLineVector;
    
    % read next line
    thisLine = fgetl(id);
end

%% Declare output
output = a;
end


function type = validateParameters(file)
% verifies that the input is a string and in the form x.swc
if ~ischar(file)
    error('Input must be a string')
elseif ~strcmp(file(end-3:end),'.swc')
    error('File name must end in ".swc"')
elseif length(file) < 5
    error('File not specified')
end

if contains(file,'neuromorpho.org')
    type = 'url';
else
    type = 'local';
end

end

function fileID = openFile(file, type)

if type == 'url'
    % save website to temporary .swc file
    url = file;
    file_temp = 'temp.swc';
    file = websave(file_temp,url);
end

fileID = fopen(file);
delete(file_temp);

if (fileID == -1)
    error('Specified file could not be found.')
end

end

function [file, path] = openDialog()

[file, path] = uigetfile('.swc','Select .swc file');

if isequal(file,0) || isequal(path,0)
    error('Action cancelled by user');
end

end

function v = parseLine(line)

v = str2num(line);  %#ok<ST2NM>
% for large data sets, may have to modify this by converting the 1st,
% 2nd and last columns into uint types to save memory

end

function verifyLineVector(v,k)

if any(isnan(v)) || isempty(v)
    error('Unable to parse compartment id: %i',k)
elseif v(1) ~= k
    warning('Compartment id out of sync at id: %i',k);
elseif v(7) >= k
    warning('Unexpected parent compartment at id: %i',k);
elseif length(v) ~= 7 % check that there are 7 pieces of information in each line
    error('Unable to parse compartment id: %i since the format is unexpected',k);
end

% if this line is reached, parsing must have been successful!

end
