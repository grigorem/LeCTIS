function [status, result] = lectisGetMatlabType(codeType)
    
    % default
    status = false;
    
    % remove "*" from code (pointers)
    codeType = regexprep(codeType, '\*', '');
    
    % remove spaces from the beginning or from the end of the string
    codeType = regexprep(codeType, '^ *| *$', '');
    
    % remove unncessary spaces
    codeType = regexprep(codeType, ' +', ' ');

    % apply switch on code type variable
    switch codeType
        
        case {'const', 'void'}
            matlabType = '';
        
        case {'char', 'byte', 's8'}
            matlabType = 'int8';
            
        case {'unsigned char', 'flag', 'u8'}
            matlabType = 'uint8';
            
        case {'short', 's16'}
            matlabType = 'int16';
            
        case {'unsigned short', 'u16'}
            matlabType = 'uint16';
            
        case {'int', 'long', 's32'}
            matlabType = 'int32';
            
        case {'unsigned int', 'unsigned long', 'u32'}
            matlabType = 'uint32';
            
        case {'float', 'f32'}
            matlabType = 'single';
            
        case {'double', 'f64'}
            matlabType = 'double';
            
        %%%% add here new cases %%%
        
        % case {'ctype1'}
        %     matlabType = 'mtype1';
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        otherwise
            result = 'Could not find a match between code type and matlab type';
            return
    end
    
    % set the outputs
    result = matlabType;
    status = true;
end

