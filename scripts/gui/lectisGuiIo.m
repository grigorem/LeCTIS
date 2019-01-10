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
        '-not', 'Tag', 'staticIoVariableType',...
        '-not', 'Tag', 'staticIoInput',...
        '-not', 'Tag', 'staticIoOutput',...
        '-not', 'Tag', 'staticIoDimension'));
    
    % structure where the handles to the current ios options will be added
    currentIos = struct('input', [], 'output', [], 'dimension', []);
    currentIos = currentIos(1:0);
    
    % add ios to the interface
    ioCallback = @(hObject, eventdata)lectisGuiIo('checkboxIo_Callback', hObject, eventdata, guidata(hObject));
    for iIo = 1:length(ios)
        
        % current element
        io = ios(iIo);
        
        % position in the panel on Y axis
        ioY = 320 - 20 * iIo;
        
        % ios state
        if strcmp(io.name, 'return')
            inputValue  = false;
            outputValue = true;
            ioEnable    = 'off';
            if ~isempty(io.pointer)
                dimensionEnable = 'on';
            else
                dimensionEnable = 'off';
            end
        else
            if ~isempty(io.pointer)
                inputValue      = false;
                outputValue     = true;
                ioEnable        = 'on';
                dimensionEnable = 'on';
            else
                inputValue      = true;
                outputValue     = false;
                ioEnable        = 'off';
                dimensionEnable = 'off';
            end
        end
        
        % add var name
        namePosition = [10, ioY, 140, 15];
        nameTag      = ['staticIoName', num2str(iIo)];
        uicontrol(handles.panelIoIos,...
            'Style',               'text',...
            'BackgroundColor',     [1, 1, 1],...
            'HorizontalAlignment', 'left',...
            'String',              char(io.name),...
            'Units',               'pixels',...
            'Position',            namePosition,...
            'Tag',                 char(nameTag));
        
        % add var type
        typePosition = [150, ioY, 140, 15];
        typeTag      = ['staticIoType', num2str(iIo)];
        uicontrol(handles.panelIoIos,...
            'Style',               'text',...
            'BackgroundColor',     [1, 1, 1],...
            'HorizontalAlignment', 'left',...
            'String',              char([io.type, io.pointer]),...
            'Units',               'pixels',...
            'Position',            typePosition,...
            'Tag',                 char(typeTag));
        
        % add input checkbox
        inputPosition = [290, ioY, 25, 15];
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
            'Enable',          ioEnable);
        
        % add output checkbox
        outputPosition = [320, ioY, 25, 15];
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
            'Enable',          ioEnable);
        
        % add dimension text box
        dimensionPosition = [350, ioY, 40, 15];
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
        set(inputHandle,  'UserData', outputHandle);
        set(outputHandle, 'UserData', inputHandle);
        
        % add input, output and dimension handles to current inputs/outputs structure
        currentIos(iIo).input     = inputHandle;
        currentIos(iIo).output    = outputHandle;
        currentIos(iIo).dimension = dimensionHandle;
    end
end