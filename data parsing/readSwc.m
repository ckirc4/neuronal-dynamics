function output = readSwc(file)
% reads the SWC file and outputs it as a n*7 matrix

%% Find and open file
if nargin == 0
    file = openDialog(); % returns full file location
end

type = validateParameters(file);
id = openFile(file, type);

%% Find data
% Go through document until reaching the first line of data (i.e. go past
% the comments)

reachedData = false; 

while ~reachedData
    thisLine = fgetl(id);
    if (thisLine == -1)
        % reached end of document
        error('No data found.')
    elseif isempty(thisLine)
        % this line is empty
        continue;
    elseif strcmp(thisLine(1),'#')
        % this line is a comment
        continue;
    else
        % must have reached data!
        reachedData = true;
    end
end

% thisLine now contains the first row of data

%% Parse data
% Treat each line individually until reaching the end of the document, and
% write the data to a new row in the result array

result = nan(1,7); % extract 7 pieces of information per line of data
i = 0;
reachedEnd = false;

while ~reachedEnd
    
    % check if end of document has been reached
    if isequal(thisLine,-1) || isempty(thisLine)
        reachedEnd = true;
        continue;
    end
    
    i = i + 1;
    thisLineVector = parseLine(thisLine); % convert from string representation to vector
    verifyLineVector(thisLineVector,i);
    result(i,:) = thisLineVector;
    
    thisLine = fgetl(id); % read next line
    
end

%% Declare output
output = result;
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
    error('Action cancelled by user.');
end

end

function vector = parseLine(line)

vector = str2num(line);
% for large data sets, may have to modify this by converting the 1st,
% 2nd and last columns into uint types to save memory

end

function verifyLineVector(v,k)

if any(isnan(v)) || isempty(v)
    error('Unable to parse line at compartment id: %i (parsing error).', k)
elseif v(1) ~= k
    warning('Line at compartment id out of sync at id: %i (should be %i).', k, v(7));
elseif v(7) >= k
    error('Unexpected parent compartment at id: %i (should be less than %i).', k, v(7));
elseif length(v) ~= 7
    error('Unable to parse line at compartment id: %i (expecting 7 values, but found %i).', k, lenth(v));
end

% if this line is reached, parsing must have been successful!

end
