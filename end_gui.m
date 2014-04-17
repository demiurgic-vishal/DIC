function varargout = end_gui(varargin)
% END_GUI MATLAB code for end_gui.fig
%      END_GUI, by itself, creates a new END_GUI or raises the existing
%      singleton*.
%
%      H = END_GUI returns the handle to a new END_GUI or the handle to
%      the existing singleton*.
%
%      END_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in END_GUI.M with the given input arguments.
%
%      END_GUI('Property','Value',...) creates a new END_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before end_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to end_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help end_gui

% Last Modified by GUIDE v2.5 26-Sep-2013 00:56:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @end_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @end_gui_OutputFcn, ...
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


% --- Executes just before end_gui is made visible.
function end_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to end_gui (see VARARGIN)

% Choose default command line output for end_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes end_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = end_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Exx.
function Exx_Callback(hObject, eventdata, handles)
% hObject    handle to Exx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_strains('strain-gradient_data',1,0,0,0,0);


% --- Executes on button press in Exy.
function Exy_Callback(hObject, eventdata, handles)
% hObject    handle to Exy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_strains('strain-gradient_data',0,1,0,0,0);


% --- Executes on button press in Eyy.
function Eyy_Callback(hObject, eventdata, handles)
% hObject    handle to Eyy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_strains('strain-gradient_data',0,0,0,1,0);


% --- Executes on button press in Eyx.
function Eyx_Callback(hObject, eventdata, handles)
% hObject    handle to Eyx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_strains('strain-gradient_data',0,0,1,0,0);

% --- Executes on button press in along_x.
function along_x_Callback(hObject, eventdata, handles)
% hObject    handle to along_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_displacements('displ_data',1,0,0);


% --- Executes on button press in along_y.
function along_y_Callback(hObject, eventdata, handles)
% hObject    handle to along_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_displacements('displ_data',0,1,0);


% --- Executes on button press in magnitude.
function magnitude_Callback(hObject, eventdata, handles)
% hObject    handle to magnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_displacements('displ_data',0,0,1);


% --- Executes on button press in vector.
function vector_Callback(hObject, eventdata, handles)
% hObject    handle to vector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_strains('strain-gradient_data',0,0,0,0,1);
