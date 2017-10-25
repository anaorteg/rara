profile on
srcfiles = dir('C:\Users\Aortega\Documents\17_10_MARS\gating\New_preprocessed\*.dcm');
%for j = 1 : 5
filename = strcat('C:\Users\Aortega\Documents\17_10_MARS\gating\New_preprocessed\',srcfiles(1).name);
J = dicomread(filename);
jstack(:,:,1) = J(:,:,1,1);
js = size(J);
jstack=zeros(js(1),js(2),length(srcfiles));

%% reading raw dicoms
parfor j = 2 : length(srcfiles)
    filename = strcat('C:\Users\Aortega\Documents\17_10_MARS\gating\New_preprocessed\',srcfiles(j).name);
    J = dicomread(filename);
    jstack(:,:,j) = J(:,:,1,1);
    
end

%% reading flat field dicoms and avg in a single one
% srcfiles = dir('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2\*.dcm');
% for i = 1 : length(srcfiles)
%     filename = strcat('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2\',srcfiles(i).name);
%     I = dicomread(filename);
%     if i==1
%         Is = size(I);
%         Istack=zeros(Is(1),Is(2),length(srcfiles));
%     end
%     Istack(:,:,i) = I(:,:,1,1);
%     %figure, imshow(I);
% end
% meistack= mean(Istack,3);
% meistack_s = meistack;
% save('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2\avg_ff.mat','meistack_s');
%aux = load('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2\avg_ff.mat');
%meistack = getfield(aux,'meistack_s');
%meistack = meistack_s.meistacks_s;

%% flat field correction
%Filteredim = jstack./meistack;
Filteredim = jstack; %19/10 using the corrected dicoms from old MARS sw
figure; imshow(Filteredim(:,:,4));title('rawdata/averageflatfield');
%% remove NaN entire raws and columns
Filteredim(1,:,:)=[];
Filteredim(126:131,:,:)=[];
Filteredim(254:258,:,:)=[];
Filteredim(382:end,:,:)=[];
%figure; imshow(Filteredim(:,:,1000));title('rowmasking')
Filteredim(:,1,:)=[];
Filteredim(:,1,:)=[];
Filteredim(:,124:end,:)=[];
figure; imshow(Filteredim(:,:,4));title('pixelmasking');
%% Now find the nan groups of pixels
F=Filteredim;
nanLocations = isnan(F);
nanLinearIndexes = find(nanLocations);
nonNanLinearIndexes = find(~nanLocations);
% Get the x,y,z of all other locations that are non nan.
[xGood, yGood, zGood] = ind2sub(size(F), nonNanLinearIndexes);
%debug
%firstprojection=find(zGood==1)
%nanLinearIndexes=nanLinearIndexes(nanLinearIndexes<50440);
%end debug
fs = size(F);
for index = 1 : length(nanLinearIndexes)
    thisLinearIndex = nanLinearIndexes(index);
    % Get the x,y,z non location in the projection
    [x,y,z] = ind2sub(fs, thisLinearIndex);
    % debug
    index
    % end debug
    
    % Window arround the pixel to be corrected
    %inside of the dicom
    if (4<x) &&(x<fs(1)-4) && (4<y) && (y<fs(2)-4)
        %debug
        %fprintf('inside %i,%i\n',x,y)
        index_v = [x-4:x+4,y-4:y+4,z];
        Fwdw = F(index_v);
        xwdw = 5;
        ywdw = 5;
    elseif (x>=fs(1)-4) % Bottom of the dicom
        if(4<y)&&(y<fs(2)-4) %centered
            %debug
            %fprintf('B c %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y+4,z);
            xwdw = 5;
            ywdw = 5;
        elseif (y<=4) %on the left
            %debug
            %fprintf('B L %i,%i\n',x,y)
            Fwdw = F(x-4:x,y:y+4,z);
            xwdw = 5;
            ywdw = 1;
        else %on the right
            %debug
            %fprintf('B R %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        end
        
        
    elseif (y>=fs(2)-4)% Right of the dicom
        if (4<x) && (x<fs(1)-4) %centered
            %debug
            %fprintf('R C %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        elseif x<=4 %on the top
            %debug
            %fprintf('R t %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y,z);
            xwdw = 1;
            ywdw = 5;
        else %on the bottom
            %debug
            %fprintf('R b %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        end
        
    elseif (x<=4) % Top of the dicom
        if (4<y )&& (y<fs(2)-4) %centered
            %debug
            %fprintf('T C %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y+4,z);
            xwdw = 1;
            ywdw = 5;
        elseif y<=4 %on the left
            %debug
            %fprintf('T L %i,%i\n',x,y)
            Fwdw = F(x:x+4,y:y+4,z);
            xwdw = 1;
            ywdw = 1;
        else % on the right
            %debug
            %fprintf('T R %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y,z);
            xwdw = 1;
            ywdw = 5;
        end
        
        
    else %Left of the dicom
        if (4<x) && (x<fs(1)-4)%centered
            %debug
            %fprintf('L C %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y:y+4,z);
            xwdw = 5;
            ywdw = 1;
        elseif x<=4 %on the top
            %debug
            %fprintf('L T %i,%i\n',x,y)
            Fwdw = F(x:x+4,y:y+4,z);
            xwdw = 1;
            ywdw = 1;
        else %on the bottom
            %debug
            %fprintf('L B %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y-4:y,z);
            xwdw = 5;
            ywdw = 1;
        end
    end
    
    %% Find the closest nonNaN pixel in the window and replace the NaN in the projection with its value
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

F = F*44000; %44000 stands for the air value in flatfield corrected images by old versions of mars sw
% u should be fixed now - no nans in it.
% Double check.  Sum of nans should be zero now.
%nanLocations = isnan(F);
%numberOfNans = sum(nanLocations(:));
save C:\Users\Aortega\Documents\17_10_MARS\gating\tries\F.mat F %save pathandname variable to store
%figure; imshow(F(:,:,1));title('after point pixel removal')
profile off
profile viewer