profile on
srcfiles = dir('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.1\*.dcm');
%for j = 1 : 5
    for j = 1 : length(srcfiles)
    filename = strcat('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.1\',srcfiles(j).name);
    J = dicomread(filename);
    if j==1
        js = size(J);
        jstack=zeros(js(1),js(2),length(srcfiles));
    end
    jstack(:,:,j) = J(:,:,1,1);
    %figure; imshow(jstack(:,:,2220))
    
    
end

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
aux = load('D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2\avg_ff.mat');
meistack = getfield(aux,'meistack_s');
%meistack = meistack_s.meistacks_s;

Filteredim = jstack./meistack;
figure; imshow(Filteredim(:,:,4));title('rawdata/averageflatfield');
Filteredim(1,:,:)=[];
Filteredim(126:131,:,:)=[];
Filteredim(254:258,:,:)=[];
Filteredim(382:end,:,:)=[];
%figure; imshow(Filteredim(:,:,1000));title('rowmasking')
Filteredim(:,1,:)=[];
Filteredim(:,1,:)=[];
Filteredim(:,124:end,:)=[];
figure; imshow(Filteredim(:,:,4));title('pixelmasking');
% Now find the nan's
F=Filteredim;
nanLocations = isnan(F);
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
    index
    
    
    %inside of the dicom
    if (4<x) &&(x<fs(1)-4) && (4<y) && (y<fs(2)-4)
        fprintf('inside %i,%i\n',x,y)
        Fwdw = F(x-4:x+4,y-4:y+4,z);
        xwdw = 5;
        ywdw = 5;
    elseif (x>=fs(1)-4) % Bottom of the dicom
        if(4<y)&&(y<fs(2)-4) %centered
            fprintf('B c %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y+4,z);
            xwdw = 5;
            ywdw = 5;
        elseif (y<=4) %on the left
            fprintf('B L %i,%i\n',x,y)
            Fwdw = F(x-4:x,y:y+4,z);
            xwdw = 5;
            ywdw = 1;
        else %on the right
            fprintf('B R %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        end
        
        
    elseif (y>=fs(2)-4)% Right of the dicom
        if (4<x) && (x<fs(1)-4) %centered
            fprintf('R C %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        elseif x<=4 %on the top
            fprintf('R t %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y,z);
            xwdw = 1;
            ywdw = 5;
        else %on the bottom
            fprintf('R b %i,%i\n',x,y)
            Fwdw = F(x-4:x,y-4:y,z);
            xwdw = 5;
            ywdw = 5;
        end

    elseif (x<=4) % Top of the dicom
        if (4<y )&& (y<fs(2)-4) %centered
            fprintf('T C %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y+4,z);
            xwdw = 1;
            ywdw = 5;
        elseif y<=4 %on the left
            fprintf('T L %i,%i\n',x,y)
            Fwdw = F(x:x+4,y:y+4,z);
            xwdw = 1;
            ywdw = 1;
        else % on the right
            fprintf('T R %i,%i\n',x,y)
            Fwdw = F(x:x+4,y-4:y,z);
            xwdw = 1;
            ywdw = 5;
        end
        
        
    else %Left of the dicom
        if (4<x) && (x<fs(1)-4)%centered
            fprintf('L C %i,%i\n',x,y)
            Fwdw = F(x-4:x+4,y:y+4,z);
            xwdw = 5;
            ywdw = 1;
        elseif x<=4 %on the top
            fprintf('L T %i,%i\n',x,y)
            Fwdw = F(x:x+4,y:y+4,z);
            xwdw = 1;
            ywdw = 1;
        else %on the bottom
             fprintf('L B %i,%i\n',x,y)
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

% u should be fixed now - no nans in it.
% Double check.  Sum of nans should be zero now.
%nanLocations = isnan(F);
%numberOfNans = sum(nanLocations(:));
save D:\1.2.3.2.11.3853\F.mat F %save pathandname variable to store
%figure; imshow(F(:,:,1));title('after point pixel removal')
profile off
profile viewer