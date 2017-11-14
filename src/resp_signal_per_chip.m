%% BEFORE RUNNING SELECT THE NAMES AND PATHS
raw_path='C:\memoey\RECONSTRUCTIONNN\New_preprocessed\'; %ended by \
mod_num = 1; %26/10 Bottom peaks 
%<<<<<<< HEAD
beamdata_path = 'D:\1.2.3.2.11.3853\1.2.3.1.11.3853.2';
dst_path = 'C:\UOC\ana worktogetermatlab\rara_10-11\src\correct f\';
%=======
%dst_path = 'C:\Users\Aortega\Documents\17_10_MARS\gating\tries\from_new_preproc\';
%
%Extracting the bottom peaks in the first and second camera position and
%saving them in bottom_peaks folder

load F.mat ;
f_s=size(F);
F_orig = F;
for ch =1:3
if ch==1   
F = F_orig(1:126,:,:) ;%first chip 
elseif ch==2
F = F_orig(127:254,:,:) ;%second chip
else
    ch==3
F = F_orig(255:382,:,:) ;%third chip 
end
Zaxisprofile = zeros(1,f_s(3));
%outI = zeros(f_s(1),f_s(2));
%m=65535/2;
%F = F/44000;
dst_path =newSeries(mod_num,beamdata_path,dst_path);


for   j= 1:1243 %1st camera position
     %outI = mean_match(F(:,:,j), m);
    outI = F(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end

Zaxisprofile = Zaxisprofile(1 : 1243);
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
%figure;plot(illumination_var); title('Illumination_var 1st camera position);xlabel('Projection number');
%ylabel('Mean intensity)');
%figure;colormap gray;imagesc(outI(:,:,end));
figure;plot(resp_sig); title(['respiratory signal 1st camera position chip',num2str(ch)]);xlabel('Projection number');
ylabel('Mean intensity)');




for  j = 1244 : 2486 %2nd camera position
       %outI = mean_match(F(:,:,j), m);
    outI = F(:,:,j);
    CMean=mean(outI,1);
    VMean=mean(CMean,2);
    Zaxisprofile(j)=VMean;
end

Zaxisprofile = Zaxisprofile(1244 : 2486);
illumination_var = smooth(Zaxisprofile,'rlowess');
illumination_var =  illumination_var';
resp_sig = Zaxisprofile-illumination_var;
%figure;plot(illumination_var);title(' illumination_var in 2nd camera position', 'chip',F');
figure;plot(resp_sig); title(['respiratory signal 2nd camera position chip',num2str(ch)]);xlabel('Projection number');
ylabel('Mean intensity)');

%figure;colormap gray;imagesc(outI(:,:,end));

end


% profile off
% profile viewer
 