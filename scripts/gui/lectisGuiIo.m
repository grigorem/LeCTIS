%% Application initialization functions
function lectisGuiIo(varargin)
    gui_State = struct('gui_Name',       'lectis',...
                       'gui_Singleton',  true,...
                       'gui_OpeningFcn', [],...
                       'gui_OutputFcn',  [],...
                       'gui_LayoutFcn',  [],...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
        if endsWith(varargin{1}, 'Callback')
            gui_mainfcn(gui_State, varargin{:});     % run GUI callbacks
        else
            gui_State.gui_Callback(varargin{2:end}); % run other functions
        end
    end
end


%% UI controls callbacks
function listboxIoFunctions_Callback(hObject, eventdata, handles)
    
    % get functions from appadata
    functions = getappdata(handles.panelIo, 'functions');
    
    % get selected function index
    selectedFunction = get(handles.listboxIoFunctions, 'Value');
    
    % add the IOs to the panel
    addIos(functions(selectedFunction), handles);
end

function checkboxIo_Callback(hObject, eventdata, handles)
    % take the other checkbox handle
    theOtherCheckbox = get(hObject, 'UserData');
    
    % set the checkboxes
    set(hObject,          'Value', true);
    set(theOtherCheckbox, 'Value', false);
end

%% non UI functions

function addFunctionsToGui(functions, handles)
    
    % put the function names in the listbox
    set(handles.listboxIoFunctions, 'String', {functions.name});
    
    % set the functions to the panel's appdata
    setappdata(handles.panelIo, 'functions', functions);
    
    % run the callback for the listbox selection
    listboxIoFunctionsCallback = get(handles.listboxIoFunctions, 'Callback');
    listboxIoFunctionsCallback(handles.listboxIoFunctions, []);
end

function addIos(selectedFunction, handles)
    
    % get only the inputs/outputs
    ios = selectedFunction.args;
    
    % add return to the ios
    if ~isempty(selectedFunction.return)
        selectedFunction.return.name = 'return';
        ios = [selectedFunction.return, ios']';
    end
    
    % remove ios if there are already there
    delete(findobj(handles.panelIoIos,...
        '-not', 'Tag', 'panelIoIos',...
        '-not', 'Tag', 'staticIoVariableName',...
        '-not', 'Tag', 'staticIoVariableCodeType',...
        '-not', 'Tag', 'staticIoVariableMatlabType',...
        '-not', 'Tag', 'staticIoInput',...
        '-not', 'Tag', 'staticIoOutput',...
        '-not', 'Tag', 'staticIoDimension',...
        '-not', 'Tag', 'staticIoParameter'));
    
    % structure where the handles to the current ios options will be added
    currentIos = struct('input', [], 'output', [], 'dimension', []);
    currentIos = currentIos(1:0);
    
    % get columns Y value for the IOs
    namePosition       = get(handles.staticIoVariableName, 'Position');
    xName              = namePosition(1);
    
    codeTypePosition   = get(handles.staticIoVariableCodeType, 'Position');
    xCodeType          = codeTypePosition(1);
    
    matlabTypePosition = get(handles.staticIoVariableMatlabType, 'Position');
    xMatlabType        = matlabTypePosition(1);
    
    inputPosition      = get(handles.staticIoInput, 'Position');
    xInput             = inputPosition(1);
    
    outputPosition     = get(handles.staticIoOutput, 'Position');
    xOutput            = outputPosition(1);
    
    parameterPosition  = get(handles.staticIoParameter, 'Position');
    xParameter         = parameterPosition(1);
    
    dimensionPosition  = get(handles.staticIoDimension, 'Position');
    xDimension         = dimensionPosition(1);
    
    % add ios to the interface    
    ioCallback = @(hObject, eventdata)lectisGuiIo('checkboxIo_Callback', hObject, eventdata, guidata(hObject));
    for iIo = 1:length(ios)
        
        % current element
        io = ios(iIo);
        
        % position in the panel on Y axis
        yIo = 320 - 20 * iIo;
        
        % ios state
        if strcmp(io.name, 'return')
            inputValue  = false;
            outputValue = true;
            insEnable    = 'off';
            outEnable    = 'off';
            if ~isempty(io.pointer)
                dimensionEnable = 'on';
            else
                dimensionEnable = 'off';
            end
        else
            if ~isempty(io.pointer)
                inputValue      = false;
                outputValue     = true;
                insEnable       = 'on';
                outEnable       = 'on';
                dimensionEnable = 'on';
            else
                inputValue      = true;
                outputValue     = false;
                insEnable       = 'on';
                outEnable       = 'off';
                dimensionEnable = 'off';
            end
        end
        
        if isempty(io.mtype)
            matlabTypeEnable = 'on';
        else
            matlabTypeEnable = 'off';
        end
        
        % add var name
        namePosition = [xName, yIo, 150, 15];
        nameTag      = ['staticIoName', num2str(iIo)];
        uicontrol(handles.panelIoIos,...
            'Style',               'text',...
            'BackgroundColor',     [1, 1, 1],...
            'HorizontalAlignment', 'left',...
            'String',              char(io.name),...
            'Units',               'pixels',...
            'Position',            namePosition,...
            'Tag',                 char(nameTag));
        
        % add var C/C++ type
        codeTypePosition = [xCodeType, yIo, 110, 15];
        codeTypeTag      = ['staticIoCodeType', num2str(iIo)];
        uicontrol(handles.panelIoIos,...
            'Style',               'text',...
            'BackgroundColor',     [1, 1, 1],...
            'HorizontalAlignment', 'left',...
            'String',              char([io.type, io.pointer]),...
            'Units',               'pixels',...
            'Position',            codeTypePosition,...
            'Tag',                 char(codeTypeTag));
        
        % add matlab type text box
        matlabTypePosition = [xMatlabType, yIo, 100, 15];
        matlabTypeTag      = ['editIoMatlabType', num2str(iIo)];
        matlabTypeHandle   = uicontrol(handles.panelIoIos,...
            'Style',               'edit',...
            'BackgroundColor',     [1, 1, 1],...
            'HorizontalAlignment', 'left',...
            'String',              io.mtype,...
            'Units',               'pixels',...
            'Position',            matlabTypePosition,...
            'Tag',                 matlabTypeTag,...
            'Enable',              matlabTypeEnable);
        
        % add input checkbox
        inputPosition = [xInput, yIo, 25, 15];
        inputTag      = ['checkboxIoInput', num2str(iIo)];
        inputHandle   = uicontrol(handles.panelIoIos,...
            'Style',           'checkbox',...
            'BackgroundColor', [1, 1, 1],...
            'String',          '',...
            'Units',           'pixels',...
            'Position',        inputPosition,...
            'Tag',             inputTag,...
            'Callback',        ioCallback,...
            'Value',           inputValue,...
            'Enable',          insEnable);
        
        % add parameter checkbox
        parameterPosition = [xParameter, yIo, 25, 15];
        parameterTag      = ['checkboxIoOutput', num2str(iIo)];
        parameterHandle   = uicontrol(handles.panelIoIos,...
            'Style',           'checkbox',...
            'BackgroundColor', [1, 1, 1],...
            'String',          '',...
            'Units',           'pixels',...
            'Position',        parameterPosition,...
            'Tag',             parameterTag,...
            'Callback',        ioCallback,...
            'Value',           false,...
            'Enable',          insEnable);
        
        % add output checkbox
        outputPosition = [xOutput, yIo, 25, 15];
        outputTag      = ['checkboxIoOutput', num2str(iIo)];
        outputHandle   = uicontrol(handles.panelIoIos,...
            'Style',           'checkbox',...
            'BackgroundColor', [1, 1, 1],...
            'String',          '',...
            'Units',           'pixels',...
            'Position',        outputPosition,...
            'Tag',             outputTag,...
            'Callback',        ioCallback,...
            'Value',           outputValue,...
            'Enable',          outEnable);
        
        % add dimension text box
        dimensionPosition = [xDimension, yIo, 40, 15];
        dimensionTag      = ['editIoDimension', num2str(iIo)];
        dimensionHandle   = uicontrol(handles.panelIoIos,...
            'Style',           'edit',...
            'BackgroundColor', [1, 1, 1],...
            'String',          '1',...
            'Units',           'pixels',...
            'Position',        dimensionPosition,...
            'Tag',             dimensionTag,...
            'Enable',          dimensionEnable);
        
        % link checkboxes to each other
        set(inputHandle,     'UserData', [outputHandle, parameterHandle]);
        set(outputHandle,    'UserData', [inputHandle, parameterHandle]);
        set(parameterHandle, 'UserData', [inputHandle, outputHandle]);
        
        % add input, output and dimension handles to current inputs/outputs structure
        currentIos(iIo).matlabType = matlabTypeHandle;
        currentIos(iIo).input      = inputHandle;
        currentIos(iIo).output     = outputHandle;
        currentIos(iIo).parameter  = parameterHandle;
        currentIos(iIo).dimension  = dimensionHandle;
    end
end