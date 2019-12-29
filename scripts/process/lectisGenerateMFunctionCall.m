function functionCall = lectisGenerateMFunctionCall(func)
    
    % argument count
    inputs  = 1;
    params  = 1;
    outputs = 1;
    
    % put the return value
    if ~isempty(func.returnType)
        functionCall = [func.returnType, ' y1 ='];
        outputs = outputs + 1;
    else
        functionCall = 'void';
    end
    
    % function name
    functionCall = [functionCall, ' ', func.name, '('];
    
    % iterate over arguments
    for iArgument = 1:length(func.arguments)
        argument = func.arguments(iArgument);
        
        if iArgument > 1
            functionCall = [functionCall, ', '];
        end
        
        % add name
        switch argument.type
            case 'input'
                functionCall = [functionCall, argument.dataType, ' u', num2str(inputs)];
                inputs = inputs + 1;
            case 'parameter'
                functionCall = [functionCall, argument.dataType, ' p', num2str(params)];
                params = params + 1;
            case 'output'
                functionCall = [functionCall, argument.dataType, ' y', num2str(outputs)];
                outputs = outputs + 1;
        end
        
        % add dimension
        for dimension = argument.dimensions
            functionCall = [functionCall, '[', num2str(dimension), ']'];
        end
    end
    
    % finish the function definition
    functionCall = [functionCall, ')'];
end

