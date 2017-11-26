function output = readSwc(fileName)
% reads the SWC file and outputs it as a n*7 matrix

%% Initialisation and housekeeping
% TO DO: LOOP
if nargin == 1
    % type 1 = file, type 2 = url
    type = validateParameters(fileName);
    [id, success] = openFile(fileName, type);
end

if nargin == 0 || ~success
    [fileName, filePath] = openDialog();
    try
        validateParameters(fileName, 1);
        [id, success] = openFile([filePath fileName]);
    catch
        success = 0; 
    end
    if ~success
        error('The file could not be opened');
    end
    fprintf('readSwc(''%s'')\n',fileName);
end

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


function type = validateParameters(p)
% verifies that the input is a string and in the form x.swc, url URL
if ~ischar(p)
    error('Input must be a string')
elseif ~strcmp(p(end-3:end),'.swc')
    error('File name must end in ".swc"')
elseif length(p) < 5
    error('File not specified')
end

if strcmp(p(1:7),'http://')
    type = 2;
else
    type = 1;
end

end
function [fileID, success] = openFile(name, type)

success = true;
if type == 2
    url = name;
    name = strcat(num2str(floor(rand(10,1)*10))','.swc');
websave(strcat('Temp/',name),url)
end
fileID = fopen(name);
if (fileID == -1)
    warning('Specified file could not be found')
    success = false;
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