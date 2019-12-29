%% Application initialization function
function lectisGuiGlobal(varargin)
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
function buttonStepNext_Callback(hObject, eventdata, handles)
    
    % get info from the appdata
    stepsPanels = getappdata(handles.panelGlobal, 'stepsPanels');
    currentStep = getappdata(handles.panelGlobal, 'currentStep');
	nextAvailable = getappdata(handles.panelGlobal, 'nextAvailable');
    
	if currentStep == 0 || nextAvailable(currentStep)
		switchActivePanel(stepsPanels, currentStep + 1, handles);
	else
		msgbox('Could not go NEXT. Please fill any of the required fields.', 'Error', 'error', 'modal');
	end
end

function buttonStepBack_Callback(hObject, eventdata, handles)
    % get info from the appdata
    stepsPanels = getappdata(handles.panelGlobal, 'stepsPanels');
    currentStep = getappdata(handles.panelGlobal, 'currentStep');
    
    switchActivePanel(stepsPanels, currentStep - 1, handles);
end

%% other functions

function switchActivePanel(panels, currentStep, handles)
    
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