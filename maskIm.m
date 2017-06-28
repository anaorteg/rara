function [ intenVol_masked ] = maskIm(intenVol,file, path_dest,fmt)
%Finding the ROI and masking the image
%   Get user to input initial data to find the ROI and then run the masking
%   program to block unwanted parts of intenVol for all the images

%Author: NMurty AOrtega (UC3M)

     
    %% Masking the projection
    %see fundamentals for help on this P. 48, 104
    
    %get the bin number for the threshold
    [hist, bins]= histcounts(intenVol(:,:,file));
    [pks,loc] =findpeaks(hist(hist>100));
    back = size(pks,2);
    if back >1
    real = back-1;
    back = pks(back);
    real = pks(real);
    thresh = (bins(find(hist==real,1,'last')) + bins(find(hist==back,1,'last')))/2;
    
    %create the mask and then mask the image
    mask = uint16(dip_threshold(intenVol(:,:,file),thresh,0,1,0));
    intenVol_masked = double(mask).* intenVol(:,:,file);
    intenVol_masked (intenVol_masked == 0) = [];
    else
        intenVol_masked = intenVol(:,:,file);
    end
%      fd = fopen([path_dest  num2str(file-1) '.ct'], 'w+');
%      fwrite(fd, intenVol_masked, fmt);
%      fclose(fd);
    
    
    
end

