%extracting the respiratory signal from center of masses in the first
%camera position

load F.mat;
f_s=size(F);
F_orig = F;
Zaxisprofile_orig = zeros(1,f_s(3));
center = zeros(1,f_s(3));
%% Getting the Z-axis-profile for the whole scab
for  j= 1:f_s(3)
    % Find the center of mass per projection
    Pf = F_orig(:,:,j); 
    sumf=sum(Pf,2);    %summation pf in the colum
    cent=centerOfMass(sumf); %finding the centers of mass in each colum
    center(j)=cent(1);    
    RC=round(center(j));
        
    % Select the chip of interest
    if  RC>=1 &&   RC<127 %first chip 
        F = Pf(1:126,:) ;
    elseif  RC>=127 &&   RC<255 %second chip 
        F = Pf(127:254,:) ;
    else  %third chip
        F = Pf(255:382,:) ;
    end 
    % Compute the mean pixel value on the chip of interest in the j
    % projection
    CMean=mean(F,1);
    VMean=mean(CMean,2);
    Zaxisprofile_orig(j)=VMean;  % array saving the mean value per projection
end

%% Start analizing each camera position separately

%dst_path =newSeries(mod_num,beamdata_path,dst_path);

Zaxisprofile = Zaxisprofile_orig(1 : 1243);
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
figure;plot(resp_sig); title(['respiratory signal 1st camera position ']);xlabel('Projection number');
ylabel('Mean intensity)');

%%second camera position
%%extracting the respiratory signal from the centers of the mass

Zaxisprofile = Zaxisprofile_orig(1244: 2486);
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
figure;plot(resp_sig); title(['respiratory signal 2nd camera position ']);xlabel('Projection number');
ylabel('Mean intensity)');

