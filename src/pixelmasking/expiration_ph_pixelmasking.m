profile on
srcfiles = dir('C:\UOC\ana worktogetermatlab\rara_10-11\src\PHase selectipn\2\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
	error('dcmDir does not contain any files');
end
for k=1:numNames    
    ResortedDataNew{k}=srcfiles(k).name;    
end
[ResortedData,index] = sort_nat(ResortedDataNew); 
stack_index = zeros(1,length(srcfiles));
    for j = 1 :numNames
        filename=(("C:\UOC\ana worktogetermatlab\rara_10-11\src\PHase selectipn\2\"+char(ResortedData(j))));
        %filename = strcat('D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.1\',srcfiles(j).name);
    J = dicomread(char(filename));
    [token, remain]=split(ResortedData(j),'.');
    even_index = str2double(cell2mat(token(7)));%getting the 7th value which correspond to projection location *2
    stack_index(j) = even_index/2;%getting exact projection position
    if j==1
        js = size(J);
        jstack=zeros(js(1),js(2),length(srcfiles));
    end
    jstack(:,:,j) = J(:,:,1,1);
     
   
    end

%% Open every beam dicom and average them into a single one
srcfiles = dir('D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.2\*.dcm');
for i = 1 : length(srcfiles)
    filename = strcat('D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.2\',srcfiles(i).name);
    I = dicomread(filename);
    if i==1
        Is = size(I);
        Istack=zeros(Is(1),Is(2),length(srcfiles));
    end
    Istack(:,:,i) = I(:,:,1,1);
  
end
meistack= mean(Istack,3);
% Save meistack for next runs.
meistack_s = meistack;
save('D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.2\avg_ff.mat','meistack_s');
% Upload meistack from a previous run. 
%aux = load('D:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.2\avg_ff.mat');
%meistack = getfield(aux,'meistack_s');


Filteredim = jstack./meistack;
% Filteredim = jstack; %19/10 using the corrected dicoms from old MARS sw
%Filteredim(1,:,:)=[];
%Filteredim(93,:,:)=[];
Filteredim(127:132,:,:)=[];
Filteredim(255:257,:,:)=[];
%Filteredim(251:251+7,:,:)=[];
%Filteredim(376:end,:,:)=[];
%Filteredim(377:end,:,:)=[];
%figure; imshow(Filteredim(:,:,1000));title('rowmasking')
Filteredim(:,1,:)=[];
Filteredim(:,124:end,:)=[];
figure;colormap gray;imagesc(Filteredim(:,:,53));;title('rawdata/averageflatfield');
% Now find the nan's
F=Filteredim;
F(F>=1)=NaN; % Bright pixels, defective
F(F==0)=NaN; % Zero value pixels, defective
nanLocations= isnan(F);
nanLinearIndexes = find(nanLocations);
nonNanLinearIndexes = find(~nanLocations);
% Get the x,y,z of all other locations that are non nan.
[xGood, yGood, zGood] = ind2sub(size(F), nonNanLinearIndexes);
%firstprojection=find(zGood==1)

%nanLinearIndexes=nanLinearIndexes(nanLinearIndexes<50440);
fs = size(F);
for index = 1 : length(nanLinearIndexes)
    thisLinearIndex = nanLinearIndexes(index);
    % Get the x,y,z non location
    [x,y,z] = ind2sub(fs, thisLinearIndex);
    % TODO: Control the edges!!!
    %neiindexX=find(zGood==z&xGood>x-4&xGood<x+4&yGood>y-4&yGood<y+4);
    %neiindexY=find(zGood==z&yGood>y-4&yGood<y+4&xGood>x-4&xGood<x+4);
    % Get distances of this location to all the other locations
    %index
    
    
    %inside of the dicom
    if (4<x) &&(x<fs(1)-4) && (4<y) && (y<fs(2)-4)
        %fprintf('inside %i,%i\n',x,y)
        Fwdw = F(x-4:x+4,y-4:y+4,z);
        xwdw = 5;
        ywdw = 5;
    elseif (x>=fs(1)-4) % Bottom of the dicom
        if(4<y)&&(y<fs(2)-4) %centered
            %fprintf('B c %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y+4,z);
            xwdw = 5;
            ywdw = 5;
        elseif (y<=4) %on the left
            %fprintf('B L %i,%i\n',x,y)
            Fwdw = F(x-4:x,y:y+4,z);
            xwdw = 5;
            ywdw = 1;
        else %on the right
           % fprintf('B R %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        end
        
        
    elseif (y>=fs(2)-4)% Right of the dicom
        if (4<x) && (x<fs(1)-4) %centered
            %%fprintf('R C %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        elseif x<=4 %on the top
            %fprintf('R t %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y,z);
            xwdw = 1;
            ywdw = 5;
        else %on the bottom
            %fprintf('R b %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        end

    elseif (x<=4) % Top of the dicom
        if (4<y )&& (y<fs(2)-4) %centered
            %fprintf('T C %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y+4,z);
            xwdw = 1;
            ywdw = 5;
        elseif y<=4 %on the left
            %fprintf('T L %i,%i\n',x,y)
            Fwdw = F(x:x+4,y:y+4,z);
            xwdw = 1;
            ywdw = 1;
        else % on the right
            %fprintf('T R %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y,z);
            xwdw = 1;
            ywdw = 5;
        end
        
        
    else %Left of the dicom
        if (4<x) && (x<fs(1)-4)%centered
            %fprintf('L C %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y:y+4,z);
            xwdw = 5;
            ywdw = 1;
        elseif x<=4 %on the top
           % fprintf('L T %i,%i\n',x,y)
            Fwdw = F(x:x+4,y:y+4,z);
            xwdw = 1;
            ywdw = 1;
        else %on the bottom
             %fprintf('L B %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y-4:y,z);
            xwdw = 5;
            ywdw = 1;
        end      
    end
   
    nanLocationswdw = isnan(Fwdw);
    nanLinearIndexeswdw = find(nanLocationswdw);
    nonNanLinearIndexeswdw = find(~nanLocationswdw);
    % Get the x,y,z of all other locations that are non nan.
    [xGoodwdw, yGoodwdw] = ind2sub(size(Fwdw), nonNanLinearIndexeswdw);
    distances = sqrt((xwdw-xGoodwdw).^2 + (ywdw - yGoodwdw) .^ 2 );
    [sortedDistances, sortedIndexes] = sort(distances, 'ascend');
    % The closest non-nan value will be located at index sortedIndexes(1)
    indexOfClosest = sortedIndexes(1);
    % Get the Ffigure; imshow(Filteredim(:,:,1000));title('pixelmasking') value there.
    goodValue = Fwdw(xGoodwdw(indexOfClosest), yGoodwdw(indexOfClosest));
    % Replace the bad nan value in u with the good value.
    F(x,y,z) = goodValue;
            
end

%F = F*44000; %44000 stands for the air value in flatfield corrected images by old versions of mars sw
% u should be fixed now - no nans in it.
% Double check.  Sum of nans should be zero now.
%nanLocations = isnan(F);
%numberOfNans = sum(nanLocations(:));
FEX=F;
save FEX.mat FEX %save pathandname variable to store
save stack_index.mat stack_index
%figure;colormap gray;imagesc(F(:,:,53));tit3le('projection 596 in second camera position');
%profile off
%profile viewer