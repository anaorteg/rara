function [ intenVol ] = maskIm( intenROI, intenVol,file,frame,px_x,px_y,nop_f,fmt,ct, acqPath )
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
    dip_initialise;
    [hist, bins]= diphist(intenVol(:,:,1),[]);
    [pks,loc] =findpeaks(hist);
    
    %use size of peaks to find last and second to last and then get the
    %threshold
    
    
    
    
end

