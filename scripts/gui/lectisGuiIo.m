%% Application initialization functions
function varargout = guiIo(varargin)

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