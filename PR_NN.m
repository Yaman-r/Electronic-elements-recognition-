function varargout = PR_NN(varargin)
% PR_NN MATLAB code for PR_NN.fig
%      PR_NN, by itself, creates a new PR_NN or raises the existing
%      singleton*.
%
%      H = PR_NN returns the handle to a new PR_NN or the handle to
%      the existing singleton*.
%
%      PR_NN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PR_NN.M with the given input arguments.
%
%      PR_NN('Property','Value',...) creates a new PR_NN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PR_NN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PR_NN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PR_NN

% Last Modified by GUIDE v2.5 16-Dec-2015 09:44:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PR_NN_OpeningFcn, ...
                   'gui_OutputFcn',  @PR_NN_OutputFcn, ...
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


% --- Executes just before PR_NN is made visible.
function PR_NN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PR_NN (see VARARGIN)

% Choose default command line output for PR_NN
handles.output = hObject;
global features target info  net im
imm=imread('k.jpg');
imshow(imm);
axis(handles.axes1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PR_NN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PR_NN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global features target 
set(handles.checkbox1,'value',0);
for j=1:2
  name=['l','r','t','c','b','s'];
  format='.JPG';
  n=name(1,j); 
  num_of_samples=str2num(get(handles.edit1,'string'));  
  for i=1:num_of_samples
%Read Image & Image Process
im=imread(strcat(n,num2str(i),format));
%Image Process Algorithm
%-----------------------
% -----------------------
%Step 1 :
%Convert RGB Image to Binary Image ,based on threshold
%-----------------------
%Graythresh:global image threshold using Otsu’s method 
background=imopen(im,strel('disk',15));
level=graythresh(background);
bw=im2bw(background,level);
% ------------
%Step 2 :
%Remove small objects from binary image
%------------
B=bwareaopen(bw,30);
% ------------
%Step 3 :
%Morphologically close image
%------------
se=strel('square',30); 
B=imclose(bw,se);
%figure;imshow(B)
% ------------
%Step 4 :
%Label connected components in Binary Image
%------------
[lebeled,numObjects]=bwlabeln(~B,4);
% ------------
%Step 5 :
%Measure properties of image regions.
info=regionprops(lebeled,'BoundingBox','EulerNumber','Extrema');
%* BoundingBox:The smallest rectangle containing the region
%* EulerNumber:Scalar that specifies the number of objects in the region...
%    ...minus the number of holes in those objects.
%* Extrema: 8-by-2 matrix that specifies the extrema points in the region..
%          ..each row of the matrix contains the x- and y-coordinates of
%          one of the points.
%          The format of the vector is :
%         [top-left,top-right,right-top,right-bottom,bottom-right,bottom-left,left-bottom,left-top]

% Calculate the Aspect Ratio.
imBox = [info.BoundingBox];
features(i+num_of_samples*(j-1),1)=imBox(4)/imBox(3);
% Extrema..
e=info.Extrema;
features(i+num_of_samples*(j-1),2:5)=[sqrt((e(3,2)-e(2,2)).^2+(e(3,1)-e(2,1)).^2),...
    sqrt((e(5,2)-e(4,2)).^2+(e(5,1)-e(4,1)).^2),...
    sqrt((e(7,2)-e(6,2)).^2+(e(7,1)-e(6,1)).^2),...
    sqrt((e(1,2)-e(8,2)).^2+(e(1,1)-e(8,1)).^2)];
% Color
%The sum of pixels -(RED) channel 
z1=sum(sum(im(:,:,1),1),2);
%The sum of pixels -(Green) channel 
z2=sum(sum(im(:,:,2),1),2);
%The sum of pixels -(Blue) channel 
z3=sum(sum(im(:,:,3),1),2);
z=[z1,z2,z3];
s = size(im);
features(i+num_of_samples*(j-1),6:8)=round(z/(s(1)*s(2)));
%Number of Holes
features(i+num_of_samples*(j-1),9)=info.EulerNumber;
    end
end
y=eye(length(name));
for k=1:2
    for h=1:num_of_samples
       target(h+num_of_samples*(k-1),:)=y(k,:);
    end
end
set(handles.checkbox1,'value',1);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL
% Created Wed Dec 16 09:04:53 PKT 2015
%
% This script assumes these variables are defined:
%
%   features - input data.
%   target - target data.
global features target  net
inputs = features';
targets = target';

% Create a Pattern Recognition Network
hiddenLayerSize = str2num(get(handles.edit2,'string'));
net = patternnet(hiddenLayerSize);


% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;


% Train the Network
[net,tr] = train(net,inputs,targets);



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
set(handles.checkbox3,'value',0);
resultOfTest = reconet(read_image(im)');
rres = round(resultOfTest);
set(handles.checkbox3,'value',1);
for q = 1:6
    if rres(1) == 1
        element = 'LED !';
    elseif rres(2) == 1
        element = 'Resistor !';
    elseif rres(3) == 1
        element = 'Transistor !';
    elseif rres(4) == 1
        element = 'Capacitor !';
    elseif rres(5) == 1
        element = 'Piezo Buzzer !';
    elseif rres(6) == 1
        element = 'Push Button !';
    else
        element = 'Unknown :(';
    end
end
set(handles.text24,'string',element);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global info im
[file_name file_path]=uigetfile('*.*');
path=strcat(file_path,file_name); 
im=imread(path);
imshow(im);
axis(handles.axes1);
%Graythresh:global image threshold using Otsu’s method 
background=imopen(im,strel('disk',15));
level=graythresh(background);
bw=im2bw(background,level);
set(handles.checkbox3,'value',0);
%% ------------
%Step 2 :
%Remove small objects from binary image
%------------
B=bwareaopen(bw,30);
%% ------------
%Step 3 :
%Morphologically close image
%------------
se=strel('square',30); 
B=imclose(bw,se);
%figure;imshow(B)
%% ------------
%Step 4 :
%Label connected components in Binary Image
%------------
[lebeled,numObjects]=bwlabeln(~B,4);
%% ------------
%Step 5 :
%Measure properties of image regions.
info=regionprops(lebeled,'BoundingBox','EulerNumber','Extrema');
