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
	% mex file
	mexFile = getappdata(handles.panelGenerate, 'mexFile');
	
	% take for each case
	if get(handles.radioIntegrateAdd, 'Value')
		mode = 'add';
		destination = get(handles.editIntegrateSystem, 'String');
	elseif get(handles.radioIntegrateReplace, 'Value')
		mode = 'replace';
		destination = get(handles.editIntegrateBlock, 'String');
	end
	
	% check destination
	systemSplit = strsplit(destination, '/');
	modelName = systemSplit{1};
	if ~isvarname(modelName) || ~bdIsLoaded(modelName)
		msgbox('Specified model is not loaded', 'Error', 'error');
		return
	end

	if length(systemSplit) > 1 && getSimulinkBlockHandle(destination) == -1
		msgbox('Specified block does not exist', 'Error', 'error');
		return
	end
	
	% integrate
	newBlock = lectisIntegrateSFunction(mexFile, modelName, mode, destination);
	
	% hilight the new block
	hilite_system(newBlock);
end

function radioIntegrate_Callback(hObject, eventdata, handles)
	% defaults
	visibleAdd			= 'off';
	visibleReplace		= 'off';
	
	% set what to show for each case
	switch get(hObject, 'Tag')
		case 'radioIntegrateAdd'
			visibleAdd = 'on';
		case 'radioIntegrateReplace'
			visibleReplace = 'on';
	end
	
	% hide/show controls
	set(handles.editIntegrateSystem, 'Visible', visibleAdd);
	set(handles.buttonIntegrateSystem, 'Visible', visibleAdd);
	
	set(handles.editIntegrateBlock, 'Visible', visibleReplace);
	set(handles.buttonIntegrateBlock, 'Visible', visibleReplace);
	
	% set radio buttons corresponding
	set(handles.radioIntegrateAdd, 'Value', strcmp(visibleAdd, 'on'));
	set(handles.radioIntegrateReplace, 'Value', strcmp(visibleReplace, 'on'));
end

function buttonIntegrateModel_Callback(hObject, eventdata, handles)
	if ~isempty(gcs)
		systemSplit = strsplit(gcs, '/');
		set(handles.editIntegrateModel, 'String', systemSplit{1});
	end
end

function buttonIntegrateSystem_Callback(hObject, eventdata, handles)
	set(handles.editIntegrateSystem, 'String', gcs);
end

function buttonIntegrateBlock_Callback(hObject, eventdata, handles)
	set(handles.editIntegrateBlock, 'String', gcb);
end