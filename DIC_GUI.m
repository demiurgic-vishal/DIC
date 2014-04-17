function varargout = DIC_GUI(varargin)
% DIC_GUI MATLAB code for DIC_GUI.fig
%      DIC_GUI, by itself, creates a new DIC_GUI or raises the existing
%      singleton*.
%
%      H = DIC_GUI returns the handle to a new DIC_GUI or the handle to
%      the existing singleton*.
%
%      DIC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIC_GUI.M with the given input arguments.
%
%      DIC_GUI('Property','Value',...) creates a new DIC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DIC_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DIC_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DIC_GUI

% Last Modified by GUIDE v2.5 25-Sep-2013 22:15:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIC_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DIC_GUI_OutputFcn, ...
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


% --- Executes just before DIC_GUI is made visible.
function DIC_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DIC_GUI (see VARARGIN)

% Choose default command line output for DIC_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DIC_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DIC_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rotation.
function rotation_Callback(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.rigid=get(hObject,'Value');
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of rotation


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load_undeformed.
function load_undeformed_Callback(hObject, eventdata, handles)
% hObject    handle to load_undeformed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[U_FileNameBase,U_PathNameBase,U_FilterIndex]= uigetfile( ...
    {'*.bmp;*.tif;*.jpg;*.TIF;*.BMP;*.JPG;*.gif','Image files (*.bmp,*.tif,*.jpg,*.gif)';'*.*',  'All Files (*.*)'}, ...
    'Open base image for grid creation');
handles.rigid=0;
handles.data1=U_FileNameBase;
handles.data2=U_PathNameBase;
handles.data3=U_FilterIndex;
guidata(hObject, handles);


% --- Executes on button press in load_deformed.
function load_deformed_Callback(hObject, eventdata, handles)
% hObject    handle to load_deformed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[D_FileNameBase,D_PathNameBase,D_FilterIndex]= uigetfile( ...
    {'*.bmp;*.tif;*.jpg;*.TIF;*.BMP;*.JPG;*.gif','Image files (*.bmp,*.tif,*.jpg,*.gif)';'*.*',  'All Files (*.*)'}, ...
    'Open base image for grid creation');
handles.data4=D_FileNameBase;
guidata(hObject, handles);


% --- Executes on button press in Grid.
function Grid_Callback(hObject, eventdata, handles)
% hObject    handle to Grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
displacement_smooth(1,handles.data1,handles.data4,handles.data2,handles.rigid);
