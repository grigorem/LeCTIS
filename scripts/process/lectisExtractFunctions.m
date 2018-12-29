function [extractedFunctions, statusMessage] = extractFunctions(sourceFile)
    
    %% prepare for processing
    
    % initalize output
    extractedFunctions  = [];
    statusMessage       = '';
    
    % check the argument existence
    if nargin < 1
        statusMessage = 'No source file provided. Please call again with the appropiate argument.';
        return
    end
    
    % check the argument type
    if isempty(sourceFile) || ~ischar(sourceFile)
        statusMessage = 'Source file provided is not valid. Please call againe with the appropiate argument.';
        return
    end
    
    % check the source file extension
    [~, ~, sourceExt] = fileparts(sourceFile);

    if ~any(ismember({'.c', '.h', '.cpp'}, sourceExt))
        statusMessage = 'Source file provided does not have the appropiate extension (.c, .h, .cpp). Please call again with the appropiate argument.';
        return
    end
    
    % check the source file existence
    if ~exist(sourceFile, 'file')
        statusMessage = 'Source file provided does not exist. Please call again with the appropiate argument.';
        return
    end
    
    %% process the file
    
    % functions search pattern
    commentsPattern     = '\/\*.+?\*\/|\/\/.*?(?:\n|$)';
    functionsPattern    = '(?:\n|^)\s*(?<return>#define\s*|(?:\w+\s+?)*?\w+(?:\s*\*?\s+?|\s+?\*?\s*?))(?<function>\w+)\s*?\((?<args>(?:\s*?|\s*?\w+\s*?|(?:(?:\s*(?:(?:\w+\s+?)*?\w+(?:\s*\*?\s+?|\s+?\*?\s*?))(?:\w+)\s*?,)*\s*(?:(?:\w+\s+?)*?\w+(?:\s*\*?\s+?|\s+?\*?\s*?))(?:\w+)\s*?)))\)[^;]';
    pointersPattern     = '\*\s*\*';
    argumentPattern     = '^((?:\w+?\s*)+)((?:(?:\*\s*)+)|\s+)(\w+)$';
    
    % save the content of the source file in a variable
    sourceContents = fileread(sourceFile);
    
    % remove comments
    sourceContents = regexprep(sourceContents, commentsPattern, '');
    
    % find functions (hell of a regex)
    matches = regexpi(sourceContents, functionsPattern, 'tokens');
    
    % allocate space to the output array of structs
    extractedFunctions = repmat(struct('name', [], 'return', [], 'args', []), length(matches), 1);
    
    % iterate over each match and populate the structure array
    for iMatch = 1:length(matches)
        
        % get functioon name
        name = strtrim(matches{iMatch}{2});

        % return type (macro check)
        returnMatch = strtrim(matches{iMatch}{1});
        returnMatch = regexprep(returnMatch, pointersPattern, '**'); % remove the spaces between asterisks for pointers - ODD
        returnMatch = regexprep(returnMatch, pointersPattern, '**'); % need to be applied twice - EVEN
        ret = struct('type', [], 'pointer', []);
        if strcmpi(returnMatch, '#define') || strcmpi(returnMatch, 'void')
            ret = [];
        else
            match           = regexpi(returnMatch, '^(.+?)((?:\*\s*)*)$', 'tokens', 'once');
            ret.type = strtrim(match{1});
            
            if ~isempty(match{2}) && ~strcmp(strtrim(match{2}), 'void')
                ret.pointer = strtrim(match{2});
            else
                ret.pointer = '';
            end
        end

        % process arguments
        args = strtrim(matches{iMatch}{3});
        if ~isempty(args) && ~strcmp(args, 'void')
            args = regexprep(args, pointersPattern, '**'); % remove the spaces between asterisks for pointers
            args = regexprep(args, pointersPattern, '**'); % need to be applied twice

            argsSplit = strsplit(args, ',');
            args = repmat(struct('type', [], 'pointer', [], 'name', []), length(argsSplit), 1);
            for j = 1:length(argsSplit)
                match = regexpi(strtrim(argsSplit{j}), argumentPattern, 'tokens', 'once');
                if isempty(match)
                    args = [];
                    break
                end

                args(j).type    = strtrim(match{1});
                args(j).pointer = strtrim(match{2});
                args(j).name	= strtrim(match{3});
            end
        end

        
        % populate structure
        extractedFunctions(iMatch).name         = name;
        extractedFunctions(iMatch).return       = ret;
        extractedFunctions(iMatch).args         = args;
    end
end

