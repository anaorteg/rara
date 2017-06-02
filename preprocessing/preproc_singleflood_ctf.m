% *********************** ACQ Parameters *********************************

function [ outFolderFile ] = preproc_singleflood_ctf( acqPath,floodFileName, px_x, px_y, nof,fmt)

%preproc_singleflood Defective px, flatfield and dark corrections for ARGUS  
%   raw images must be stored in a folder called "raw" inside acqPath
%   dark and flood images must be stored in a folder called "raw" inside acqPath
%   processed images will be stored iin a folder called "subvolume00"
%   inside acqPath 

% Initialize all stuff
init_x = floor ((600-px_x)/2)-3;
init_y = floor ((600-px_y)/2)-3;
%floodFile=[acqPath 'raw\' floodFileName];
fprintf('Flood file: %s\n',floodFileName);
[fl_aux,refT] =readSimpleBin(floodFileName,px_x ,px_y ,1,fmt,0); 
%fl =  fl_aux(39:38+px_x,21:20+px_y); %crop from ARGUS
fl = fl_aux;
%figure;colormap gray;imagesc(fl);colorbar();
%darkFile=[acqPath 'raw\' darkFileName];
%fprintf('Flood file: %s\n',darkFileName);
%[dark_aux,refT] =readSimpleBin(darkFileName,ff_size ,ff_size ,1,fmt,0); 
%dark = dark_aux(init_x:init_x+px_x-1,init_y:init_y+px_y-1);
%dark = dark_aux(39:38+px_x,21:20+px_y);
%figure;colormap gray;imagesc(fl);colorbar();

disp('Data processing: ');
% For each file
    new_dir ='preproc';
    mkdir(acqPath,new_dir);

for file=1:nof
    %fprintf('Processing file %i of %i\n',file,nof);
    %Read every acquired image

    fname=[acqPath 'raw\'  num2str(file-1) '.ct'] ;   
    %fname=[acqPath  num2str(file-1) '.ct']    
    [img,refT] =readSimpleBin(fname,px_x,px_y,1,fmt,0);
    
    %disp(fname);

    %fname=[acqPath 'raw\'  num2str(file-1) '.ct'] ;
    %[img,~] =readSimpleBin(fname,px_x,px_y,1,'uint16',0);
    %disp(fname)
    outFolderFile=[acqPath 'preproc\' num2str(file-1) '.ct'];
    img_corr = single(img)./single(fl);    
    %if integer_output ==1
    img_corr=img_corr*62000;
    %end

%    outFolderFile
    if(mean(mean(img_corr))<3000)
        %not controlled if defective image is the 0.ct
            copyfile([acqPath 'preproc\' num2str(file-2) '.ct'], [acqPath 'preproc\' num2str(file-1) '.ct']);
    else
    fd = fopen(outFolderFile, 'w+');
    fwrite(fd, img_corr, fmt);
    fclose(fd);
    end
    outFolderFile=[acqPath 'preproc\'];
end