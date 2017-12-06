function output = readSwc(file)
% reads the SWC file and outputs it as a n*7 matrix

%% Find and open file
if (nargin == 0 || isempty(file))
    file = openDialog(); % returns full file location
end

type = validateParameters(file);
[id, file] = openFile(file, type);

%% Find data
% Go through document until reaching the first line of data (i.e. go past
% the comments)

reachedData = false; 

while ~reachedData
    thisLine = fgetl(id);
    if (thisLine == -1)
        % reached end of document
        showError(sprintf('No data found.'), id);
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
    verifyLineVector(thisLineVector, i, id);
    result(i,:) = thisLineVector;
    
    thisLine = fgetl(id); % read next line
    
end

%% Finish
if strcmp(type, 'url')
    cleanUp(id, file);
else
   cleanUp(id); 
end

output = result;

end


function type = validateParameters(file)
% verifies that the input is a string and in the form x.swc

if ~ischar(file)
    showError(sprintf('Input must be a string.'));
elseif ~strcmp(file(end-3:end),'.swc')
    showError(sprintf('File name must end in ".swc".'));
elseif length(file) < 5
    showError(sprintf('File not specified.'));
end

if contains(file,'neuromorpho.org')
    type = 'url';
else
    type = 'local';
end

end

function [id, file] = openFile(file, type)

if strcmp(type, 'url')
    % save website to temporary .swc file
    url = file;
    file = websave('temp.swc', url);
end

id = fopen(file);

if (id == -1 && strcmp(type, 'url'))
    showError('Content could not be found/downloaded.', id, file);
elseif (id == -1)
    showError('Specified file could not be found.');
end

end

function file = openDialog()

[file, path] = uigetfile('.swc','Select .swc file');

if isequal(file,0) || isequal(path,0)
    showError(sprintf('Action cancelled by user.'));
end

file = [path file];

end

function vector = parseLine(line)

vector = str2num(line);
% for large data sets, may have to modify this by converting the 1st,
% 2nd and last columns into uint types to save memory

end

function verifyLineVector(v, k, id)

if any(isnan(v)) || isempty(v)
    showError(sprintf('Unable to parse line at compartment id: %i (parsing error).', k), id);
elseif length(v) ~= 7
    showError(sprintf('Unable to parse line at compartment id: %i (expecting 7 values, but found %i).', k, lenth(v)), id);
elseif v(1) ~= k
    showError(sprintf('Line at compartment id out of sync at id: %i (should be %i).', k, v(7)), id);
elseif v(7) >= k
    showError(sprintf('Unexpected parent compartment at id: %i (should be less than %i).', k, v(7)), id);
end

% if this line is reached, parsing must have been successful!

end

function cleanUp(fileID, tempFile)
% Close file dependency and deletes temp file if applicable

if (nargin >= 1)
    fclose(fileID);
end

if (nargin == 2)
    delete(tempFile);
end

end

function showError(errorMsg, fileID, tempFile)

if (nargin == 3)
    cleanUp(fileID, tempFile);
elseif (nargin == 2)
    cleanUp(fileID);
end

% show error message
if (nargin >= 1)
    error(errorMsg);
end

end
