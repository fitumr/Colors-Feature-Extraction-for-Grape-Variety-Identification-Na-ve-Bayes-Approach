function varargout = appGUI(varargin)
% APPGUI MATLAB code for appGUI.fig
%      APPGUI, by itself, creates a new APPGUI or raises the existing
%      singleton*.
%
%      H = APPGUI returns the handle to a new APPGUI or the handle to
%      the existing singleton*.
%
%      APPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APPGUI.M with the given input arguments.
%
%      APPGUI('Property','Value',...) creates a new APPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before appGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to appGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help appGUI

% Last Modified by GUIDE v2.5 07-Dec-2023 22:41:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @appGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @appGUI_OutputFcn, ...
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


% --- Executes just before appGUI is made visible.
function appGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to appGUI (see VARARGIN)

% Choose default command line output for appGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes appGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = appGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% menampilkan menu "browse image"
[nama_file, nama_folder] = uigetfile('*.jpg');

%jika ada nama file yang dipilih maka akan mengeluarkan perintah dibawah ini
if ~isequal(nama_file,0)
    %membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    %menampilkan citra rgb pada axes1
    %menampilkan citra pertama di Axes1
    %title('RGB Image')
    imshow(Img, 'Parent', handles.axes1);

    %menyimpan variabel Img pada lokasi handles agar dapat dipanggil oleh
    %pushbutton yang lain
    handles.Img = Img;
 
    guidata(hObject, handles)
else 
    %jika tidak ada data yang dipilih maka akan kembali
return
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
gambarAsli = double(Img) / 255.0;
% Tentukan nilai gamma (sesuaikan jika diperlukan)
gamma = 1.15;
% Terapkan koreksi gamma
gambarHasil = gambarAsli .^ (1/gamma);
% Konversi gambar hasil kembali ke format uint8 untuk ditampilkan
gambarHasil = uint8(gambarHasil * 255);

handles.Data = gambarHasil;
% Memperbarui data guidata dengan gambar yang telah diproses
% menggunakan Gamma Correction
guidata(hObject, handles);
% Menampilkan citra pertama di Axes2
imshow(gambarHasil, 'Parent', handles.axes2);

% Mengambil citra komplement 
F = gambarHasil;
% Menyimpan citra komplement ke dalam handles.Data
handles.Data = F;
% Memperbarui data guidata dengan citra komplement
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = handles.Data;
image = F;
sigma = 1.0;
filteredImage = imgaussfilt(image, sigma);
%figure, imshow(filteredImage)

handles.Data = filteredImage;
% Memperbarui data guidata dengan gambar yang telah diproses
% menggunakan Gamma Correction
guidata(hObject, handles);
% Menampilkan citra pertama di Axes2
imshow(filteredImage, 'Parent', handles.axes3);

K = filteredImage;
% Menyimpan citra komplement ke dalam handles.Data
handles.Data = K;
% Memperbarui data guidata dengan citra komplement
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
K = handles.Data;
konversi = K;
% Color-Based Segmentation Using K-Means Clustering
cform = makecform('srgb2lab');
lab = applycform(konversi,cform);
%figure, imshow(lab), title('L*a*b color space');

% Menyimpan gambar biner yang telah diproses ke dalam handles.Data
handles.Data = lab;

% Memperbarui data guidata dengan gambar biner yang telah diproses
guidata(hObject, handles);
% Menampilkan citra pertama di Axes2
imshow(lab, 'Parent', handles.axes4);

% Mengambil citra komplement 
S = K;
% Menyimpan citra komplement ke dalam handles.Data
handles.Data = S;
% Memperbarui data guidata dengan citra komplement
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.Data;
segmentasi = S;
% Color-Based Segmentation Using K-Means Clustering
cform = makecform('srgb2lab');
lab = applycform(segmentasi,cform);
%figure, imshow(lab), title('L*a*b color space');

ab = double(lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
 
nColors = 3;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
 
pixel_labels = reshape(cluster_idx,nrows,ncols);
RGB = label2rgb(pixel_labels);
%figure, imshow(RGB,[]), title('image labeled by cluster index');

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);
 
for k = 1:nColors
    color = segmentasi;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
 
%figure,imshow(segmented_images{1}), title('objects in cluster 1');
%figure,imshow(segmented_images{2}), title('objects in cluster 2');
%figure,imshow(segmented_images{3}), title('objects in cluster 3');

% Grape segmentation
area_cluster1 = sum(sum(pixel_labels==1));
area_cluster2 = sum(sum(pixel_labels==2));
area_cluster3 = sum(sum(pixel_labels==3));
 
[~,cluster_grape] = min([area_cluster1,area_cluster2,area_cluster3]);
grape_bw = (pixel_labels==cluster_grape);
grape_bw = imfill(grape_bw,'holes');
grape_bw = bwareaopen(grape_bw,1000);

grape = segmentasi;
R = grape(:,:,1);
G = grape(:,:,2);
B = grape(:,:,3);
R(~grape_bw) = 0;
G(~grape_bw) = 0;
B(~grape_bw) = 0;
grape_rgb = cat(3,R,G,B);
%figure, imshow(grape_rgb), %title('the grape only (RGB Color Space)');

% Menyimpan gambar biner yang telah diproses ke dalam handles.Data
handles.Data = grape_rgb;

% Memperbarui data guidata dengan gambar biner yang telah diproses
guidata(hObject, handles);
% Menampilkan citra pertama di Axes2
imshow(grape_rgb, 'Parent', handles.axes5);

% Mengambil citra komplement 
E = grape_rgb;
% Menyimpan citra komplement ke dalam handles.Data
handles.Data = E;
% Memperbarui data guidata dengan citra komplement
guidata(hObject, handles);



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes5)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
set(handles.edit4,'String',' ')
set(handles.edit5,'String',' ')
set(handles.edit6,'String',' ')
set(handles.edit10,'String',' ')
set(handles.edit11,'String',' ')
set(handles.edit12,'String',' ')
set(handles.edit13,'String',' ')
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit15,'String',precision_uji)

%Menyimpan variabel mean pada lokasi handles agar dapat dipanggil oleh push
%button lain
handles.precision_uji = precision_uji;


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mean_red = handles.mean_red;
mean_green = handles.mean_green;
mean_blue = handles.mean_blue;
std_dev_red = handles.std_dev_red;
std_dev_green = handles.std_dev_green;
std_dev_blue = handles.std_dev_blue;

%menyusun variabel data_latih 
ciri_uji(1,1) = mean_red;
ciri_uji(1,2) = mean_green;
ciri_uji(1,3) = mean_blue;
ciri_uji(1,4) = std_dev_red;
ciri_uji(1,5) = std_dev_green;
ciri_uji(1,6) = std_dev_blue;
    
%memanggil model naive bayes hasil pelatihan
load Mdl
%membaca kelas keluaran hasil dari pengujian
hasil_uji = predict(Mdl,ciri_uji);

%Menampilkan hasil klasifikasi naive bayes pada edit teks 
set(handles.edit13,'String',hasil_uji{1});

%menyimpan variabel hasil_uji pada lokasi handles agar dapat dipanggil oleh
%push button lain
handles.Mdl = Mdl;
handles.hasil_uji = hasil_uji;
guidata(hObject,handles);

handles.Data = hasil_uji;
% Memperbarui data guidata dengan citra komplement
guidata(hObject, handles);


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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E = handles.Data;
ef_warna = E;
%melakukan ekstraksi fitur warna
% Ekstraksi warna
red_channel = ef_warna(:,:,1);
green_channel = ef_warna(:,:,2);
blue_channel = ef_warna(:,:,3);
% Hitung nilai mean dan standar deviasi untuk setiap saluran warna
mean_red = mean(red_channel(:));
mean_green = mean(green_channel(:));
mean_blue = mean(blue_channel(:));
%std_dev_red = std(double(red_channel(:)));
%std_dev_green = std(double(green_channel(:)));
%std_dev_blue = std(double(blue_channel(:)));
% Tampilkan hasil
% disp('Fitur Warna:');
disp(['Mean Red: ', num2str(mean_red)]);
disp(['Mean Green: ', num2str(mean_green)]);
disp(['Mean Blue: ', num2str(mean_blue)]);
%disp(['Std Dev Red: ', num2str(std_dev_red)]);
%disp(['Std Dev Green: ', num2str(std_dev_green)]);
%disp(['Std Dev Blue: ', num2str(std_dev_blue)]);

set(handles.edit4,'String',mean_red)
set(handles.edit5,'String',mean_green)
set(handles.edit6,'String',mean_blue)

%Menyimpan variabel mean pada lokasi handles agar dapat dipanggil oleh push
%button lain
handles.mean_red = mean_red;
handles.mean_green = mean_green;
handles.mean_blue = mean_blue;
guidata(hObject,handles);


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E = handles.Data;
ef_warna = E;
%melakukan ekstraksi fitur warna
% Ekstraksi warna
red_channel = ef_warna(:,:,1);
green_channel = ef_warna(:,:,2);
blue_channel = ef_warna(:,:,3);
% Hitung nilai mean dan standar deviasi untuk setiap saluran warna
%mean_red = mean(red_channel(:));
%mean_green = mean(green_channel(:));
%mean_blue = mean(blue_channel(:));
std_dev_red = std(double(red_channel(:)));
std_dev_green = std(double(green_channel(:)));
std_dev_blue = std(double(blue_channel(:)));
% Tampilkan hasil
% disp('Fitur Warna:');
%disp(['Mean Red: ', num2str(mean_red)]);
%disp(['Mean Green: ', num2str(mean_green)]);
%disp(['Mean Blue: ', num2str(mean_blue)]);
disp(['Std Dev Red: ', num2str(std_dev_red)]);
disp(['Std Dev Green: ', num2str(std_dev_green)]);
disp(['Std Dev Blue: ', num2str(std_dev_blue)]);

set(handles.edit10,'String',std_dev_red)
set(handles.edit11,'String',std_dev_green)
set(handles.edit12,'String',std_dev_blue)

%Menyimpan variabel mean pada lokasi handles agar dapat dipanggil oleh push
%button lain
handles.std_dev_red = std_dev_red;
handles.std_dev_green = std_dev_green;
handles.std_dev_blue = std_dev_blue;
guidata(hObject,handles);
