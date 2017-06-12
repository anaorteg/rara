function [ output_args ] = avgStep( data_table , binning, nos, nop, width, height, acqPath, readPath, fmt)
% Projection average per angular step.
%   Store one image per angular position as the result of averaging the
%   projections belonging to the same step.
nof = nos*nop; %total number of files
angles = zeros(1,(nof/8));


%create new directory
    new_dir ='Calib';
    mkdir(acqPath,new_dir);
    aux_path  = [acqPath 'Calib'];
    new_dir ='subvolume00';
    mkdir(aux_path,new_dir);
    path_dest = [acqPath 'Calib\subvolume00\'];




for i = 1:(nof/8)
% Average frames
respBlock= zeros(width, height);
    for n= 1:8
        if data_table(3,8*(i-1)+n)==1
            fname = [readPath num2str(8*(i-1)+n-1) '.ct'];
            fprintf('Processing file %i \n',8*(i-1)+n)
            [respFile,refT] =readSimpleBin(fname,width,height,1,fmt);
             respBlock = cat(3, respBlock, respFile);
        end
          

    end
    %average and save file into directory 
    if size(respBlock,3) > 1
    means = mean(respBlock(:,:,2:end), 3);
     fd = fopen([path_dest  num2str(i-1) '.ct'], 'w+');
        fwrite(fd, means, fmt);
        fclose(fd);
    end


        
    %find angle    
    angles(i) = data_table(2,i*8)*0.7; %angular positions in degrees instead of steps
end % for averaging and angles

% Generate the calibration file 
calibFileGenerator(path_dest, angles, binning);

end %function

