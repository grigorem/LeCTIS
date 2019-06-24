%% Application initialization functions
function varargout = lectis(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename,...
                       'gui_Singleton',  gui_Singleton,...
                       'gui_OpeningFcn', @LeCTIS_OpeningFcn,...
                       'gui_OutputFcn',  @LeCTIS_OutputFcn,...
                       'gui_LayoutFcn',  [],...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
end


function LeCTIS_OpeningFcn(hObject, eventdata, handles, varargin)
    
    % put this path and it's subfolders in matlab path
    addpath(genpath(fileparts(mfilename('fullpath'))));
    
    % put the window in the middle of the screen
    screenSize = get(groot, 'ScreenSize');
    windowPosition = get(hObject, 'Position');
    
    newWindowPosition = windowPosition;
    newWindowPosition(1) = floor(screenSize(3) / 2) - floor(windowPosition(3) / 2);
    newWindowPosition(2) = floor(screenSize(4) / 2) - floor(windowPosition(4) / 2);
    
    set(hObject, 'Position', newWindowPosition);
    
    % hide source panel
    set(handles.panelSource, 'Visible', 'off');
    
    % create steps panels and next available variables
    stepsPanels = { 'panelWelcome',		[];
                    'panelFunctions',	[];
                    'panelFiles',		[];
                    'panelOptions',		[];
                    'panelGenerate',	[]};
	nextAvailable = [true, false(1, length(stepsPanels) - 1)];
	
	% set the previus variables as app data
    setappdata(handles.panelGlobal, 'stepsPanels', stepsPanels);
	setappdata(handles.panelGlobal, 'nextAvailable', nextAvailable);
    setappdata(handles.panelGlobal, 'currentStep', 0);
    
    % "click" on the "Next" button to initialize panels
    clickNextButton = get(handles.buttonStepNext, 'Callback');
    clickNextButton(handles.buttonStepNext, []);
end


function varargout = LeCTIS_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = hObject;
end

%% UI controls callbacks
