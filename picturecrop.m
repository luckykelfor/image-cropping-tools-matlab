function varargout = picturecrop(varargin)
% PICTURECROP M-file for picturecrop.fig
%      PICTURECROP, by itself, creates a new PICTURECROP or raises the existing
%      singleton*.
%
%      H = PICTURECROP returns the handle to a new PICTURECROP or the handle to
%      the existing singleton*.
%
%      PICTURECROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICTURECROP.M with the given input arguments.
%
%      PICTURECROP('Property','Value',...) creates a new PICTURECROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picturecrop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picturecrop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picturecrop

% Last Modified by GUIDE v2.5 02-Nov-2015 18:12:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picturecrop_OpeningFcn, ...
                   'gui_OutputFcn',  @picturecrop_OutputFcn, ...
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


% --- Executes just before picturecrop is made visible.
function picturecrop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picturecrop (see VARARGIN)

global pic_cut down;   
pic_cut=0;
down=0;

% Choose default command line output for picturecrop
handles.output = hObject;

handles.isSizeFixed = 'NO';
set(handles.FixSize,'Visible','Off');
handles.fixedPoint1=[0 0];
handles.fixedPoint2=[0 0];

handles.fixedHeight = 0;
handles.savePath ='d:\';%Ĭ�ϵı���Ŀ¼
handles.openPath = '';
handles.currentPathFileList={};
handles.currentPathFileCount = 0;
handles.currentImageFileName = '';%���浱ǰ�򿪵��ļ�������·��������
handles.tempImage = [];%����Ϊ��ת֮ǰ��ͼ��
handles.savedCutsCount = 0;
handles.fixedWidth = 0;
% Update handles structure

handles.zoomInCount = 10;
handles.zoomOutCount = -10;
handles.zoom = [1 1.2  1.44 2 2.5 2.8 3.5 4 5.5 8];

handles.rotatedVersionImage = [];
guidata(hObject, handles);


% UIWAIT makes picturecrop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = picturecrop_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in search.
function search_Callback(hObject, eventdata, handles)
% hObject    handle to search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.gif','(*.bmp;*.jpg;*.gif)';'*.bmp','(*.bmp)';'*.jpg','(*.jpg)';'*.gif','(*.gif)';},'��ͼƬ');
handles.currentImageFileName = [pathname,filename];
handles.zoomInCount = 10;
handles.zoomOutCount = -10;
A=imread(handles.currentImageFileName);
[height,width,~] = size(A);
handles.tempImage = A;%����δ��ת֮ǰ��ͼ��
handles.rotatedVersionImage = A;%��ʱ��ת�汾ͼ�����ԭͼ
cla(handles.axes1);
axes(handles.axes1);

handles.currentFileList = dir(pathname);%���浱ǰ��ͼ������Ŀ¼���ļ��б�
handles.openPath = pathname;

handles.currentPathFileCount = 0;
imshow(A);
handles.image=A;

set(handles.currentImageHeight,'String',num2str(height));
set(handles.currentImageWidth,'String',num2str(width));

guidata(hObject,handles);





% --- Executes on button press in crop.
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut;
pic_cut=1;
zoom off

handles.begin_point=get(gca,'currentpoint'); %�ȳ�ʼ����ʼ�ĵ�����꣬�������ᱨ��
set(handles.crop,'Visible','Off');

guidata(hObject,handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newdata=handles.newdata;
filename = [handles.savePath,'\\',num2str(handles.savedCutsCount),'.jpg'];

 imwrite(newdata,filename);  
 handles.savedCutsCount = handles.savedCutsCount+1;
  guidata(hObject,handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pic_cut down;
down=1;

    if pic_cut==1&&down==1
%        if(strcmp(handles.isSizeFixed,'NO')
            
          begin_point=get(gca,'currentpoint'); %------����������ʱȡ����굱ǰ������ֵ-------
           handles.begin_point=begin_point;
        
            handles.fixedPoint1=begin_point;%����̶��ߴ�ʱ��ľ�����ʼ��
%        else
         if(strcmp(handles.isSizeFixed,'YES')==1)
           if handles.fixedWidth*handles.fixedHeight~=0       
                data=handles.image;
                axes(handles.axes1);
                imshow(data);
                %------------��rectangle������ʾѡ�е�ͼ���ȡ����------------------------
                rect=floor([handles.fixedPoint1(1,1)-handles.fixedWidth/2,handles.fixedPoint1(1,2)-handles.fixedHeight/2, handles.fixedWidth-1 handles.fixedHeight-1]);
                rectangle('Position',rect,'edgecolor','r','LineWidth',2,'LineStyle','--');

                handles.rect=rect;
                guidata(hObject,handles);
           end
           
         end
    
   end

guidata(hObject,handles);

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut down;
if( strcmp(handles.isSizeFixed , 'NO')==1)
    if pic_cut==1&&down==1
        begin_point=handles.begin_point;
        end_point=get(gca,'currentpoint'); %----------����ƶ�ʱȡ����굱ǰ������ֵ-------

        x0=begin_point(1,1);
        y0=begin_point(1,2);
        x=end_point(1,1);
        y=end_point(1,2);

        width=abs(x-x0);
        handles.fixedWidth = width;
        
        height=abs(y-y0);
        handles.fixedHeight = height;
        rect=floor([min(x,x0) min(y, y0) width-1 height-1]);

       if width*height~=0       
        data=handles.image;
        axes(handles.axes1);
        imshow(data);
        %------------��rectangle������ʾѡ�е�ͼ���ȡ����------------------------
        rectangle('Position',rect,'edgecolor','r','LineWidth',2,'LineStyle','--');

        handles.rect=rect;
        set(handles.sizeofCut,'String',[num2str(floor(width)),'x',num2str(floor(height))]);
        guidata(hObject,handles);
       end
    end
    
    

end
guidata(hObject,handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut down;

% if(strcmp(get(handles.crop,'Visible'),'Off')==1)

    if(strcmp(handles.isSizeFixed, 'NO')==1)
        set(handles.FixSize,'Visible','On');

    end
% end

if(strcmp(handles.isSizeFixed,'NO')==1)
    handles.fixedPoint2 =get(gca,'currentpoint');

    if pic_cut==1
        rect=handles.rect;
        data=handles.image;
        newdata=imcrop(data,rect);%------��ȡͼ���ѡ������---------

       %cla;%----------ȡ��ͼ���ϵľ���ѡ������---------------
       axes(handles.axes2);
       imshow(newdata);

%        pic_cut=0;
       down=0;
       handles.newdata=newdata;
    end
else
    if pic_cut==1
        rect=handles.rect;
        data=handles.image;
        newdata=imcrop(data,rect);%------��ȡͼ���ѡ������---------

       %cla;%----------ȡ��ͼ���ϵľ���ѡ������---------------
       axes(handles.axes2);
       imshow(newdata);

%        pic_cut=0;
       down=0;
       handles.newdata=newdata;
    end  ;
end
guidata(hObject,handles);

% --- Executes on button press in FixSize.
function FixSize_Callback(hObject, eventdata, handles)
% hObject    handle to FixSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if(strcmp(get(handles.crop,'Visible'),'Off')==1)
     if(strcmp(handles.isSizeFixed,'NO')==1) 
         handles.isSizeFixed = 'YES';
         set(handles.FixSize,'String','ȡ���̶�');
         set(handles.editHeight,'Visible','On');
         set(handles.editWidth,'Visible','On');
         set(handles.manualSize,'Visible','On');
         
         set(handles.editHeight,'String',num2str(floor(handles.fixedHeight)));
         set(handles.editWidth,'String',num2str(floor(handles.fixedWidth)));
         
     
     else 
         handles.isSizeFixed = 'NO'
         set(handles.FixSize,'String','�̶�����');
         set(handles.editHeight,'Visible','Off');
         set(handles.editWidth,'Visible','Off');
         set(handles.manualSize,'Visible','Off');
     end
% end
   guidata(hObject,handles);%�ǵø�������


% --- Executes on button press in SavePath.
function SavePath_Callback(hObject, eventdata, handles)
% hObject    handle to SavePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
       handles.savePath = uigetdir('d:\');
       guidata(hObject,handles);%�ǵø�������
       



function editHeight_Callback(hObject, eventdata, handles)
% hObject    handle to editHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHeight as text
%        str2double(get(hObject,'String')) returns contents of editHeight as a double


% --- Executes during object creation, after setting all properties.
function editHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWidth as text
%        str2double(get(hObject,'String')) returns contents of editWidth as a double


% --- Executes during object creation, after setting all properties.
function editWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manualSize.
function manualSize_Callback(hObject, eventdata, handles)
% hObject    handle to manualSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = get(handles.editHeight,'String');
tempH = str2num(state);
state = get(handles.editWidth,'String');
tempW = str2num(state);
if(round(tempH) == 0 || round(tempW) ==0)
    return;
end

handles.fixedHeight = tempH;
handles.fixedWidth = tempW;

set(handles.editHeight,'String',num2str(floor(handles.fixedHeight)));
set(handles.editWidth,'String',num2str(floor(handles.fixedWidth)));
set(handles.sizeofCut,'String',[num2str(floor(handles.fixedWidth)),'x',num2str(floor(handles.fixedHeight))]);

   guidata(hObject,handles);%�ǵø�������
       
         
         


% --- Executes on button press in resizeButton.
function resizeButton_Callback(hObject, eventdata, handles)
% hObject    handle to resizeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = dir(handles.savePath);
for i = 1: size(list,1)
    if(list(i).isdir == 0)%�������Ŀ¼�����ļ�
        fullFileName = [handles.savePath,'\',list(i).name];
        
        if(strcmp(finfo(fullFileName), 'im')==1)%�����ͼ��
        src = imread(fullFileName);
        cols = str2num(get(handles.resizeCols,'String'));
        rows = str2num(get(handles.resizeRows,'String'));
        src = imresize(src,[rows,cols]);
        imwrite(src,fullFileName);
        end
        
    end
end



function resizeCols_Callback(hObject, eventdata, handles)
% hObject    handle to resizeCols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resizeCols as text
%        str2double(get(hObject,'String')) returns contents of resizeCols as a double


% --- Executes during object creation, after setting all properties.
function resizeCols_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resizeCols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resizeRows_Callback(hObject, eventdata, handles)
% hObject    handle to resizeRows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resizeRows as text
%        str2double(get(hObject,'String')) returns contents of resizeRows as a double


% --- Executes during object creation, after setting all properties.
function resizeRows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resizeRows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imageRotate.
function imageRotate_Callback(hObject, eventdata, handles)
% hObject    handle to imageRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.image = handles.tempImage;
rotateTheta = str2num(get(handles.rotateTheta,'String'));
rotatedImage = imrotate(handles.image, rotateTheta,'bilinear');
handles.image = rotatedImage;
handles.rotatedVersionImage = rotatedImage;
axes(handles.axes1);
imshow(handles.image);

 guidata(hObject,handles);%�ǵø�������



function rotateTheta_Callback(hObject, eventdata, handles)
% hObject    handle to rotateTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotateTheta as text
%        str2double(get(hObject,'String')) returns contents of rotateTheta as a double


% --- Executes during object creation, after setting all properties.
function rotateTheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotateTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imageZoomIn.
function imageZoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to imageZoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.zoomInCount = handles.zoomInCount +1;
if(handles.zoomInCount == 20)
    handles.zoomInCount = 10;
end
count = handles.zoomInCount + handles.zoomOutCount;
[M,N,~] = size(handles.rotatedVersionImage);

if(count == 0)
    handles.image = handles.rotatedVersionImage;
elseif(count>0)   
    handles.image = imresize(handles.rotatedVersionImage,round(handles.zoom(count+1))*[M,N]);
else
    handles.image = imresize(handles.rotatedVersionImage,round([M,N]/handles.zoom(-count+1)));
end
 
axes(handles.axes1);
[height, width,~] = size(handles.image);
set(handles.currentImageHeight,'String',num2str(height));
set(handles.currentImageWidth,'String',num2str(width));
guidata(hObject,handles);
imshow(handles.image);




% --- Executes during object creation, after setting all properties.
function imageZoomIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageZoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in imageZoomOut.
function imageZoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to imageZoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.zoomOutCount = handles.zoomOutCount -1;
if(handles.zoomOutCount == -20)
    handles.zoomOutCount = -10;
end
count = handles.zoomInCount + handles.zoomOutCount;
[M,N,~] = size(handles.rotatedVersionImage);
if(count == 0)
    handles.image = handles.rotatedVersionImage;
elseif(count>0)   
    handles.image = imresize(handles.rotatedVersionImage,round(handles.zoom(count+1))*[M,N]);
else
    handles.image = imresize(handles.rotatedVersionImage,round([M,N]/handles.zoom(-count+1)));
end  
[height, width,~] = size(handles.image);
set(handles.currentImageHeight,'String',num2str(height));
set(handles.currentImageWidth,'String',num2str(width));
axes(handles.axes1);
guidata(hObject,handles);
imshow(handles.image);


% --- Executes on button press in iterNextImage.
function iterNextImage_Callback(hObject, eventdata, handles)
% hObject    handle to iterNextImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(strcmp(handles.currentImageFileName,'')==1)%���û�д�ͼ��
    return;
else
    list = handles.currentFileList;
    for i = (handles.currentPathFileCount+1): size(list,1)
        if(list(i).isdir == 0)%�������Ŀ¼�����ļ�
            fullFileName = [handles.openPath,'\',list(i).name];

            if(strcmp(finfo(fullFileName),'im')~=1)%����ǵ�ǰͼ������
                continue;
            elseif(strcmp(fullFileName,handles.currentImageFileName) ~=1)%���ǵ�ǰ��ͼ��
                %������ô򿪺���
                handles.currentImageFileName = fullFileName;
                handles.zoomInCount = 10;
                handles.zoomOutCount = -10;
                A=imread(handles.currentImageFileName);
                [height,width,~] = size(A);
                if(length(size(A))>3)
                    continue;
                end
                handles.tempImage = A;%����δ��ת֮ǰ��ͼ��
                handles.rotatedVersionImage = A;%��ʱ��ת�汾ͼ�����ԭͼ
              %  cla(handles.axes1);
                  axes(handles.axes1);

                  handles.currentPathFileCount = i;
              %  handles.currentFileList = dir(pathname);%���浱ǰ��ͼ������Ŀ¼���ļ��б�
              %  handles.openPath = pathname;
                imshow(A);
                handles.image=A;

                set(handles.currentImageHeight,'String',num2str(height));
                set(handles.currentImageWidth,'String',num2str(width));

               

                break;
            end

        end
        
    end
    guidata(hObject,handles);


end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = dir(handles.savePath);
for i = 1: size(list,1)
    if(list(i).isdir == 0)%�������Ŀ¼�����ļ�
        fullFileName = [handles.savePath,'\',list(i).name];
        
        if(strcmp(finfo(fullFileName), 'im')==1)%�����ͼ��
        src = imread(fullFileName);
        cols = str2num(get(handles.resizeCols,'String'));
        rows = str2num(get(handles.resizeRows,'String'));
        src = imrotate(src,90);
        imwrite(src,fullFileName);
        end
        
    end
end

% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
