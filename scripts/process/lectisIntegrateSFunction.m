function blockHandle = lectisIntegrateSFunction(mexFile, modelName, mode, destination)
	
	% s function source
	sFunctionSource = 'simulink/User-Defined Functions/S-Function';
	load_system('simulink');
	
	% copy mex file to the place where the model is
	[~, mexFileName, mexFileExt] = fileparts(mexFile);
	mexFileDestination = fullfile(fileparts(which(modelName)), [mexFileName, mexFileExt]);
	[~, ~] = copyfile(mexFile, mexFileDestination, 'f');
	
	% apply a strategy for each mode
	if strcmp(mode, 'add')
		destinationSystem = destination;
		blockHandle = add_block(sFunctionSource, generateUniquePath(destinationSystem, mexFileName));
	elseif strcmp(mode, 'replace')
		replacedBlock = destination;
		replacedBlockPosition = get_param(replacedBlock, 'Position');
		delete_block(replacedBlock);
		blockHandle = add_block(sFunctionSource, replacedBlock, 'Position', replacedBlockPosition);
	end
	
	set_param(blockHandle, 'FunctionName', mexFileName);
end

function uniquePath = generateUniquePath(sys, name)
    uniquePath = [sys, '/', name];
    count = 0;
    while ~isempty(find_system(uniquePath))
        count = count + 1;
        uniquePath = [sys, '/', name, num2str(count)];
    end
end