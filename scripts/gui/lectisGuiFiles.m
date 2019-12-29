%% Application initialization functions
function lectisGuiFiles(varargin)
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

function buttonFilesAdd_Callback(hObject, eventdata, handles)
	switch get(hObject, 'Tag')
		case 'buttonFilesSourcesHeadersAdd'
			fileFilter = {'*.c;*.cpp;*.h', 'C/C++ sources and headers'};
			listboxHandle = handles.listboxFilesSourcesHeaders;
		case 'buttonFilesHostAdd'
			fileFilter = {'*.lib', 'Host library files'; '*.*', 'All files'};
			listboxHandle = handles.listboxFilesHost;
		case 'buttonFilesTargetAdd'
			fileFilter = {'*.lib', 'Target library files'; '*.*', 'All files'};
			listboxHandle = handles.listboxFilesTarget;
	end
	
	[files, filesFolder] = uigetfile(fileFilter, 'MultiSelect', 'on');
	
	if isnumeric(files)
		return
	end
	
	if iscell(files)
		files = cellfun(@(file) fullfile(filesFolder, file), files, 'UniformOutput', false);
		addFilesToListbox(listboxHandle, files);
	end
	
	if ischar(files)
		addFilesToListbox(listboxHandle, {fullfile(filesFolder, files)});
	end
end

function buttonFilesRemove_Callback(hObject, eventdata, handles)
	switch get(hObject, 'Tag')
		case 'buttonFilesSourcesHeadersRemove'
			listboxHandle = handles.listboxFilesSourcesHeaders;
		case 'buttonFilesHostRemove'
			listboxHandle = handles.listboxFilesHost;
		case 'buttonFilesTargetRemove'
			listboxHandle = handles.listboxFilesTarget;
	end
	
	files = get(listboxHandle, 'String');
	if ~isempty(files)
		files(get(listboxHandle, 'Value')) = [];
		set(listboxHandle, 'String', files);
	end
end

%% non UI functions

function addFilesToListbox(listboxHandle, newFiles)
	% get all the existing files in the listbox
	existingFiles = get(listboxHandle, 'String');
	
	% extract only the name and the extension
	existingFileNames = cell(1, length(existingFiles));
	for iExistingFile = 1:length(existingFiles)
		[~, existingFileName, existingFileExt] = fileparts(existingFiles{iExistingFile});
		existingFileNames{iExistingFile} = [existingFileName, existingFileExt];
	end
	
	% iterate over each new file
	for iNewFile = 1:length(newFiles)
		[~, newFileName, newFileExt] = fileparts(newFiles{iNewFile});
		
		if ~any(ismember(existingFileNames, [newFileName, newFileExt]))
			existingFiles{end + 1} = newFiles{iNewFile};
		end
	end
	
	% set the modified file list
	set(listboxHandle, 'String', existingFiles);
end