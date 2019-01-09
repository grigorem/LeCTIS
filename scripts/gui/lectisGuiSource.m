%% Application initialization function
function lectisGuiSource(varargin)
    gui_State = struct('gui_Name',       'lectis',...
                       'gui_Singleton',  true,...
                       'gui_OpeningFcn', [],...
                       'gui_OutputFcn',  [],...
                       'gui_LayoutFcn',  [],...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
        gui_mainfcn(gui_State, varargin{:});
    end
end


%% UI controls callbacks
function radioSourceFile_Callback(hObject, eventdata, handles)
    
    % make sure that this radio control is checked
    set(hObject, 'Value', true);
    
    % disable the other radio control
    set(handles.radioSourceStub, 'Value', false);
    
    % hide the other controls
    set(handles.staticSourceStub, 'Visible', 'off');
    set(handles.editSourceStub,   'Visible', 'off');
    set(handles.buttonSourceStub, 'Visible', 'off');
    
    % show the current controls
    set(handles.staticSourceFile, 'Visible', 'on');
    set(handles.editSourceFile,   'Visible', 'on');
    set(handles.buttonSourceFile, 'Visible', 'on');
end


function radioSourceStub_Callback(hObject, eventdata, handles)
        
    % make sure that this radio control is checked
    set(hObject, 'Value', true);
    
    % disable the other radio control
    set(handles.radioSourceFile, 'Value', false);
    
    % hide the other controls
    set(handles.staticSourceFile, 'Visible', 'off');
    set(handles.editSourceFile,   'Visible', 'off');
    set(handles.buttonSourceFile, 'Visible', 'off');
    
    % show the current controls
    set(handles.staticSourceStub, 'Visible', 'on');
    set(handles.editSourceStub,   'Visible', 'on');
    set(handles.buttonSourceStub, 'Visible', 'on');
end


function buttonSourceFile_Callback(hObject, eventdata, handles)
    % choose soource file
    [sourceName, sourcePath] = uigetfile({'*.c;*.cpp', 'C/C++ source file'}, 'Choose a C/C++ source file');

    if ~ischar(sourceName) || ~ischar(sourcePath)
        return
    end

    % create file path
    sourceFile = [sourcePath, sourceName];

    % process the new c file
    processSourceFile(handles, sourceFile);
end


function buttonSourceStub_Callback(hObject, eventdata, handles)
    
end

%% non UI functions

function processSourceFile(handles, sourceFile)
    
    % check source file
    if ~exist(sourceFile, 'file')
        msgbox('The chosen source file does not exist', 'Source not existing', 'error', 'modal');
        return
    end
    
    % extract functions
    [extractedFunctions, extractionStatus] = lectisExtractFunctions(sourceFile);
    
    % check functions
    if isempty(extractedFunctions)
        msgbox(['Source file could not be added: ', extractionStatus], 'Source file error', 'error', 'modal');
        return
    end
    
    % set the source file in the interface
    set(handles.editSourceFile, 'String', sourceFile);
    
    % put the inputs/outputs in the next panel
    lectisGuiIo('addFunctionsToGui', extractedFunctions, handles);
end