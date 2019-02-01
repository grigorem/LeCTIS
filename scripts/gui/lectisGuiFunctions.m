%% Application initialization functions
function lectisGuiFunctions(varargin)
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

function buttonFunctionsSelect_Callback(hObject, eventdata, handles)
    
    match = regexp(get(hObject, 'Tag'), 'buttonFunctions(\w+)Select', 'tokens', 'once');
    
    if isempty(match)
        return
    end
    
    functionType = match{1};
    
    % hide the functions panel
    set(handles.panelFunctions, 'Visible', 'off');
    
    % set the type of the function in the appdata
    lectisGuiSource('initFunctionChoosing', handles, functionType);
end

%% non UI functions

function addChosenFunction(handles, functionType, functionDefinition, sourcePath)

    % put the function definition and source path in their corresponding textboxes
    switch functionType
        case 'Output'
            set(handles.editFunctionsOutputSource, 'String', sourcePath);
            set(handles.editFunctionsOutputDefinition, 'String', functionDefinition);
            set(handles.editFunctionsOutputDefinition, 'TooltipString', functionDefinition);
        case 'Initialization'
            set(handles.editFunctionsInitializationSource, 'String', sourcePath);
            set(handles.editFunctionsInitializationDefinition, 'String', functionDefinition);
            set(handles.editFunctionsInitializationDefinition, 'TooltipString', functionDefinition);
        case 'Start'
            set(handles.editFunctionsStartSource, 'String', sourcePath);
            set(handles.editFunctionsStartDefinition, 'String', functionDefinition);
            set(handles.editFunctionsStartDefinition, 'TooltipString', functionDefinition);
        case 'Terminate'
            set(handles.editFunctionsTerminateSource, 'String', sourcePath);
            set(handles.editFunctionsTerminateDefinition, 'String', functionDefinition);
            set(handles.editFunctionsTerminateDefinition, 'TooltipString', functionDefinition);
    end
    
    % show the panel
    set(handles.panelFunctions, 'Visible', 'on');
end

function cancelFunctionChoosing(handles)
    set(handles.panelFunctions, 'Visible', 'on');
end