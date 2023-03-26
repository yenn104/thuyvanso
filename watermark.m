function varargout = watermark(varargin)
% WATERMARK MATLAB code for watermark.fig
%      WATERMARK, by itself, creates a new WATERMARK or raises the existing
%      singleton*.
%
%      H = WATERMARK returns the handle to a new WATERMARK or the handle to
%      the existing singleton*.
%
%      WATERMARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARK.M with the given input arguments.
%
%      WATERMARK('Property','Value',...) creates a new WATERMARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before watermark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to watermark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help watermark

% Last Modified by GUIDE v2.5 26-Mar-2023 14:01:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermark_OpeningFcn, ...
                   'gui_OutputFcn',  @watermark_OutputFcn, ...
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


% --- Executes just before watermark is made visible.
function watermark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to watermark (see VARARGIN)

% Choose default command line output for watermark
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes watermark wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global emb_algorithm
emb_algorithm = 'lsb';
set(handles.btn_insertwatermark,'Enable','off')
if(emb_algorithm =='lsb') 
    set(handles.secretkey,'Visible','on')
else    
    set(handles.secretkey,'Visible','off')
end


% --- Outputs from this function are returned to the command line.
function varargout = watermark_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in btnImportGoc.
% nhập ảnh gốc
function btnImportGoc_Callback(hObject, eventdata, handles)
[fname, path]=uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn ảnh gốc');
if fname~=0
    img = imread([path,fname]);
    try
        img = img(:,:,1:3);
    catch lasterr
    end
    axes(handles.axes1); imshow(img);
    title('Ảnh gốc', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');
    handles.sourceimage = img;
    set(handles.btn_insertwatermark,'Enable','on')
else
    warndlg('Hãy chọn file ảnh!');
end
guidata(hObject,handles);




% --- Executes on button press in btnImportNhung.
% nhập ảnh nhúng
function btnImportNhung_Callback(hObject, eventdata, handles)

[fname, path]=uigetfile('*.png;*.bmp;*.tif;*.jpg','Chọn thủy vân');
if fname~=0
    watermark = imread([path,fname]);    
    try
        watermark = watermark(:,:,1:3);
    catch lasterr
    end    
    axes(handles.axes2); imshow(watermark);
    title('Ảnh nhúng', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');
    handles.watermarkimage = watermark;
else
    warndlg('Hãy chọn file ảnh!');
end
guidata(hObject,handles);




% --- Lựa chọn thuật toán nhúng thủy vân
function rdLSB_Callback(hObject, eventdata, handles)
handles.output = hObject;
guidata(hObject, handles);
global emb_algorithm;
emb_algorithm = 'lsb';
set(handles.secretkey,'Visible','on')
set(handles.lbTKN,'Visible','on')



function rdDCT_Callback(hObject, eventdata, handles)
handles.output = hObject;
guidata(hObject, handles);
global emb_algorithm;
emb_algorithm = 'dct';
set(handles.secretkey,'Visible','off')
set(handles.lbTKN,'Visible','off')

function rdDWT_Callback(hObject, eventdata, handles)
handles.output = hObject;
guidata(hObject, handles);
global emb_algorithm;
emb_algorithm = 'dwt';
set(handles.secretkey,'Visible','off')
set(handles.lbTKN,'Visible','off')


% --- Executes on button press in btn_insertwatermark.
% nhúng thủy vân ảnh
function btn_insertwatermark_Callback(hObject, eventdata, handles)
global emb_algorithm;

img = handles.sourceimage;
watermark = handles.watermarkimage;

if(emb_algorithm =='lsb')
    disp(['Algorithm used: ', emb_algorithm]);
    embkey = get(handles.secretkey,'String');
    key = str2num(embkey);
    tic;
    watermarked = embed_lsb(img,watermark,key); %loi
    embtime = toc;
    set(handles.embtime,'String',embtime);
    folder_path = './dataset/lsb';
elseif(emb_algorithm=='dct')
    disp(['Algorithm used: ', emb_algorithm]);
    [watermarked, time] = embed_dct(img, watermark);
    embtime = time;
    set(handles.embtime,'String',embtime);
    folder_path = './dataset/dct';
elseif(emb_algorithm=='dwt')
    disp(['Algorithm used: ', emb_algorithm]);
    [watermarked, time] = embed_dwt(img, watermark);
    embtime = time;
    set(handles.embtime,'String',embtime);
    folder_path = './dataset/dwt';
else
    return
end

psnr2 = psnr(img, watermarked);
%imshow(watermarked);
set(handles.watermarkedpsnr, 'String', psnr2);

% Lưu hình ảnh sau khi nhúng thủy vân
%folder_path = './dataset';
file_name = 'watermarked_image.png';
full_path = fullfile(folder_path, file_name);
imwrite(watermarked, full_path);

%imwrite(watermarked, 'watermarked_image.png');
%save_image('Lưu hình ảnh đã nhúng thủy vân', watermarked);

axes(handles.axes3);
imshow(watermarked);
title('Ảnh sau khi nhúng', 'FontName', 'Cambria', 'FontSize', 11, 'FontWeight', 'normal');



function secretkey_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function secretkey_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function figure1_CloseRequestFcn(hObject, ~, ~)
clear global ext_out
clear global w_type
clear global emb_algorithm

delete(hObject);


% --- Executes on button press in btnRefresh1.
function btnRefresh_Callback(hObject, eventdata, handles)
axes(handles.axes1); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes2); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
axes(handles.axes3); % Make averSpec the current axes.
cla reset; % Do a complete and total reset of the axes.
set(handles.secretkey,'String','');

set(handles.embtime,'String','');
set(handles.watermarkedpsnr,'String','');


% --- Executes on button press in btnBackMenu.
function btnBackMenu_Callback(hObject, eventdata, handles)
close;
main_menu
