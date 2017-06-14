function [ intenVol_masked ] = maskIm( intenROI, intenVol,file,frame,px_x,px_y,nop_f,fmt,ct, acqPath )
%Finding the ROI and masking the image
%   Get user to input initial data to find the ROI and then run the masking
%   program to block unwanted parts of intenVol for all the images

    %% Opening a projection and getting the ROI
        fname = [acqPath num2str(file-1) '.ct'];
        [ct(:,:,frame),refT] =readSimpleBin(fname,px_x,px_y,nop_f,fmt);
        
        ct(:,:,frame)= mean_match(ct(:,:,frame),  65535/2);
        intenVol(:,:,file)=ct(intenROI(1,2):intenROI(4,2),intenROI(1,1):intenROI(2,1),frame);
        
        
    %% Masking the projection
    %see fundamentals for help on this P. 48, 104
    
    %get the bin number for the threshold
    [hist, bins]= diphist(intenVol(:,:,file),[]);
    [pks,loc] =findpeaks(hist(hist>100));
    back = size(pks,2);
    real = back-1;
    back = pks(back);
    real = pks(real);
    thresh = (bins(find(hist==real,1,'last')) + bins(find(hist==real,1,'last')))/2;
    
    %create the mask and then mask the image
    mask = uint16(dip_threshold(intenVol(:,:,file),thresh,0,1,0));
    intenVol(:,:,file) = double(mask).* intenVol(:,:,file);
    intenVol_masked = intenVol(:,:,file);
    intenVol_masked (intenVol_masked == 0)= [];
    
     fd = fopen([path_dest  num2str(file-1) '.ct'], 'w+');
     fwrite(fd, intenVol(:,:,file), fmt);
     fclose(fd);
    
    
    
end

