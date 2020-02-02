function sfHandle = lectisIntegrateSFunction(mexFile, modelName, mode, destination)
	
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
		sfHandle = add_block(sFunctionSource, generateUniquePath(destinationSystem, mexFileName));
        set_param(sfHandle, 'FunctionName', mexFileName);
	elseif strcmp(mode, 'replace')
        currentSystem = get_param(destination, 'Parent');
        
        % get the info from the replaced block and delete it
		replacedBlock = destination;
		replacedBlockPosition = get_param(replacedBlock, 'Position');
        replacedBlockLineHandles = get_param(replacedBlock, 'LineHandles');
		delete_block(replacedBlock);
        
        % create the S-Function block
		sfHandle = add_block(sFunctionSource, replacedBlock, 'Position', replacedBlockPosition);
        set_param(sfHandle, 'FunctionName', mexFileName);
        
        % compare the inputs/outputs to the ones of the replaced block
        sfPortHandles = get_param(sfHandle, 'PortHandles');
        eqIn = length(sfPortHandles.Inport) == length(replacedBlockLineHandles.Inport);
        eqOut = length(sfPortHandles.Outport) == length(replacedBlockLineHandles.Outport);
        if ~eqIn || ~eqOut
            msgbox('S-Function has different number of inputs or outputs so will not be connected', 'Inputs/outputs differ', 'warn');
            return
        end
        
        % connect inputs
        for iIn = 1:length(sfPortHandles.Inport)
            portIn = sfPortHandles.Inport(iIn);
            lineIn = replacedBlockLineHandles.Inport(iIn);
            portOut = get_param(lineIn, 'SrcPortHandle');
            
            delete_line(lineIn);
            add_line(currentSystem, portOut, portIn, 'autorouting', 'on');
        end
        
        % connect outputs
        for iOut = 1:length(sfPortHandles.Outport)
            portOut = sfPortHandles.Outport(iOut);
            lineOut = replacedBlockLineHandles.Outport(iOut);
            portIn = get_param(lineOut, 'DstPortHandle');
            
            delete_line(lineOut);
            add_line(currentSystem, portOut, portIn, 'autorouting', 'on');
        end
    end
end

function uniquePath = generateUniquePath(sys, baseName)
    count = 0;
    name = baseName;
    while ~isempty(find_system(sys, 'SearchDepth', 1, 'Name', name))
        count = count + 1;
        name = [baseName, num2str(count)];
    end
    uniquePath = [sys, '/', name];
end