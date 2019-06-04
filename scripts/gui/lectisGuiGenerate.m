%% Application initialization functions
function lectisGuiGenerate(varargin)
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

function buttonGenerateOutput_Callback(hObject, eventdata, handles)
	% choose output directory
    outputDirectory = uigetdir(pwd, 'Choose S-Function output directory');

	if ~ischar(outputDirectory) || isempty(outputDirectory)
        return
	end
	
	% set the directory in the text box
	set(handles.editGenerateOutput, 'String', outputDirectory);
end

function buttonGenerate_Callback(hObject, eventdata, handles)
	
end


%% UI controls callbacks