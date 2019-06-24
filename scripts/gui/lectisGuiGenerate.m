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
	lct = struct;
	
	% set the S-Function name
	lct.SFunctionName = get(handles.editGenerateName, 'String');
	
	% set the functions definitions
	lct.InitializeConditionsFcnSpec = get(handles.editFunctionsInitializationDefinition,	'String');
	lct.OutputFcnSpec				= get(handles.editFunctionsOutputDefinition,			'String');
	lct.StartFcnSpec				= get(handles.editFunctionsStartDefinition,				'String');
	lct.TerminateFcnSpec			= get(handles.editFunctionsTerminateDefinition,			'String');
	
	% set the source files and headers
	lct.HeaderFiles	= {};
	lct.SourceFiles	= {};
	lct.SrcPaths	= {};
	lct.IncPaths	= {};
	
	files = get(handles.listboxFilesSourcesHeaders, 'String');
	for iFile = 1:length(files)
		[filePath, fileName, fileExt] = fileparts(files{iFile});
		if strcmp(fileExt, '.c')
			lct.SourceFiles{end + 1} = [fileName, fileExt];
			if ~any(ismember(lct.SrcPaths, filePath))
				lct.SrcPaths{end + 1} = filePath;
			end
		else
			lct.HeaderFiles{end + 1} = [fileName, fileExt];
			if ~any(ismember(lct.IncPaths, filePath))
				lct.IncPaths{end + 1} = filePath;
			end
		end
	end
	
	% set the host library files
	lct.HostLibFiles	= {};
	lct.LibPaths = {};
	
	files = get(handles.listboxFilesHost, 'String');
	for iFile = 1:length(files)
		lct.HostLibFiles{end + 1} = [fileName, fileExt];
		if ~any(ismember(lct.LibPaths, filePath))
			lct.LibPaths{end + 1} = filePath;
		end
	end
	
	% set the target library files
	lct.TargetLibFiles	= {};
	
	files = get(handles.listboxFilesTarget, 'String');
	for iFile = 1:length(files)
		lct.TargetLibFiles{end + 1} = [fileName, fileExt];
		if ~any(ismember(lct.LibPaths, filePath))
			lct.LibPaths{end + 1} = filePath;
		end
	end
	
	
	% set the sample time
	lct.SampleTime = get(handles.dropdownOptionsSampleTime, 'String');
	lct.SampleTime = lct.SampleTime{get(handles.dropdownOptionsSampleTime, 'Value')};
	if strcmp(lct.SampleTime, 'fixed')
		lct.SampleTime = eval(get(handles.editOptionsSampleTime, 'String'));
	end
	
	% set the options
	opt										= struct;
	opt.isMacro								= logical(get(handles.checkboxOptionsIsMacro,				'Value'));
	opt.isVolatile							= logical(get(handles.checkboxOptionsIsVolatile,			'Value'));
	opt.canBeCalledConditionally			= logical(get(handles.checkboxOptionsCalledConditionally,	'Value'));
	opt.useTlcWithAccel						= logical(get(handles.checkboxOptionsTlcWithAccelerator,	'Value'));
	opt.singleCPPMexFile					= logical(get(handles.checkboxOptionsSingleCpp,				'Value'));
	opt.supportsMultipleExecInstances		= logical(get(handles.checkboxOptionsSupportMultiple,		'Value'));
	opt.convertNDArrayToRowMajor			= logical(get(handles.checkboxOptionsConvertArray,			'Value'));
	opt.supportCoverage						= logical(get(handles.checkboxOptionsCoverage,				'Value'));
	opt.supportCoverageAndDesignVerifier	= logical(get(handles.checkboxOptionsCoverageDesign,		'Value'));
	opt.outputsConditionallyWritten			= logical(get(handles.checkboxOptionsConditionalOutputs,	'Value'));
	
	opt.language = get(handles.dropdownOptionsLanguage, 'String');
	opt.language = strtrim(opt.language{get(handles.dropdownOptionsLanguage, 'Value')});
	
	lct.Options = opt;
	
	legacy_code('sfcn_cmex_generate', lct);
	legacy_code('compile', lct);
end


%% UI controls callbacks