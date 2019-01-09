%% Application initialization functions
function lectisGuiDestination(varargin)
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

function radioDestinationBlock_Callback(hObject, eventdata, handles)

end

function radioDestinationMultiple_Callback(hObject, eventdata, handles)

end

function radioDestinationAdd_Callback(hObject, eventdata, handles)

end