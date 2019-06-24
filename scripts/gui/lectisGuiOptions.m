%% Application initialization functions
function lectisGuiOptions(varargin)
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

function dropdownOptionsSampleTime_Callback(hObject, eventdata, handles)
	sampleTimes = get(hObject, 'String');
	sampleTime = strtrim(sampleTimes{get(hObject, 'Value')});
	
	if strcmp(sampleTime, 'fixed')
		set(handles.editOptionsSampleTime, 'Enable', 'on');
	else
		set(handles.editOptionsSampleTime, 'Enable', 'off');
	end
end