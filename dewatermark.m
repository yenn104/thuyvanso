function varargout = dewatermark(varargin)
% DEWATERMARK MATLAB code for dewatermark.fig
%      DEWATERMARK, by itself, creates a new DEWATERMARK or raises the existing
%      singleton*.
%
%      H = DEWATERMARK returns the handle to a new DEWATERMARK or the handle to
%      the existing singleton*.
%
%      DEWATERMARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEWATERMARK.M with the given input arguments.
%
%      DEWATERMARK('Property','Value',...) creates a new DEWATERMARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dewatermark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dewatermark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dewatermark

% Last Modified by GUIDE v2.5 26-Mar-2023 14:02:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dewatermark_OpeningFcn, ...
                   'gui_OutputFcn',  @dewatermark_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dewatermark is made visible.
function dewatermark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dewatermark (see VARARGIN)

% Choose default command line output for dewatermark
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dewatermark wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global ext_algorithm
ext_algorithm = 'lsb';
set(handles.btnImportGoc,'Enable','off')


% --- Outputs from this function are returned to the command line.
function varargout = dewatermark_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Lựa chọn thuật toán trích xuất thủy vân
function rdLSB_Callback(hObject, eventdata, handles)
global ext_algorithm
ext_algorithm = 'lsb';
set(handles.btnImportGoc,'Enable','off')
set(handles.btnSelectKey,'Enable','on')

function rdDCT_Callback(hObject, eventdata, handles)
global ext_algorithm
ext_algorithm = 'dct';
set(handles.btnImportGoc,'Enable','on')
set(handles.btnSelectKey,'Enable','off')

function rdDWT_Callback(hObject, eventdata, handles)
global ext_algorithm
ext_algorithm = 'dwt';
set(handles.btnImportGoc,'Enable','on')
set(handles.btnSelectKey,'Enable','off')



% --- Executes on button press in btnImportEmbed.
function btnImportEmbed_Callback(hObject, eventdata, handles)
global ext_algorithm;
if(ext_algorithm == 'lsb')
    [fname, path] = uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn ảnh đã nhúng thủy vân');
    if fname~=0
        img = imread([path,fname]);
        try
            % For four channel tiff images
            img = img(:,:,1:3);
        catch lasterr
        end
        axes(handles.axes1);
        imshow(img);
        title('Ảnh cần trích xuất', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');
        handles.extimage = img;
        set(handles.btnextract,'Enable','on')
    else
        warndlg('Hãy chọn ảnh đã nhúng thủy vân');
    end
elseif(ext_algorithm == 'dwt')
    [fname, path] = uigetfile('*.fits','Chọn ảnh đã nhúng thủy vân');
    if fname~=0
        dwt_wmd = fitsread([path,fname]);
        handles.extimage = dwt_wmd;
        display_img = uint8(dwt_wmd);
        axes(handles.axes1);
        imshow(display_img);
        title('Ảnh cần trích xuất', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');
        set(handles.btnextract,'Enable','on')
    else
        warndlg('Hãy chọn ảnh đã nhúng thủy vân');
    end
elseif(ext_algorithm == 'dct')
    [fname, path] = uigetfile('*.fits','Chọn ảnh đã nhúng thủy vân');
    if fname~=0
        dwt_wmd = fitsread([path,fname]);
        handles.extimage = dwt_wmd;
        display_img = dwt_wmd;
        axes(handles.axes1);
        imshow(display_img);
        title('Ảnh cần trích xuất', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');
        set(handles.btnextract,'Enable','on')
    else
        warndlg('Hãy chọn ảnh đã nhúng thủy vân');
    end
end
guidata(hObject,handles);




% --- Executes on button press in btnImportGoc.
function btnImportGoc_Callback(hObject, eventdata, handles)
[fname, path] = uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn ảnh gốc');
if fname~=0
    origin_img = imread([path,fname]);
    try
        % For four channel tiff images
        origin_img = origin_img(:,:,1:3);
    catch lasterr
    end
    
    axes(handles.axes2);
    imshow(origin_img);
    title('Ảnh gốc', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');
    handles.origin_img = origin_img;
else
    warndlg('Hãy chọn ảnh gốc');
end
guidata(hObject,handles);




% --- Executes on button press in btnSelectKey.
function btnSelectKey_Callback(hObject, eventdata, handles)
[fname, path] = uigetfile({'*.txt'},'Chọn file khóa');
if fname~=0
    keyfile = fopen([path, fname], 'r');
    key = fscanf(keyfile, '%d');
    handles.extkey = key;
    set(handles.keys,'String',num2str(key));
    fclose(keyfile);
else
    warndlg('Hãy chọn tệp chứa khóa!');
end
guidata(hObject,handles);


% --- Executes on button press in btnextract.
function btnextract_Callback(hObject, eventdata, handles)
global ext_algorithm

img = handles.extimage;

if(ext_algorithm=='lsb')
    tic;
    watermark = extract_lsb(img, handles.extkey); %Trích xuất sử dụng khóa
    exttime = toc;
    set(handles.exttime,'String',exttime);
    folder_path = './dataset/lsb';
elseif(ext_algorithm=='dct')
    tic;
    origin_image = handles.origin_img;
    watermark = extract_dct(img, origin_image);
    exttime = toc;
    set(handles.exttime,'String',exttime);
    folder_path = './dataset/dct';
elseif(ext_algorithm=='dwt')
    tic;
    origin_image = handles.origin_img;
    watermark = extract_dwt(img, origin_image);
    exttime = toc;
    set(handles.exttime,'String',exttime);
    folder_path = './dataset/dwt';
else
    return
end

% Lưu hình ảnh sau khi nhúng thủy vân
%save_image('Lưu thủy vân trích xuất được', watermark);
%folder_path = './dataset';
file_name = 'watermark_.png';
full_path = fullfile(folder_path, file_name);
imwrite(watermark, full_path);

axes(handles.axes3);
imshow(watermark);
title("Thủy vân trích xuất được", 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');



% --- Executes on button press in btnRefresh.
function btnRefresh_Callback(hObject, eventdata, handles)
axes(handles.axes1); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes2); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes3); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
set(handles.keys,'String','');
set(handles.exttime,'String','');


% --- Executes on button press in btnBackMenu.
function btnBackMenu_Callback(hObject, eventdata, handles)
close;
main_menu
