%% Application initialization functions
function lectisGuiGlobal(varargin)
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
function buttonStepNext_Callback(hObject, eventdata, handles)
    
    % get info from the appdata
    stepsPanels = getappdata(handles.panelGlobal, 'stepsPanels');
    currentStep = getappdata(handles.panelGlobal, 'currentStep') + 1;
    
    setPanelActive(stepsPanels, currentStep, handles)
        
end

function buttonStepBack_Callback(hObject, eventdata, handles)
    % get info from the appdata
    stepsPanels = getappdata(handles.panelGlobal, 'stepsPanels');
    currentStep = getappdata(handles.panelGlobal, 'currentStep') - 1;
    
    setPanelActive(stepsPanels, currentStep, handles)
end

%% other functions

function setPanelActive(panels, currentStep, handles)
    
    % return if index exceeds limits
    if currentStep < 1 || currentStep > length(panels)
        return
    end
    
    % hide all panels
    for iPanel = 1:length(panels)
        set(handles.(panels{iPanel}), 'Visible', 'off');
    end
    
    % show only the selected panel
    set(handles.(panels{currentStep}), 'Visible', 'on');
    
    % set the appdata back
    setappdata(handles.panelGlobal, 'currentStep', currentStep);
end