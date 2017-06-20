function [ outFolderFile ] = preproc_multiflood_ctf( acqPath,floodAcqPath, binning, nof,n_angles_step,fmt)
%preproc_singleflood Defective px, flatfield and dark corrections for ARGUS  
%   raw images must be stored in a folder called "raw" inside acqPath
%   dark and flood images must be stored in a folder called "raw" inside acqPath
%   processed images will be stored iin a folder called "subvolume00"
%   inside acqPath 
%% ********************Data Proccesing (DO NOT TOUCH) *********************
% Initialize all stuff
px_x = 3072/binning;
px_y = 1944/binning;
data_format=fmt;
ctf = n_angles_step;


disp('Data processing: ');
    new_dir ='preproc';
    mkdir(acqPath,new_dir);
    %source = [acqPath 'raw\detailedCalibration.txt']
    %dest = [acqPath 'preproc\detailedCalibrationCTF.txt']
    %movefile(source,dest);
% For each file
for file=1:nof
    %fprintf('Processing file %i of %i\n',file,nof)
    %Read every acquired image

    
    floodNum=floor((file-1)/ctf);
    
    fname=[floodAcqPath '' num2str(floodNum) '.ct'];
    [fl,~] =readSimpleBin(fname,px_x,px_y,1,'uint16',0) ;
    
    %disp(fname)

    fname=[acqPath 'subvolume00\'  num2str(file-1) '.ct'] ;
    [img,~] =readSimpleBin(fname,px_x,px_y,1,'uint16',0);
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
    fwrite(fd, img_corr, data_format);
    fclose(fd);
    end
    outFolderFile=[acqPath 'preproc\'];
end

end
 
 
 
 
 
 