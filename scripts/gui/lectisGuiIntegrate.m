%% Application initialization function
function lectisGuiIntegrate(varargin)
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

function buttonIntegrate_Callback(hObject, eventdata, handles)

end

function radioIntegrateAdd_Callback(hObject, eventdata, handles)
	% defaults
	visibleAdd			= 'off';
	visibleReplace		= 'off';
	visibleReplaceAll	= 'off';
	
	% set what to show for each case
	switch get(hObject, 'Tag')
		case 'radioIntegrateAdd'
			visibleAdd = 'on';
		case 'radioIntegrateReplace'
			visibleReplace = 'on';
		case 'radioIntegrateReplaceAll'
			visibleReplaceAll = 'on';
	end
	
	% hide/show controls
	set(handles.editIntegrateSystem, 'Visible', visibleAdd);
	set(handles.buttonIntegrateSystem, 'Visible', visibleAdd);
	
	set(handles.editIntegrateBlock, 'Visible', visibleReplace);
	set(handles.buttonIntegrateBlock, 'Visible', visibleReplace);
	
	set(handles.editIntegrateAll, 'Visible', visibleReplaceAll);
	set(handles.buttonIntegrateAll, 'Visible', visibleReplaceAll);
	set(handles.staticIntegratePattern, 'Visible', visibleReplaceAll);
	set(handles.editIntegratePattern, 'Visible', visibleReplaceAll);
	
	% set radio buttons corresponding
	set(handles.radioIntegrateAdd, 'Value', strcmp(visibleAdd, 'on'));
	set(handles.radioIntegrateReplace, 'Value', strcmp(visibleReplace, 'on'));
	set(handles.radioIntegrateReplaceAll, 'Value', strcmp(visibleReplaceAll, 'on'));
end